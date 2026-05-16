# 그림 20. Skill 폴더 구조와 SKILL.md 예시

## 1. Skill 폴더 구조 예시

```text
chapter16/
└─ skills/
   ├─ business-report-automation/
   │  ├─ SKILL.md
   │  ├─ scripts/
   │  │  └─ make_report.py
   │  ├─ references/
   │  │  └─ report-style-guide.md
   │  └─ assets/
   │     └─ daily-report-template.md
   │
   └─ client-email-to-partner/
      ├─ SKILL.md
      ├─ scripts/
      │  └─ make_email_draft.py
      ├─ references/
      │  └─ email-tone-guide.md
      └─ assets/
         └─ client-email-template.md
```

## 2. SKILL.md 예시: 업무보고 자동화

```markdown
---
name: business-report-automation
description: Use when creating a Korean business status report from daily notes, task logs, meeting notes, or project updates.
---

# 업무보고 자동화

## 목적

반복되는 업무 메모를 관리자에게 바로 공유할 수 있는 업무보고 형식으로 정리한다.

## 작업 절차

1. 입력 내용을 진행, 완료, 이슈, 리스크, 요청사항으로 분류한다.
2. 날짜, 작성자, 대상 부서가 없으면 `확인 필요`로 표시한다.
3. 숫자, 일정, 담당자는 원문에 있는 정보만 사용한다.
4. 임원 또는 팀장에게 보고 가능한 짧은 문장으로 다듬는다.
5. 마지막에 다음 액션과 확인 방법을 붙인다.
```

## 3. SKILL.md 예시: 거래처 이메일 작성

```markdown
---
name: client-email-to-partner
description: Use when drafting, revising, or standardizing Korean emails to business partners, vendors, customers, or external clients.
---

# 거래처 이메일 작성

## 목적

거래처에 보낼 이메일을 정중하고 명확한 비즈니스 문장으로 작성한다.

## 작업 절차

1. 발신자, 수신자, 참조, 목적, 마감일, 첨부 여부를 먼저 확인한다.
2. 발신자나 수신자가 없으면 `확인 필요`로 표시한다.
3. 제목은 목적과 요청 내용을 기준으로 작성한다.
4. 본문은 인사, 발신자 소개, 요청사항, 기한, 마무리 순서로 쓴다.
5. 마지막에 발신자 서명을 붙인다.
```
