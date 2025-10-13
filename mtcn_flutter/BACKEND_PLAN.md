# MTCN Golf - FastAPI 백엔드 구축 계획

## 🎯 프로젝트 개요

**목표:** 모노리포 구조에서 FastAPI 기반 백엔드 API 구축
**데이터베이스:** Mock 데이터 사용 (추후 PostgreSQL/MongoDB 연동 예정)
**기간:** 20단계 체계적 구축

---

## 📋 20단계 상세 계획

### Phase 1: 프로젝트 초기 설정 (1-5단계)

#### 1️⃣ 모노리포 구조 설계 및 디렉토리 생성

**목표:** Flutter 앱과 FastAPI 백엔드를 하나의 리포지토리에서 관리

**작업 내용:**
```
mtcn_flutter/               # 루트 디렉토리
├── frontend/              # Flutter 앱 (기존 코드 이동)
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
├── backend/               # FastAPI 백엔드 (신규)
│   ├── app/
│   ├── tests/
│   ├── requirements.txt
│   └── pyproject.toml
├── docs/                  # 공유 문서
├── .gitignore
└── README.md
```

**체크리스트:**
- [ ] backend/ 디렉토리 생성
- [ ] 기존 Flutter 코드를 frontend/로 이동 (선택사항)
- [ ] 모노리포 README.md 업데이트

---

#### 2️⃣ FastAPI 프로젝트 초기화 및 의존성 설정

**목표:** Python 환경 및 FastAPI 기본 설정

**작업 내용:**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install fastapi uvicorn pydantic python-dotenv
```

**requirements.txt:**
```txt
fastapi==0.109.0
uvicorn[standard]==0.27.0
pydantic==2.5.0
pydantic-settings==2.1.0
python-dotenv==1.0.0
faker==22.0.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
```

**체크리스트:**
- [ ] Python 3.11+ 설치 확인
- [ ] 가상환경 생성
- [ ] requirements.txt 작성
- [ ] 의존성 설치

---

#### 3️⃣ 개발 환경 설정 (.env, 설정 파일)

**목표:** 환경 변수 및 설정 관리

**backend/.env:**
```env
# App Config
APP_NAME=MTCN Golf API
APP_VERSION=1.0.0
DEBUG=True
ENVIRONMENT=development

# Server
HOST=0.0.0.0
PORT=8000

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:8080,http://127.0.0.1:*

# Security (for future)
SECRET_KEY=your-secret-key-here-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Database (for future)
DATABASE_URL=postgresql://user:pass@localhost/mtcn_golf
```

**backend/app/core/config.py:**
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "MTCN Golf API"
    app_version: str = "1.0.0"
    debug: bool = True
    environment: str = "development"

    host: str = "0.0.0.0"
    port: int = 8000

    cors_origins: list[str] = ["*"]

    secret_key: str = "secret"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    class Config:
        env_file = ".env"

settings = Settings()
```

**체크리스트:**
- [ ] .env 파일 생성
- [ ] .env.example 파일 생성 (Git 공유용)
- [ ] config.py 작성
- [ ] .gitignore에 .env 추가

---

#### 4️⃣ FastAPI 기본 앱 구조 및 라우터 설정

**목표:** Clean Architecture 기반 폴더 구조 생성

**디렉토리 구조:**
```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                 # FastAPI 앱 진입점
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py           # 설정
│   │   └── security.py         # 인증/보안
│   ├── api/
│   │   ├── __init__.py
│   │   ├── deps.py             # 의존성
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── router.py       # 라우터 통합
│   │       ├── players.py
│   │       ├── groups.py
│   │       ├── roundings.py
│   │       └── scores.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── player.py
│   │   ├── group.py
│   │   ├── rounding.py
│   │   └── score.py
│   ├── schemas/                # Pydantic 스키마
│   │   ├── __init__.py
│   │   ├── player.py
│   │   ├── group.py
│   │   ├── rounding.py
│   │   └── score.py
│   ├── services/               # 비즈니스 로직
│   │   ├── __init__.py
│   │   └── mock_data.py
│   └── utils/
│       ├── __init__.py
│       └── helpers.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   └── test_api/
├── .env
├── requirements.txt
└── README.md
```

**backend/app/main.py:**
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1.router import api_router

app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description="MTCN Golf API - Premium Golf Rounding Platform",
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# API 라우터 등록
app.include_router(api_router, prefix="/api/v1")

@app.get("/")
async def root():
    return {
        "message": "MTCN Golf API",
        "version": settings.app_version,
        "status": "running"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

**체크리스트:**
- [ ] 디렉토리 구조 생성
- [ ] main.py 작성
- [ ] 기본 라우터 설정

---

#### 5️⃣ CORS 및 미들웨어 설정

**목표:** Flutter 앱에서 API 호출 가능하도록 CORS 설정

**backend/app/core/middleware.py:**
```python
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
import time
import logging

logger = logging.getLogger(__name__)

class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        start_time = time.time()

        response = await call_next(request)

        process_time = time.time() - start_time
        logger.info(
            f"{request.method} {request.url.path} "
            f"completed in {process_time:.2f}s "
            f"with status {response.status_code}"
        )

        response.headers["X-Process-Time"] = str(process_time)
        return response
```

**main.py 업데이트:**
```python
from app.core.middleware import LoggingMiddleware

app.add_middleware(LoggingMiddleware)
```

**체크리스트:**
- [ ] CORS origins 설정
- [ ] Logging 미들웨어 추가
- [ ] Request/Response 타이밍 측정

---

### Phase 2: 데이터 모델 및 Mock 데이터 (6-7단계)

#### 6️⃣ Pydantic 모델 정의

**목표:** Flutter 앱의 데이터 모델과 동일한 구조 정의

**backend/app/schemas/player.py:**
```python
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class PlayerBase(BaseModel):
    name: str
    email: EmailStr
    phone: Optional[str] = None
    handicap: int = 0
    avatar_url: Optional[str] = None

class PlayerCreate(PlayerBase):
    password: str

class PlayerUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    handicap: Optional[int] = None
    avatar_url: Optional[str] = None

class PlayerResponse(PlayerBase):
    id: str
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class PlayerList(BaseModel):
    total: int
    items: list[PlayerResponse]
```

**backend/app/schemas/group.py:**
```python
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class GroupBase(BaseModel):
    name: str
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    is_public: bool = True

class GroupCreate(GroupBase):
    pass

class GroupUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    is_public: Optional[bool] = None

class GroupResponse(GroupBase):
    id: str
    member_count: int
    round_count: int
    created_at: datetime
    created_by: str

    class Config:
        from_attributes = True

class GroupList(BaseModel):
    total: int
    items: list[GroupResponse]
```

**backend/app/schemas/rounding.py:**
```python
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum

class RoundingStatus(str, Enum):
    SCHEDULED = "scheduled"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class RoundingBase(BaseModel):
    event_name: str
    course_name: str
    date: str
    tee_time: str
    status: RoundingStatus = RoundingStatus.SCHEDULED

class RoundingCreate(RoundingBase):
    group_id: str
    player_ids: list[str]

class RoundingResponse(RoundingBase):
    id: str
    group_id: str
    group_name: str
    player_count: int
    created_at: datetime

    class Config:
        from_attributes = True

class RoundingList(BaseModel):
    total: int
    items: list[RoundingResponse]
```

**backend/app/schemas/score.py:**
```python
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ScoreBase(BaseModel):
    player_id: str
    rounding_id: str
    total_score: int
    par: int = 72
    birdies: int = 0
    pars: int = 0
    bogeys: int = 0
    hole_scores: list[int]  # 18홀 스코어

class ScoreCreate(ScoreBase):
    pass

class ScoreUpdate(BaseModel):
    total_score: Optional[int] = None
    hole_scores: Optional[list[int]] = None

class ScoreResponse(ScoreBase):
    id: str
    player_name: str
    course_name: str
    date: datetime
    created_at: datetime

    class Config:
        from_attributes = True

class ScoreList(BaseModel):
    total: int
    items: list[ScoreResponse]
```

**체크리스트:**
- [ ] Player 스키마 정의
- [ ] Group 스키마 정의
- [ ] Rounding 스키마 정의
- [ ] Score 스키마 정의
- [ ] Response 모델에 pagination 지원

---

#### 7️⃣ Mock 데이터 생성

**목표:** Flutter 앱의 Mock 데이터와 동일한 데이터 생성

**backend/app/services/mock_data.py:**
```python
from faker import Faker
from datetime import datetime, timedelta
import random
from app.schemas.player import PlayerResponse
from app.schemas.group import GroupResponse
from app.schemas.rounding import RoundingResponse, RoundingStatus
from app.schemas.score import ScoreResponse

fake = Faker('ko_KR')

# Mock Players
MOCK_PLAYERS = [
    PlayerResponse(
        id="1",
        name="김민수",
        email="minsu@example.com",
        phone="010-1234-5678",
        handicap=18,
        avatar_url="https://i.pravatar.cc/150?img=1",
        created_at=datetime.now() - timedelta(days=365),
    ),
    PlayerResponse(
        id="2",
        name="이영희",
        email="younghee@example.com",
        phone="010-2345-6789",
        handicap=12,
        avatar_url="https://i.pravatar.cc/150?img=5",
        created_at=datetime.now() - timedelta(days=300),
    ),
    # ... 더 많은 플레이어 추가
]

# Mock Groups
MOCK_GROUPS = [
    GroupResponse(
        id="1",
        name="서울 경영인 골프회",
        description="서울 지역 경영인들의 친목 골프 모임",
        avatar_url="https://i.pravatar.cc/150?img=20",
        is_public=True,
        member_count=45,
        round_count=12,
        created_at=datetime.now() - timedelta(days=500),
        created_by="1",
    ),
    # ... 더 많은 그룹 추가
]

# Mock Roundings
MOCK_ROUNDINGS = [
    RoundingResponse(
        id="1",
        event_name="정기 라운딩",
        course_name="제주 핑크스 골프클럽",
        date="2025-10-15",
        tee_time="07:00",
        status=RoundingStatus.SCHEDULED,
        group_id="1",
        group_name="서울 경영인 골프회",
        player_count=4,
        created_at=datetime.now() - timedelta(days=10),
    ),
    # ... 더 많은 라운딩 추가
]

# Mock Scores
MOCK_SCORES = [
    ScoreResponse(
        id="1",
        player_id="1",
        player_name="김민수",
        rounding_id="1",
        course_name="제주 핑크스 골프클럽",
        total_score=78,
        par=72,
        birdies=2,
        pars=12,
        bogeys=4,
        hole_scores=[4, 3, 5, 4, 4, 3, 5, 4, 4, 4, 3, 5, 4, 4, 3, 5, 4, 4],
        date=datetime.now() - timedelta(days=5),
        created_at=datetime.now() - timedelta(days=5),
    ),
    # ... 더 많은 스코어 추가
]

class MockDataService:
    @staticmethod
    def get_players(skip: int = 0, limit: int = 10):
        return MOCK_PLAYERS[skip:skip + limit]

    @staticmethod
    def get_player_by_id(player_id: str):
        return next((p for p in MOCK_PLAYERS if p.id == player_id), None)

    @staticmethod
    def get_groups(skip: int = 0, limit: int = 10):
        return MOCK_GROUPS[skip:skip + limit]

    @staticmethod
    def get_group_by_id(group_id: str):
        return next((g for g in MOCK_GROUPS if g.id == group_id), None)

    @staticmethod
    def get_roundings(skip: int = 0, limit: int = 10, status: str = None):
        roundings = MOCK_ROUNDINGS
        if status:
            roundings = [r for r in roundings if r.status == status]
        return roundings[skip:skip + limit]

    @staticmethod
    def get_rounding_by_id(rounding_id: str):
        return next((r for r in MOCK_ROUNDINGS if r.id == rounding_id), None)

    @staticmethod
    def get_scores(skip: int = 0, limit: int = 10, player_id: str = None):
        scores = MOCK_SCORES
        if player_id:
            scores = [s for s in scores if s.player_id == player_id]
        return scores[skip:skip + limit]

    @staticmethod
    def get_score_by_id(score_id: str):
        return next((s for s in MOCK_SCORES if s.id == score_id), None)
```

**체크리스트:**
- [ ] Faker 라이브러리로 한국어 데이터 생성
- [ ] 최소 20명의 플레이어 생성
- [ ] 10개의 그룹 생성
- [ ] 15개의 라운딩 생성
- [ ] 50개의 스코어 생성
- [ ] MockDataService 클래스 구현

---

### Phase 3: API 엔드포인트 구현 (8-11단계)

#### 8️⃣ Players API 엔드포인트

**backend/app/api/v1/players.py:**
```python
from fastapi import APIRouter, HTTPException, Query
from app.schemas.player import PlayerResponse, PlayerList, PlayerCreate, PlayerUpdate
from app.services.mock_data import MockDataService

router = APIRouter(prefix="/players", tags=["players"])

@router.get("/", response_model=PlayerList)
async def get_players(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
):
    """모든 플레이어 조회"""
    players = MockDataService.get_players(skip, limit)
    total = len(MockDataService.get_players(0, 1000))
    return PlayerList(total=total, items=players)

@router.get("/{player_id}", response_model=PlayerResponse)
async def get_player(player_id: str):
    """특정 플레이어 조회"""
    player = MockDataService.get_player_by_id(player_id)
    if not player:
        raise HTTPException(status_code=404, detail="Player not found")
    return player

@router.post("/", response_model=PlayerResponse, status_code=201)
async def create_player(player: PlayerCreate):
    """새 플레이어 생성"""
    # Mock: 실제로는 DB에 저장
    return PlayerResponse(
        id=str(len(MOCK_PLAYERS) + 1),
        name=player.name,
        email=player.email,
        phone=player.phone,
        handicap=player.handicap,
        avatar_url=player.avatar_url,
        created_at=datetime.now(),
    )

@router.put("/{player_id}", response_model=PlayerResponse)
async def update_player(player_id: str, player: PlayerUpdate):
    """플레이어 정보 수정"""
    existing = MockDataService.get_player_by_id(player_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Player not found")
    # Mock: 실제로는 DB 업데이트
    return existing

@router.delete("/{player_id}", status_code=204)
async def delete_player(player_id: str):
    """플레이어 삭제"""
    player = MockDataService.get_player_by_id(player_id)
    if not player:
        raise HTTPException(status_code=404, detail="Player not found")
    # Mock: 실제로는 DB에서 삭제
    return None
```

**체크리스트:**
- [ ] GET /api/v1/players (목록 조회)
- [ ] GET /api/v1/players/{id} (상세 조회)
- [ ] POST /api/v1/players (생성)
- [ ] PUT /api/v1/players/{id} (수정)
- [ ] DELETE /api/v1/players/{id} (삭제)

---

#### 9️⃣ Groups API 엔드포인트

**backend/app/api/v1/groups.py:**
```python
from fastapi import APIRouter, HTTPException, Query
from app.schemas.group import GroupResponse, GroupList, GroupCreate, GroupUpdate
from app.services.mock_data import MockDataService

router = APIRouter(prefix="/groups", tags=["groups"])

@router.get("/", response_model=GroupList)
async def get_groups(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    is_public: bool = None,
):
    """모든 그룹 조회"""
    groups = MockDataService.get_groups(skip, limit)
    if is_public is not None:
        groups = [g for g in groups if g.is_public == is_public]
    total = len(MockDataService.get_groups(0, 1000))
    return GroupList(total=total, items=groups)

@router.get("/{group_id}", response_model=GroupResponse)
async def get_group(group_id: str):
    """특정 그룹 조회"""
    group = MockDataService.get_group_by_id(group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    return group

@router.post("/", response_model=GroupResponse, status_code=201)
async def create_group(group: GroupCreate):
    """새 그룹 생성"""
    return GroupResponse(
        id=str(len(MOCK_GROUPS) + 1),
        name=group.name,
        description=group.description,
        avatar_url=group.avatar_url,
        is_public=group.is_public,
        member_count=1,
        round_count=0,
        created_at=datetime.now(),
        created_by="1",  # Mock current user
    )

@router.put("/{group_id}", response_model=GroupResponse)
async def update_group(group_id: str, group: GroupUpdate):
    """그룹 정보 수정"""
    existing = MockDataService.get_group_by_id(group_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Group not found")
    return existing

@router.delete("/{group_id}", status_code=204)
async def delete_group(group_id: str):
    """그룹 삭제"""
    group = MockDataService.get_group_by_id(group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    return None

@router.get("/{group_id}/members", response_model=PlayerList)
async def get_group_members(group_id: str):
    """그룹 멤버 조회"""
    group = MockDataService.get_group_by_id(group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    # Mock: 실제로는 group_members 테이블 조회
    members = MockDataService.get_players(0, 10)
    return PlayerList(total=len(members), items=members)
```

**체크리스트:**
- [ ] GET /api/v1/groups
- [ ] GET /api/v1/groups/{id}
- [ ] POST /api/v1/groups
- [ ] PUT /api/v1/groups/{id}
- [ ] DELETE /api/v1/groups/{id}
- [ ] GET /api/v1/groups/{id}/members

---

#### 🔟 Roundings API 엔드포인트

**backend/app/api/v1/roundings.py:**
```python
from fastapi import APIRouter, HTTPException, Query
from app.schemas.rounding import RoundingResponse, RoundingList, RoundingCreate, RoundingStatus
from app.services.mock_data import MockDataService

router = APIRouter(prefix="/roundings", tags=["roundings"])

@router.get("/", response_model=RoundingList)
async def get_roundings(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    status: RoundingStatus = None,
    group_id: str = None,
):
    """모든 라운딩 조회"""
    roundings = MockDataService.get_roundings(skip, limit, status)
    if group_id:
        roundings = [r for r in roundings if r.group_id == group_id]
    total = len(MockDataService.get_roundings(0, 1000))
    return RoundingList(total=total, items=roundings)

@router.get("/upcoming", response_model=RoundingList)
async def get_upcoming_roundings(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
):
    """예정된 라운딩 조회"""
    roundings = MockDataService.get_roundings(skip, limit, RoundingStatus.SCHEDULED)
    return RoundingList(total=len(roundings), items=roundings)

@router.get("/{rounding_id}", response_model=RoundingResponse)
async def get_rounding(rounding_id: str):
    """특정 라운딩 조회"""
    rounding = MockDataService.get_rounding_by_id(rounding_id)
    if not rounding:
        raise HTTPException(status_code=404, detail="Rounding not found")
    return rounding

@router.post("/", response_model=RoundingResponse, status_code=201)
async def create_rounding(rounding: RoundingCreate):
    """새 라운딩 생성"""
    return RoundingResponse(
        id=str(len(MOCK_ROUNDINGS) + 1),
        event_name=rounding.event_name,
        course_name=rounding.course_name,
        date=rounding.date,
        tee_time=rounding.tee_time,
        status=rounding.status,
        group_id=rounding.group_id,
        group_name="Mock Group",
        player_count=len(rounding.player_ids),
        created_at=datetime.now(),
    )

@router.patch("/{rounding_id}/status", response_model=RoundingResponse)
async def update_rounding_status(rounding_id: str, status: RoundingStatus):
    """라운딩 상태 변경"""
    rounding = MockDataService.get_rounding_by_id(rounding_id)
    if not rounding:
        raise HTTPException(status_code=404, detail="Rounding not found")
    rounding.status = status
    return rounding
```

**체크리스트:**
- [ ] GET /api/v1/roundings
- [ ] GET /api/v1/roundings/upcoming
- [ ] GET /api/v1/roundings/{id}
- [ ] POST /api/v1/roundings
- [ ] PATCH /api/v1/roundings/{id}/status

---

#### 1️⃣1️⃣ Scores API 엔드포인트

**backend/app/api/v1/scores.py:**
```python
from fastapi import APIRouter, HTTPException, Query
from app.schemas.score import ScoreResponse, ScoreList, ScoreCreate, ScoreUpdate
from app.services.mock_data import MockDataService

router = APIRouter(prefix="/scores", tags=["scores"])

@router.get("/", response_model=ScoreList)
async def get_scores(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    player_id: str = None,
    rounding_id: str = None,
):
    """모든 스코어 조회"""
    scores = MockDataService.get_scores(skip, limit, player_id)
    if rounding_id:
        scores = [s for s in scores if s.rounding_id == rounding_id]
    total = len(MockDataService.get_scores(0, 1000))
    return ScoreList(total=total, items=scores)

@router.get("/recent", response_model=ScoreList)
async def get_recent_scores(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    days: int = Query(30, ge=1, le=365),
):
    """최근 스코어 조회"""
    # Mock: 실제로는 날짜 필터링
    scores = MockDataService.get_scores(skip, limit)
    return ScoreList(total=len(scores), items=scores)

@router.get("/{score_id}", response_model=ScoreResponse)
async def get_score(score_id: str):
    """특정 스코어 조회"""
    score = MockDataService.get_score_by_id(score_id)
    if not score:
        raise HTTPException(status_code=404, detail="Score not found")
    return score

@router.post("/", response_model=ScoreResponse, status_code=201)
async def create_score(score: ScoreCreate):
    """새 스코어 생성"""
    return ScoreResponse(
        id=str(len(MOCK_SCORES) + 1),
        player_id=score.player_id,
        player_name="Mock Player",
        rounding_id=score.rounding_id,
        course_name="Mock Course",
        total_score=score.total_score,
        par=score.par,
        birdies=score.birdies,
        pars=score.pars,
        bogeys=score.bogeys,
        hole_scores=score.hole_scores,
        date=datetime.now(),
        created_at=datetime.now(),
    )

@router.put("/{score_id}", response_model=ScoreResponse)
async def update_score(score_id: str, score: ScoreUpdate):
    """스코어 수정"""
    existing = MockDataService.get_score_by_id(score_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Score not found")
    if score.total_score:
        existing.total_score = score.total_score
    if score.hole_scores:
        existing.hole_scores = score.hole_scores
    return existing
```

**체크리스트:**
- [ ] GET /api/v1/scores
- [ ] GET /api/v1/scores/recent
- [ ] GET /api/v1/scores/{id}
- [ ] POST /api/v1/scores
- [ ] PUT /api/v1/scores/{id}

---

### Phase 4: 인증 및 고급 기능 (12-15단계)

#### 1️⃣2️⃣ 인증/권한 Mock 시스템 구현

**목표:** JWT 기반 인증 시스템 (Mock)

**backend/app/core/security.py:**
```python
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from app.core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)
    return encoded_jwt

def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str):
    return pwd_context.hash(password)
```

**backend/app/api/v1/auth.py:**
```python
from fastapi import APIRouter, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from app.core.security import create_access_token, verify_password
from app.schemas.player import PlayerResponse
from app.services.mock_data import MockDataService
from datetime import timedelta

router = APIRouter(prefix="/auth", tags=["auth"])
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """로그인"""
    # Mock: 실제로는 DB에서 사용자 확인
    player = MockDataService.get_player_by_id("1")
    if not player or form_data.username != player.email:
        raise HTTPException(status_code=401, detail="Incorrect username or password")

    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": player.email, "player_id": player.id},
        expires_delta=access_token_expires
    )

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "player": player
    }

@router.get("/me", response_model=PlayerResponse)
async def get_current_user(token: str = Depends(oauth2_scheme)):
    """현재 로그인한 사용자 조회"""
    # Mock: 실제로는 JWT 검증 후 DB에서 조회
    return MockDataService.get_player_by_id("1")
```

**체크리스트:**
- [ ] JWT 토큰 생성/검증 구현
- [ ] POST /api/v1/auth/login
- [ ] GET /api/v1/auth/me
- [ ] OAuth2PasswordBearer 설정

---

#### 1️⃣3️⃣ 페이지네이션 및 필터링 구현

**backend/app/utils/pagination.py:**
```python
from typing import Generic, TypeVar, List
from pydantic import BaseModel

T = TypeVar('T')

class PaginationParams(BaseModel):
    skip: int = 0
    limit: int = 10

    def __init__(self, skip: int = 0, limit: int = 10):
        super().__init__(skip=skip, limit=limit)

class PageResponse(BaseModel, Generic[T]):
    total: int
    page: int
    page_size: int
    total_pages: int
    items: List[T]

    @classmethod
    def create(cls, items: List[T], total: int, skip: int, limit: int):
        return cls(
            total=total,
            page=(skip // limit) + 1,
            page_size=limit,
            total_pages=(total + limit - 1) // limit,
            items=items
        )
```

**사용 예:**
```python
@router.get("/", response_model=PageResponse[PlayerResponse])
async def get_players(skip: int = 0, limit: int = 10):
    players = MockDataService.get_players(skip, limit)
    total = len(MockDataService.get_players(0, 1000))
    return PageResponse.create(players, total, skip, limit)
```

**체크리스트:**
- [ ] PageResponse 제네릭 클래스 구현
- [ ] 모든 목록 API에 페이지네이션 적용
- [ ] 필터링 파라미터 추가 (status, group_id 등)

---

#### 1️⃣4️⃣ 에러 핸들링 및 로깅 설정

**backend/app/core/errors.py:**
```python
from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse
from starlette.status import HTTP_422_UNPROCESSABLE_ENTITY
import logging

logger = logging.getLogger(__name__)

class APIException(HTTPException):
    def __init__(self, status_code: int, detail: str, error_code: str = None):
        super().__init__(status_code=status_code, detail=detail)
        self.error_code = error_code

async def api_exception_handler(request: Request, exc: APIException):
    logger.error(f"API Exception: {exc.detail}")
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": exc.error_code or "API_ERROR",
                "message": exc.detail,
                "path": str(request.url)
            }
        }
    )

async def validation_exception_handler(request: Request, exc):
    logger.error(f"Validation Error: {exc.errors()}")
    return JSONResponse(
        status_code=HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "error": {
                "code": "VALIDATION_ERROR",
                "message": "Invalid request data",
                "details": exc.errors()
            }
        }
    )
```

**backend/app/core/logging_config.py:**
```python
import logging
import sys

def setup_logging():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler('logs/app.log')
        ]
    )
```

**main.py 업데이트:**
```python
from app.core.errors import api_exception_handler, validation_exception_handler, APIException
from fastapi.exceptions import RequestValidationError

app.add_exception_handler(APIException, api_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)
```

**체크리스트:**
- [ ] 커스텀 APIException 클래스
- [ ] Exception handler 구현
- [ ] Logging 설정
- [ ] logs/ 디렉토리 생성

---

#### 1️⃣5️⃣ API 문서화 커스터마이징

**main.py 업데이트:**
```python
app = FastAPI(
    title="MTCN Golf API",
    description="""
    ## MTCN Golf - Premium Golf Rounding Platform API

    이 API는 골프 라운딩 관리를 위한 RESTful API입니다.

    ### 주요 기능
    * **Players** - 플레이어 관리
    * **Groups** - 동문회/그룹 관리
    * **Roundings** - 라운딩 일정 관리
    * **Scores** - 스코어 기록 관리
    * **Authentication** - JWT 기반 인증

    ### 인증
    대부분의 엔드포인트는 JWT Bearer 토큰이 필요합니다.
    `/api/v1/auth/login`으로 로그인 후 토큰을 받으세요.
    """,
    version="1.0.0",
    contact={
        "name": "MTCN Golf Development Team",
        "email": "dev@mtcngolf.com",
    },
    license_info={
        "name": "Proprietary",
    },
    docs_url="/docs",
    redoc_url="/redoc",
)
```

**체크리스트:**
- [ ] API 설명 추가
- [ ] 태그별 그룹화
- [ ] 예시 요청/응답 추가
- [ ] Swagger UI 커스터마이징

---

### Phase 5: 테스팅 및 배포 (16-20단계)

#### 1️⃣6️⃣ 테스트 환경 구축

**backend/requirements-dev.txt:**
```txt
pytest==7.4.0
pytest-asyncio==0.21.0
httpx==0.24.0
pytest-cov==4.1.0
```

**backend/tests/conftest.py:**
```python
import pytest
from fastapi.testclient import TestClient
from app.main import app

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def mock_player():
    return {
        "name": "테스트 사용자",
        "email": "test@example.com",
        "phone": "010-1234-5678",
        "handicap": 15
    }
```

**체크리스트:**
- [ ] pytest 설치
- [ ] TestClient 설정
- [ ] Fixtures 작성
- [ ] conftest.py 구성

---

#### 1️⃣7️⃣ API 엔드포인트 단위 테스트

**backend/tests/test_api/test_players.py:**
```python
def test_get_players(client):
    response = client.get("/api/v1/players/")
    assert response.status_code == 200
    data = response.json()
    assert "total" in data
    assert "items" in data
    assert len(data["items"]) > 0

def test_get_player_by_id(client):
    response = client.get("/api/v1/players/1")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "1"
    assert "name" in data

def test_get_player_not_found(client):
    response = client.get("/api/v1/players/999")
    assert response.status_code == 404

def test_create_player(client, mock_player):
    mock_player["password"] = "testpass123"
    response = client.post("/api/v1/players/", json=mock_player)
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == mock_player["email"]
```

**backend/tests/test_api/test_groups.py:**
```python
def test_get_groups(client):
    response = client.get("/api/v1/groups/")
    assert response.status_code == 200

def test_create_group(client):
    group_data = {
        "name": "테스트 그룹",
        "description": "테스트용 그룹입니다",
        "is_public": True
    }
    response = client.post("/api/v1/groups/", json=group_data)
    assert response.status_code == 201
```

**체크리스트:**
- [ ] Players API 테스트 (CRUD)
- [ ] Groups API 테스트 (CRUD)
- [ ] Roundings API 테스트
- [ ] Scores API 테스트
- [ ] 모든 엔드포인트 커버리지 80% 이상

---

#### 1️⃣8️⃣ Docker 설정

**backend/Dockerfile:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Create logs directory
RUN mkdir -p logs

# Expose port
EXPOSE 8000

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**backend/docker-compose.yml:**
```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DEBUG=True
      - ENVIRONMENT=development
    volumes:
      - ./app:/app/app
      - ./logs:/app/logs
    command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

  # 추후 PostgreSQL 추가
  # db:
  #   image: postgres:15
  #   environment:
  #     POSTGRES_USER: mtcn
  #     POSTGRES_PASSWORD: password
  #     POSTGRES_DB: mtcn_golf
  #   ports:
  #     - "5432:5432"
```

**backend/.dockerignore:**
```
__pycache__
*.pyc
*.pyo
*.pyd
.Python
venv/
.env
.git
.gitignore
logs/
```

**체크리스트:**
- [ ] Dockerfile 작성
- [ ] docker-compose.yml 작성
- [ ] .dockerignore 작성
- [ ] Docker 빌드 테스트

---

#### 1️⃣9️⃣ 백엔드 배포 가이드 문서 작성

**backend/DEPLOYMENT.md:**
```markdown
# MTCN Golf API - 배포 가이드

## 로컬 개발 환경

### 1. 가상환경 설정
\`\`\`bash
python -m venv venv
source venv/bin/activate  # Windows: venv\\Scripts\\activate
pip install -r requirements.txt
\`\`\`

### 2. 환경 변수 설정
\`\`\`bash
cp .env.example .env
# .env 파일 수정
\`\`\`

### 3. 서버 실행
\`\`\`bash
uvicorn app.main:app --reload --port 8000
\`\`\`

## Docker 배포

### 개발 환경
\`\`\`bash
docker-compose up --build
\`\`\`

### 프로덕션 환경
\`\`\`bash
docker build -t mtcn-golf-api .
docker run -p 8000:8000 --env-file .env mtcn-golf-api
\`\`\`

## 클라우드 배포

### AWS EC2
1. EC2 인스턴스 생성 (Ubuntu 22.04)
2. Docker 설치
3. 코드 클론 및 빌드
4. Nginx 리버스 프록시 설정
5. SSL 인증서 설정 (Let's Encrypt)

### Heroku
\`\`\`bash
heroku create mtcn-golf-api
git push heroku main
\`\`\`

### Railway
1. Railway 계정 생성
2. GitHub 연동
3. 자동 배포 설정
```

**체크리스트:**
- [ ] 로컬 개발 가이드
- [ ] Docker 배포 가이드
- [ ] 클라우드 배포 옵션
- [ ] 환경 변수 문서화

---

#### 2️⃣0️⃣ Flutter 앱과 API 통합 테스트

**목표:** Flutter 앱이 백엔드 API와 정상 통신 확인

**Flutter lib/core/api/api_client.dart 업데이트:**
```dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  final String baseUrl;

  ApiClient({this.baseUrl = 'http://localhost:8000'}) :
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

  // Players
  Future<List<Player>> getPlayers({int skip = 0, int limit = 10}) async {
    final response = await dio.get('/api/v1/players/', queryParameters: {
      'skip': skip,
      'limit': limit,
    });
    return (response.data['items'] as List)
      .map((json) => Player.fromJson(json))
      .toList();
  }

  // Groups
  Future<List<Group>> getGroups({int skip = 0, int limit = 10}) async {
    final response = await dio.get('/api/v1/groups/', queryParameters: {
      'skip': skip,
      'limit': limit,
    });
    return (response.data['items'] as List)
      .map((json) => Group.fromJson(json))
      .toList();
  }

  // Roundings
  Future<List<Rounding>> getRoundings({int skip = 0, int limit = 10}) async {
    final response = await dio.get('/api/v1/roundings/', queryParameters: {
      'skip': skip,
      'limit': limit,
    });
    return (response.data['items'] as List)
      .map((json) => Rounding.fromJson(json))
      .toList();
  }
}
```

**Flutter lib/data/repositories/player_repository.dart 업데이트:**
```dart
class ApiPlayerRepository implements PlayerRepository {
  final ApiClient client;

  ApiPlayerRepository(this.client);

  @override
  Future<List<Player>> getAllPlayers() async {
    return await client.getPlayers();
  }

  @override
  Future<Player> getPlayerById(String id) async {
    final response = await client.dio.get('/api/v1/players/$id');
    return Player.fromJson(response.data);
  }
}
```

**통합 테스트 체크리스트:**
- [ ] 백엔드 서버 실행 (http://localhost:8000)
- [ ] Flutter 앱에서 ApiClient 사용
- [ ] GET /api/v1/players 호출 테스트
- [ ] GET /api/v1/groups 호출 테스트
- [ ] GET /api/v1/roundings 호출 테스트
- [ ] 에러 핸들링 테스트
- [ ] CORS 설정 확인

---

## 📊 요약

### 핵심 기술 스택
- **Framework:** FastAPI 0.109+
- **Validation:** Pydantic 2.5+
- **Auth:** JWT (python-jose)
- **Testing:** pytest
- **Containerization:** Docker
- **Documentation:** Swagger/ReDoc

### API 엔드포인트 (총 25개)

#### Players (5개)
- GET /api/v1/players
- GET /api/v1/players/{id}
- POST /api/v1/players
- PUT /api/v1/players/{id}
- DELETE /api/v1/players/{id}

#### Groups (6개)
- GET /api/v1/groups
- GET /api/v1/groups/{id}
- POST /api/v1/groups
- PUT /api/v1/groups/{id}
- DELETE /api/v1/groups/{id}
- GET /api/v1/groups/{id}/members

#### Roundings (5개)
- GET /api/v1/roundings
- GET /api/v1/roundings/upcoming
- GET /api/v1/roundings/{id}
- POST /api/v1/roundings
- PATCH /api/v1/roundings/{id}/status

#### Scores (5개)
- GET /api/v1/scores
- GET /api/v1/scores/recent
- GET /api/v1/scores/{id}
- POST /api/v1/scores
- PUT /api/v1/scores/{id}

#### Auth (2개)
- POST /api/v1/auth/login
- GET /api/v1/auth/me

#### Health (2개)
- GET /
- GET /health

### 다음 단계 (DB 연동 시)
1. PostgreSQL/MongoDB 설정
2. SQLAlchemy/Beanie ORM 추가
3. Alembic 마이그레이션
4. Mock → DB 전환

---

**작성일:** 2025-10-05
**버전:** 1.0.0
**작성자:** MTCN Golf Development Team
