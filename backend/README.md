# MTCN Golf Backend API

FastAPI 기반의 MTCN Golf 애플리케이션 백엔드 서버입니다.

## 기능

- 플레이어 관리 (CRUD)
- 골프 그룹 관리 (CRUD)
- 라운딩 관리 (CRUD)
- 스코어 관리 (CRUD)
- 한국어 Mock 데이터 제공 (Faker 사용)

## 기술 스택

- **FastAPI**: 고성능 Python 웹 프레임워크
- **Pydantic**: 데이터 검증 및 설정 관리
- **Faker**: Mock 데이터 생성 (한국어 지원)
- **Uvicorn**: ASGI 서버

## 프로젝트 구조

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── players.py      # 플레이어 API 엔드포인트
│   │       ├── groups.py       # 그룹 API 엔드포인트
│   │       ├── roundings.py    # 라운딩 API 엔드포인트
│   │       ├── scores.py       # 스코어 API 엔드포인트
│   │       └── router.py       # API 라우터 통합
│   ├── core/
│   │   └── config.py          # 설정 관리
│   ├── models/                # 데이터베이스 모델 (추후 추가)
│   ├── schemas/               # Pydantic 스키마
│   │   ├── player.py
│   │   ├── group.py
│   │   ├── rounding.py
│   │   └── score.py
│   ├── services/
│   │   └── mock_data.py       # Mock 데이터 서비스
│   └── main.py                # FastAPI 앱 진입점
├── tests/                     # 테스트 코드
├── requirements.txt           # 의존성 패키지
└── README.md                  # 이 파일
```

## 설치 및 실행

### 1. 필수 요구사항

- Python 3.10 이상
- pip

### 2. 의존성 설치

```bash
cd backend
pip install -r requirements.txt
```

### 3. 서버 실행

#### 개발 모드 (자동 재시작)

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### 프로덕션 모드

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### 4. API 문서 확인

서버 실행 후 브라우저에서 다음 URL로 접속:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json

## API 엔드포인트

### 기본 정보

- Base URL: `http://localhost:8000`
- API Version: `v1`
- API Prefix: `/api/v1`

### 헬스체크

#### GET /
루트 엔드포인트, API 상태 확인

```bash
curl http://localhost:8000/
```

#### GET /health
헬스체크 엔드포인트

```bash
curl http://localhost:8000/health
```

#### GET /api/v1/ping
API 핑 테스트

```bash
curl http://localhost:8000/api/v1/ping
```

---

### Players (플레이어)

#### GET /api/v1/players
플레이어 목록 조회

**쿼리 파라미터:**
- `skip` (int, 선택): 건너뛸 항목 수 (기본값: 0)
- `limit` (int, 선택): 가져올 항목 수 (기본값: 100)

**예시:**
```bash
curl http://localhost:8000/api/v1/players?skip=0&limit=10
```

#### GET /api/v1/players/{player_id}
특정 플레이어 조회

**예시:**
```bash
curl http://localhost:8000/api/v1/players/player_001
```

#### POST /api/v1/players
새 플레이어 생성

**요청 본문:**
```json
{
  "name": "홍길동",
  "email": "hong@example.com",
  "phone": "010-1234-5678",
  "handicap": 18,
  "avatar_url": "https://example.com/avatar.jpg",
  "password": "secure_password"
}
```

**예시:**
```bash
curl -X POST http://localhost:8000/api/v1/players \
  -H "Content-Type: application/json" \
  -d '{"name":"홍길동","email":"hong@example.com","password":"test123","handicap":18}'
```

#### PUT /api/v1/players/{player_id}
플레이어 정보 수정

**요청 본문:**
```json
{
  "name": "홍길동",
  "handicap": 15
}
```

**예시:**
```bash
curl -X PUT http://localhost:8000/api/v1/players/player_001 \
  -H "Content-Type: application/json" \
  -d '{"handicap":15}'
```

#### DELETE /api/v1/players/{player_id}
플레이어 삭제

**예시:**
```bash
curl -X DELETE http://localhost:8000/api/v1/players/player_001
```

---

### Groups (그룹)

#### GET /api/v1/groups
그룹 목록 조회

**쿼리 파라미터:**
- `skip` (int, 선택): 건너뛸 항목 수 (기본값: 0)
- `limit` (int, 선택): 가져올 항목 수 (기본값: 100)

**예시:**
```bash
curl http://localhost:8000/api/v1/groups?skip=0&limit=10
```

#### GET /api/v1/groups/{group_id}
특정 그룹 조회

**예시:**
```bash
curl http://localhost:8000/api/v1/groups/group_001
```

#### POST /api/v1/groups
새 그룹 생성

**요청 본문:**
```json
{
  "name": "서울 골프회",
  "description": "매주 주말 라운딩하는 모임",
  "avatar_url": "https://example.com/group.jpg",
  "is_public": true
}
```

**예시:**
```bash
curl -X POST http://localhost:8000/api/v1/groups \
  -H "Content-Type: application/json" \
  -d '{"name":"서울 골프회","description":"주말 라운딩 모임","is_public":true}'
```

#### PUT /api/v1/groups/{group_id}
그룹 정보 수정

**예시:**
```bash
curl -X PUT http://localhost:8000/api/v1/groups/group_001 \
  -H "Content-Type: application/json" \
  -d '{"description":"매주 토요일 라운딩"}'
```

#### DELETE /api/v1/groups/{group_id}
그룹 삭제

**예시:**
```bash
curl -X DELETE http://localhost:8000/api/v1/groups/group_001
```

#### GET /api/v1/groups/{group_id}/members
그룹 멤버 목록 조회

**쿼리 파라미터:**
- `skip` (int, 선택): 건너뛸 항목 수 (기본값: 0)
- `limit` (int, 선택): 가져올 항목 수 (기본값: 100)

**예시:**
```bash
curl http://localhost:8000/api/v1/groups/group_001/members
```

---

### Roundings (라운딩)

#### GET /api/v1/roundings
라운딩 목록 조회

**쿼리 파라미터:**
- `skip` (int, 선택): 건너뛸 항목 수 (기본값: 0)
- `limit` (int, 선택): 가져올 항목 수 (기본값: 100)
- `status` (string, 선택): 라운딩 상태 필터 (scheduled, in_progress, completed, cancelled)

**예시:**
```bash
curl http://localhost:8000/api/v1/roundings?status=scheduled
```

#### GET /api/v1/roundings/{rounding_id}
특정 라운딩 조회

**예시:**
```bash
curl http://localhost:8000/api/v1/roundings/rounding_001
```

#### POST /api/v1/roundings
새 라운딩 생성

**요청 본문:**
```json
{
  "event_name": "월례 라운딩",
  "course_name": "레이크사이드 CC",
  "date": "2025-10-15",
  "tee_time": "08:30",
  "group_id": "group_001",
  "player_ids": ["player_001", "player_002", "player_003", "player_004"],
  "status": "scheduled"
}
```

**예시:**
```bash
curl -X POST http://localhost:8000/api/v1/roundings \
  -H "Content-Type: application/json" \
  -d '{"event_name":"월례 라운딩","course_name":"레이크사이드 CC","date":"2025-10-15","tee_time":"08:30","group_id":"group_001","player_ids":["player_001","player_002"]}'
```

#### PUT /api/v1/roundings/{rounding_id}
라운딩 정보 수정

**예시:**
```bash
curl -X PUT http://localhost:8000/api/v1/roundings/rounding_001 \
  -H "Content-Type: application/json" \
  -d '{"tee_time":"09:00"}'
```

#### DELETE /api/v1/roundings/{rounding_id}
라운딩 삭제

**예시:**
```bash
curl -X DELETE http://localhost:8000/api/v1/roundings/rounding_001
```

#### PATCH /api/v1/roundings/{rounding_id}/status
라운딩 상태 업데이트

**쿼리 파라미터:**
- `new_status` (string, 필수): 새로운 상태 (scheduled, in_progress, completed, cancelled)

**예시:**
```bash
curl -X PATCH "http://localhost:8000/api/v1/roundings/rounding_001/status?new_status=in_progress"
```

---

### Scores (스코어)

#### GET /api/v1/scores
스코어 목록 조회

**쿼리 파라미터:**
- `skip` (int, 선택): 건너뛸 항목 수 (기본값: 0)
- `limit` (int, 선택): 가져올 항목 수 (기본값: 100)
- `player_id` (string, 선택): 특정 플레이어의 스코어만 조회
- `rounding_id` (string, 선택): 특정 라운딩의 스코어만 조회

**예시:**
```bash
curl http://localhost:8000/api/v1/scores?player_id=player_001
```

#### GET /api/v1/scores/{score_id}
특정 스코어 조회

**예시:**
```bash
curl http://localhost:8000/api/v1/scores/score_001
```

#### POST /api/v1/scores
새 스코어 생성

**요청 본문:**
```json
{
  "player_id": "player_001",
  "rounding_id": "rounding_001",
  "total_score": 88,
  "par": 72,
  "birdies": 2,
  "pars": 10,
  "bogeys": 6,
  "hole_scores": [4, 5, 3, 5, 4, 6, 3, 5, 4, 4, 5, 4, 5, 3, 6, 4, 5, 4]
}
```

**예시:**
```bash
curl -X POST http://localhost:8000/api/v1/scores \
  -H "Content-Type: application/json" \
  -d '{"player_id":"player_001","rounding_id":"rounding_001","total_score":88,"hole_scores":[4,5,3,5,4,6,3,5,4,4,5,4,5,3,6,4,5,4]}'
```

#### PUT /api/v1/scores/{score_id}
스코어 정보 수정

**예시:**
```bash
curl -X PUT http://localhost:8000/api/v1/scores/score_001 \
  -H "Content-Type: application/json" \
  -d '{"total_score":85}'
```

#### DELETE /api/v1/scores/{score_id}
스코어 삭제

**예시:**
```bash
curl -X DELETE http://localhost:8000/api/v1/scores/score_001
```

#### GET /api/v1/scores/player/{player_id}/recent
플레이어의 최근 스코어 조회

**쿼리 파라미터:**
- `limit` (int, 선택): 가져올 항목 수 (기본값: 10, 최소: 1, 최대: 50)

**예시:**
```bash
curl http://localhost:8000/api/v1/scores/player/player_001/recent?limit=5
```

---

## Mock 데이터

서버 시작 시 자동으로 생성되는 Mock 데이터:

- **플레이어**: 20명 (한국어 이름, Faker 사용)
- **그룹**: 10개
- **라운딩**: 15개 (과거, 현재, 미래 일정 포함)
- **스코어**: 50개

Mock 데이터는 메모리에 저장되며, 서버 재시작 시 초기화됩니다.

## 응답 형식

### 성공 응답

모든 API는 적절한 HTTP 상태 코드와 함께 JSON 형식으로 응답합니다.

**목록 조회 응답:**
```json
{
  "total": 20,
  "items": [...]
}
```

**단일 항목 응답:**
```json
{
  "id": "player_001",
  "name": "홍길동",
  ...
}
```

### 에러 응답

에러 발생 시 다음 형식으로 응답합니다:

```json
{
  "detail": "Error message here"
}
```

**HTTP 상태 코드:**
- `200 OK`: 성공
- `201 Created`: 생성 성공
- `204 No Content`: 삭제 성공
- `400 Bad Request`: 잘못된 요청
- `404 Not Found`: 리소스를 찾을 수 없음
- `422 Unprocessable Entity`: 유효성 검증 실패
- `500 Internal Server Error`: 서버 에러

## CORS 설정

개발 환경에서는 모든 origin에서의 요청을 허용합니다.

프로덕션 환경에서는 `app/main.py`의 CORS 설정을 수정하여 특정 origin만 허용하도록 변경하세요.

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],  # 허용할 origin 지정
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 환경 변수

`.env` 파일을 생성하여 설정을 커스터마이징할 수 있습니다:

```env
APP_NAME=MTCN Golf API
APP_VERSION=1.0.0
DEBUG=True
```

## 다음 단계

현재는 Mock 데이터를 사용하지만, 실제 프로덕션 환경을 위해서는:

1. **데이터베이스 연동**
   - PostgreSQL 또는 MySQL 설정
   - SQLAlchemy ORM 모델 구현
   - Alembic을 사용한 마이그레이션

2. **인증/인가**
   - JWT 기반 인증 구현
   - OAuth2 통합
   - 역할 기반 접근 제어 (RBAC)

3. **테스트**
   - 단위 테스트 작성
   - 통합 테스트 작성
   - API 테스트 자동화

4. **배포**
   - Docker 컨테이너화
   - CI/CD 파이프라인 구축
   - 클라우드 배포 (AWS, GCP, Azure 등)

## 문제 해결

### 포트 충돌

포트 8000이 이미 사용 중인 경우:

```bash
uvicorn app.main:app --reload --port 8001
```

### 의존성 설치 오류

Python 버전 확인:

```bash
python --version  # 3.10 이상이어야 함
```

가상환경 사용 권장:

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## 라이선스

이 프로젝트는 MTCN Golf 앱의 일부입니다.

## 지원

문제가 발생하거나 질문이 있으면 이슈를 등록해주세요.
