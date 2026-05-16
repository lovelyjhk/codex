# Chapter 23 예제 — 매일 아침 자동 비서

## 그림 44 캡처 — daily_briefing 파일 생성

이 폴더를 VS Code로 열고, 터미널에서:

```
powershell -ExecutionPolicy Bypass -File make_daily_briefing.ps1
```

→ `daily_briefing_<날짜>.md`가 생성된다. EXPLORER에 생성된 파일이 보이고,
터미널에 핵심 변동 사항이 출력된 화면을 함께 캡처한다.

## 파일
- `sources/team-updates.md` — 샘플 팀 소식 (입력 데이터)
- `make_daily_briefing.ps1` — 아침 브리핑 생성 스크립트
