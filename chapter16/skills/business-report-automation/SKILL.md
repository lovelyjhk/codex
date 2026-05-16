---
name: business-report-automation
description: Use when creating a Korean daily business report from notes, task logs, meeting notes, or project updates. Produces a concise report with progress, completed work, blockers with causes and needed help, risks, next actions, and manager-ready wording.
---

# 업무보고 자동화

## 목적

반복되는 업무 메모를 관리자에게 바로 공유할 수 있는 업무보고 형식으로 정리한다.

## 입력으로 받을 수 있는 자료

- 오늘 한 일 목록
- 회의록 또는 업무 메모
- 프로젝트 진행 현황
- 이슈, 리스크, 요청사항

## 작업 절차

1. 입력 내용을 `진행`, `완료`, `막힌 일`, `리스크`, `요청사항`으로 분류한다.
2. 막힌 일은 `원인`과 `필요한 도움`을 함께 정리한다.
3. 날짜, 작성자, 대상 부서가 없으면 `[확인 필요]`로 표시한다.
4. 숫자, 일정, 담당자는 원문에 있는 정보만 사용한다.
5. 임원 또는 팀장에게 보고 가능한 짧은 문장으로 다듬는다.
6. 마지막에 다음 액션과 확인 방법을 붙인다.

## 출력 형식

```markdown
# 업무보고

| 구분 | 내용 |
| --- | --- |
| 보고일 | [확인 필요] |
| 작성자 | [확인 필요] |
| 프로젝트 | [확인 필요] |

## 1. 금일 진행
- ...

## 2. 주요 완료
- ...

## 3. 막힌 일
| 막힌 일 | 원인 | 필요한 도움 |
| --- | --- | --- |
| ... | ... | ... |

## 4. 리스크
| 항목 | 영향 | 대응 |
| --- | --- | --- |
| ... | ... | ... |

## 5. 다음 액션
| 액션 | 담당자 | 기한 | 확인 방법 |
| --- | --- | --- | --- |
| ... | ... | ... | ... |
```

## 참고 파일

- 보고서 문체 기준: `references/report-style-guide.md`
- 보고서 템플릿: `assets/daily-report-template.md`
- 샘플 변환 스크립트: `scripts/make_report.py`
