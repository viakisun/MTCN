from fastapi import APIRouter
from app.api.v1 import players, groups, roundings, scores

api_router = APIRouter()

# 각 리소스별 라우터 등록
api_router.include_router(players.router)
api_router.include_router(groups.router)
api_router.include_router(roundings.router)
api_router.include_router(scores.router)


@api_router.get("/ping")
async def ping():
    """
    헬스체크용 엔드포인트
    """
    return {"message": "pong"}
