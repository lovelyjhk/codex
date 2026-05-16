# Chapter 21 예제 — release-notes Skill

## 그림 36 캡처 — release-notes Skill 설치·실행

이 폴더를 VS Code로 열고, 터미널에서:

```
codex exec --prompt "$release-notes 스킬로 sample-git-log.txt를 릴리스 노트로 변환해 줘"
```

또는 Codex 패널 입력창에서 `$release-notes` 를 선택하고
"sample-git-log.txt를 릴리스 노트로 변환해 줘" 라고 입력한다.

→ Skill이 커밋 로그를 사용자용 릴리스 노트로 변환하는 터미널/패널 화면을 캡처한다.

## 파일
- `skills/release-notes/SKILL.md` — 릴리스 노트 Skill 정의
- `sample-git-log.txt` — 샘플 git 커밋 로그 (입력 데이터)
