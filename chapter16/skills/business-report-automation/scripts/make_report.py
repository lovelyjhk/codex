from __future__ import annotations

from datetime import date
from pathlib import Path


SAMPLE_INPUT = """\
오늘 고객 문의 자동 분류 기능을 개발했다.
QA 시나리오 검토가 아직 끝나지 않았다.
서버 로그 용량이 부족할 수 있다.
내일까지 개발리드가 일정 공유 예정이다.
"""


def build_report(text: str) -> str:
    return f"""# 업무보고

| 구분 | 내용 |
| --- | --- |
| 보고일 | {date.today().isoformat()} |
| 작성자 | 확인 필요 |
| 프로젝트 | 확인 필요 |

## 1. 금일 진행
- 고객 문의 자동 분류 기능 개발

## 2. 주요 완료
- 확인 필요

## 3. 이슈 및 리스크
| 항목 | 영향 | 대응 |
| --- | --- | --- |
| QA 시나리오 검토 미완료 | 테스트 일정 영향 가능 | 검토 완료일 확인 필요 |
| 서버 로그 용량 부족 가능 | 로그 적재 제약 가능 | 증설 가능 일정 확인 필요 |

## 4. 다음 액션
| 액션 | 담당자 | 기한 | 확인 방법 |
| --- | --- | --- | --- |
| 개발 일정 공유 | 개발리드 | 내일 | 공유 완료 여부 확인 |

## 원문 메모
{text.strip()}
"""


if __name__ == "__main__":
    out = Path("sample-business-report.md")
    out.write_text(build_report(SAMPLE_INPUT), encoding="utf-8")
    print(out.resolve())
