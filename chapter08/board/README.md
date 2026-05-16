# 간단한 게시판 웹앱

FastAPI, SQLite, HTML, 바닐라 JavaScript로 만든 게시판 예제입니다.

## 폴더 구조

```text
board/
├─ main.py
├─ database.db        # 실행 시 자동 생성
├─ static/
│  ├─ index.html
│  ├─ app.js
│  └─ styles.css
└─ README.md
```

## 실행 방법

1. `board` 폴더로 이동합니다.

```powershell
cd C:\Users\lovel\doit_codex\chapter08\board
```

2. 필요한 패키지를 설치합니다.

```powershell
python -m pip install fastapi uvicorn
```

3. 서버를 실행합니다.

```powershell
python main.py
```

4. 브라우저에서 접속합니다.

```text
http://127.0.0.1:8000
```

## 기능

- 글쓰기
- 게시글 목록 보기
- 게시글 상세 보기
- 게시글 삭제
- SQLite 파일 자동 생성
- UTF-8 기반 한글 처리

## API

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/api/posts` | 게시글 목록 |
| POST | `/api/posts` | 게시글 등록 |
| GET | `/api/posts/{post_id}` | 게시글 상세 |
| DELETE | `/api/posts/{post_id}` | 게시글 삭제 |
