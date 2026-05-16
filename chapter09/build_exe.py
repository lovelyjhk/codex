from __future__ import annotations

import subprocess
import sys
import shutil
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
SCRIPT = BASE_DIR / "my_tool.py"
DIST_DIR = BASE_DIR / "dist"
BUILD_DIR = BASE_DIR / "build"
SPEC_FILE = BASE_DIR / "my_tool.spec"


def run(command: list[str]) -> None:
    print(" ".join(command))
    subprocess.run(command, cwd=BASE_DIR, check=True)


def ensure_pyinstaller() -> None:
    try:
        import PyInstaller  # noqa: F401
    except ImportError:
        run([sys.executable, "-m", "pip", "install", "pyinstaller"])


def main() -> int:
    if not SCRIPT.exists():
        print(f"대상 스크립트가 없습니다: {SCRIPT}", file=sys.stderr)
        return 1

    ensure_pyinstaller()

    command = [
        sys.executable,
        "-m",
        "PyInstaller",
        "--onefile",
        "--clean",
        "--distpath",
        str(DIST_DIR),
        "--workpath",
        str(BUILD_DIR),
        "--specpath",
        str(BASE_DIR),
        "--name",
        "my_tool",
        str(SCRIPT),
    ]
    # my_tool.py는 CLI 도구이므로 --noconsole을 사용하지 않습니다.
    run(command)

    exe_path = DIST_DIR / ("my_tool.exe" if sys.platform.startswith("win") else "my_tool")
    print(f"\n빌드 완료: {exe_path.resolve()}")
    if SPEC_FILE.exists():
        print(f"spec 파일: {SPEC_FILE.resolve()}")
    if BUILD_DIR.exists():
        shutil.rmtree(BUILD_DIR)
        print(f"임시 build 폴더 정리 완료: {BUILD_DIR.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
