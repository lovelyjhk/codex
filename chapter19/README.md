# Chapter 19 예제 — codex exec

## 그림 29 캡처 — codex exec로 JSON 결과 생성

이 폴더를 VS Code로 열고, 터미널에서 실행:

```
codex exec --prompt "sample-prs.md를 읽고 날짜·총 PR 수·작성자별 PR 수를 정리해 줘" --output-schema schema.json > daily_report.json
```

→ `daily_report.json`이 생성되고 터미널에 진행 과정이 표시되면 그 화면을 캡처한다.

## 그림 31 캡처 — 매일 자동 보고서

```
powershell -ExecutionPolicy Bypass -File run_daily_report.ps1
```

→ `reports/daily_<날짜>.md`가 생성된다. EXPLORER에서 reports 폴더가 펼쳐진 상태 + 터미널 출력이 함께 보이게 한 뒤 캡처한다.

## 파일
- `schema.json` — JSON 출력 스키마
- `sample-prs.md` — 샘플 PR 목록 (입력 데이터)
- `run_daily_report.ps1` — 매일 보고서 생성 스크립트
- `reports/` — 보고서 저장 폴더
