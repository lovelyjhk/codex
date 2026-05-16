# 대용량 파일 찾기 유틸리티

지정한 폴더에서 큰 파일을 찾아 크기순으로 보여주는 CLI 도구입니다.

## 실행

```powershell
cd C:\Users\lovel\doit_codex\chapter09
python my_tool.py "C:\Users\lovel\Downloads" --min-mb 100 --top 30
```

현재 폴더를 검색하려면 경로를 생략할 수 있습니다.

```powershell
python my_tool.py --min-mb 50 --top 20
```

CSV로 저장하려면 `--csv`를 사용합니다.

```powershell
python my_tool.py "C:\Users\lovel\Downloads" --min-mb 100 --csv result.csv
```

## EXE 빌드

`build_exe.py`는 PyInstaller가 없으면 자동 설치한 뒤 단일 실행 파일을 만듭니다.
이 도구는 CLI 도구라서 콘솔 창이 표시되며, `--noconsole`은 사용하지 않습니다.

```powershell
cd C:\Users\lovel\doit_codex\chapter09
python build_exe.py
```

빌드 결과는 아래 경로에 생성됩니다.

```text
dist\my_tool.exe
```

## EXE 사용 예시

```powershell
.\dist\my_tool.exe "C:\Users\lovel\Downloads" --min-mb 100 --top 30
```

## 폴더 구조

```text
chapter09/
├─ my_tool.py
├─ build_exe.py
├─ README.md
├─ dist/
│  └─ my_tool.exe
└─ build/
```

## 한글 처리

- 콘솔 출력은 UTF-8로 설정합니다.
- CSV 파일은 Excel에서 한글이 깨지지 않도록 `utf-8-sig`로 저장합니다.
