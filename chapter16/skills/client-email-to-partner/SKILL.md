---
name: client-email-to-partner
description: Use when drafting, revising, or standardizing Korean emails to business partners, vendors, customers, or external clients. Requires sender, recipient, purpose, request, deadline, attachments, and follow-up items when available.
---

# 거래처 이메일 작성

## 목적

거래처에 보낼 이메일을 정중하고 명확한 비즈니스 문장으로 작성한다.

## 입력으로 받을 수 있는 자료

- 발신자: 보내는 사람 이름, 회사, 부서, 직함
- 수신자: 받는 사람 이름, 회사, 부서, 직함
- 참조: CC 대상
- 이메일 목적: 공지, 요청, 확인, 일정 조율, 후속 안내
- 요청사항
- 회신 기한 또는 처리 마감일
- 첨부 파일명
- 회신받아야 할 내용

## 작업 절차

1. 발신자, 수신자, 참조, 목적, 마감일, 첨부 여부를 먼저 확인한다.
2. 발신자나 수신자가 없으면 `확인 필요`로 표시한다.
3. 이메일 목적을 `공지`, `요청`, `확인`, `일정 조율`, `후속 안내` 중 하나로 분류한다.
4. 제목은 목적과 요청 내용을 기준으로 30자 안팎으로 작성한다.
5. 본문은 인사, 발신자 소개, 배경, 요청사항, 기한, 마무리 순서로 쓴다.
6. 상대가 바로 행동할 수 있도록 확인 항목을 bullet로 정리한다.
7. 마지막에 발신자 서명을 붙인다.

## 출력 형식

```markdown
수신자: 확인 필요
참조: 확인 필요
발신자: 확인 필요

제목: [확인 요청] 프로젝트 자료 검토 요청

안녕하세요, 확인 필요 담당자님.
확인 필요입니다.

아래 건으로 검토를 요청드립니다.

- 요청 내용: 프로젝트 자료 검토
- 회신 기한: 확인 필요
- 첨부 파일: 확인 필요

검토 후 회신 부탁드립니다.

감사합니다.
확인 필요 드림
```

## 참고 파일

- 이메일 문체 기준: `references/email-tone-guide.md`
- 이메일 템플릿: `assets/client-email-template.md`
- 초안 생성 스크립트: `scripts/make_email_draft.py`
