from __future__ import annotations

from pathlib import Path


def build_email(
    sender: str,
    recipient: str,
    cc: str,
    request: str,
    deadline: str,
    attachment: str,
) -> str:
    return f"""수신자: {recipient}
참조: {cc}
발신자: {sender}

제목: [확인 요청] {request}

안녕하세요, {recipient} 담당자님.
{sender}입니다.

아래 건으로 검토를 요청드립니다.

- 요청 내용: {request}
- 회신 기한: {deadline}
- 첨부 파일: {attachment}

검토 후 회신 부탁드립니다.

감사합니다.
{sender} 드림
"""


if __name__ == "__main__":
    draft = build_email(
        sender="확인 필요",
        recipient="확인 필요",
        cc="확인 필요",
        request="프로젝트 자료 검토 요청",
        deadline="확인 필요",
        attachment="확인 필요",
    )
    out = Path("sample-client-email.md")
    out.write_text(draft, encoding="utf-8")
    print(out.resolve())
