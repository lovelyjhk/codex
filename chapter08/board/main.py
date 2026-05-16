from __future__ import annotations

import sqlite3
from datetime import datetime
from pathlib import Path
from typing import Annotated

import uvicorn
from fastapi import FastAPI, HTTPException, Path as ApiPath
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field


BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "database.db"
STATIC_DIR = BASE_DIR / "static"

app = FastAPI(title="Simple Board", description="FastAPI SQLite 게시판 예제")


class PostCreate(BaseModel):
    title: Annotated[str, Field(min_length=1, max_length=120)]
    author: Annotated[str, Field(min_length=1, max_length=40)]
    content: Annotated[str, Field(min_length=1, max_length=5000)]


class Post(PostCreate):
    id: int
    created_at: str


def row_to_dict(row: sqlite3.Row) -> dict:
    return dict(row)


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db() -> None:
    with get_connection() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS posts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                author TEXT NOT NULL,
                content TEXT NOT NULL,
                created_at TEXT NOT NULL
            )
            """
        )


@app.on_event("startup")
def on_startup() -> None:
    init_db()


@app.get("/")
def index() -> FileResponse:
    return FileResponse(STATIC_DIR / "index.html")


@app.get("/api/posts", response_model=list[Post])
def list_posts() -> list[dict]:
    with get_connection() as conn:
        rows = conn.execute(
            """
            SELECT id, title, author, content, created_at
            FROM posts
            ORDER BY id DESC
            """
        ).fetchall()
    return [row_to_dict(row) for row in rows]


@app.post("/api/posts", response_model=Post, status_code=201)
def create_post(post: PostCreate) -> dict:
    created_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with get_connection() as conn:
        cursor = conn.execute(
            """
            INSERT INTO posts (title, author, content, created_at)
            VALUES (?, ?, ?, ?)
            """,
            (post.title.strip(), post.author.strip(), post.content.strip(), created_at),
        )
        row = conn.execute(
            """
            SELECT id, title, author, content, created_at
            FROM posts
            WHERE id = ?
            """,
            (cursor.lastrowid,),
        ).fetchone()
    if row is None:
        raise HTTPException(status_code=500, detail="게시글 저장에 실패했습니다.")
    return row_to_dict(row)


@app.get("/api/posts/{post_id}", response_model=Post)
def get_post(
    post_id: Annotated[int, ApiPath(ge=1, description="게시글 ID")]
) -> dict:
    with get_connection() as conn:
        row = conn.execute(
            """
            SELECT id, title, author, content, created_at
            FROM posts
            WHERE id = ?
            """,
            (post_id,),
        ).fetchone()
    if row is None:
        raise HTTPException(status_code=404, detail="게시글을 찾을 수 없습니다.")
    return row_to_dict(row)


@app.delete("/api/posts/{post_id}", status_code=204)
def delete_post(
    post_id: Annotated[int, ApiPath(ge=1, description="게시글 ID")]
) -> None:
    with get_connection() as conn:
        cursor = conn.execute("DELETE FROM posts WHERE id = ?", (post_id,))
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="게시글을 찾을 수 없습니다.")


app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")


if __name__ == "__main__":
    init_db()
    uvicorn.run(app, host="127.0.0.1", port=8000)
