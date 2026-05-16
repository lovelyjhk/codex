from __future__ import annotations

import argparse
import csv
import heapq
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


DEFAULT_MIN_MB = 100
DEFAULT_TOP = 30


@dataclass(frozen=True)
class FileInfo:
    size: int
    path: Path


def configure_console() -> None:
    """Keep Korean paths readable in Windows consoles and redirected output."""
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8")
        except AttributeError:
            pass


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="my_tool",
        description="지정한 폴더에서 대용량 파일을 찾아 크기순으로 보여줍니다.",
    )
    parser.add_argument(
        "path",
        nargs="?",
        default=".",
        help="검색할 폴더 경로입니다. 기본값은 현재 폴더입니다.",
    )
    parser.add_argument(
        "--min-mb",
        type=float,
        default=DEFAULT_MIN_MB,
        help=f"결과에 포함할 최소 파일 크기(MB)입니다. 기본값은 {DEFAULT_MIN_MB}입니다.",
    )
    parser.add_argument(
        "--top",
        type=int,
        default=DEFAULT_TOP,
        help=f"크기순으로 표시할 최대 개수입니다. 기본값은 {DEFAULT_TOP}입니다.",
    )
    parser.add_argument(
        "--csv",
        type=Path,
        help="결과를 CSV 파일로 저장할 경로입니다.",
    )
    parser.add_argument(
        "--include-hidden",
        action="store_true",
        help="숨김 폴더와 숨김 파일도 검색합니다.",
    )
    return parser.parse_args()


def is_hidden(path: Path) -> bool:
    if path.name.startswith("."):
        return True

    if os.name != "nt":
        return False

    try:
        import ctypes

        attrs = ctypes.windll.kernel32.GetFileAttributesW(str(path))
        if attrs == -1:
            return False
        return bool(attrs & 0x2)
    except Exception:
        return False


def iter_files(root: Path, include_hidden: bool) -> Iterable[FileInfo]:
    stack = [root]

    while stack:
        current = stack.pop()
        try:
            with os.scandir(current) as entries:
                for entry in entries:
                    try:
                        path = Path(entry.path)
                        if not include_hidden and is_hidden(path):
                            continue
                        if entry.is_dir(follow_symlinks=False):
                            stack.append(path)
                        elif entry.is_file(follow_symlinks=False):
                            stat = entry.stat(follow_symlinks=False)
                            yield FileInfo(size=stat.st_size, path=path)
                    except (OSError, PermissionError):
                        continue
        except (OSError, PermissionError):
            continue


def find_large_files(root: Path, min_bytes: int, top: int, include_hidden: bool) -> list[FileInfo]:
    files = (item for item in iter_files(root, include_hidden) if item.size >= min_bytes)
    return heapq.nlargest(top, files, key=lambda item: item.size)


def human_size(size: int) -> str:
    units = ["B", "KB", "MB", "GB", "TB"]
    value = float(size)
    for unit in units:
        if value < 1024 or unit == units[-1]:
            return f"{value:,.1f} {unit}" if unit != "B" else f"{int(value):,} B"
        value /= 1024
    return f"{size:,} B"


def print_results(root: Path, results: list[FileInfo]) -> None:
    print(f"\n검색 경로: {root}")
    print(f"결과 개수: {len(results)}개\n")

    if not results:
        print("조건에 맞는 대용량 파일이 없습니다.")
        return

    width = len(str(len(results)))
    for index, item in enumerate(results, 1):
        print(f"{index:>{width}}. {human_size(item.size):>12}  {item.path}")


def save_csv(csv_path: Path, results: list[FileInfo]) -> None:
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    with csv_path.open("w", newline="", encoding="utf-8-sig") as file:
        writer = csv.writer(file)
        writer.writerow(["rank", "size_bytes", "size_readable", "path"])
        for index, item in enumerate(results, 1):
            writer.writerow([index, item.size, human_size(item.size), str(item.path)])
    print(f"\nCSV 저장 완료: {csv_path.resolve()}")


def main() -> int:
    configure_console()
    args = parse_args()

    root = Path(args.path).expanduser().resolve()
    if not root.exists():
        print(f"오류: 경로를 찾을 수 없습니다. {root}", file=sys.stderr)
        return 1
    if not root.is_dir():
        print(f"오류: 폴더 경로를 입력해야 합니다. {root}", file=sys.stderr)
        return 1
    if args.min_mb < 0:
        print("오류: --min-mb는 0 이상이어야 합니다.", file=sys.stderr)
        return 1
    if args.top < 1:
        print("오류: --top은 1 이상이어야 합니다.", file=sys.stderr)
        return 1

    min_bytes = int(args.min_mb * 1024 * 1024)
    print("대용량 파일 검색을 시작합니다...")
    print(f"최소 크기: {args.min_mb:g} MB")
    print(f"최대 표시: {args.top}개")

    results = find_large_files(root, min_bytes, args.top, args.include_hidden)
    print_results(root, results)

    if args.csv:
        save_csv(args.csv, results)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
