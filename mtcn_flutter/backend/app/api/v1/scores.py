from fastapi import APIRouter, HTTPException, status, Query
from typing import Optional
from app.schemas.score import (
    ScoreCreate,
    ScoreUpdate,
    ScoreResponse,
    ScoreList
)
from app.services.mock_data import mock_data_service

router = APIRouter(prefix="/scores", tags=["scores"])


@router.get("", response_model=ScoreList)
async def get_scores(
    skip: int = 0,
    limit: int = 100,
    player_id: Optional[str] = None,
    rounding_id: Optional[str] = None
):
    """
    스코어 목록 조회

    - **skip**: 건너뛸 항목 수 (기본값: 0)
    - **limit**: 가져올 항목 수 (기본값: 100)
    - **player_id**: 특정 플레이어의 스코어만 조회 (선택)
    - **rounding_id**: 특정 라운딩의 스코어만 조회 (선택)
    """
    scores = mock_data_service.get_scores(skip=skip, limit=limit)

    # 필터링
    if player_id:
        scores = [s for s in scores if s.player_id == player_id]
    if rounding_id:
        scores = [s for s in scores if s.rounding_id == rounding_id]

    total = len(scores)

    return ScoreList(total=total, items=scores)


@router.get("/{score_id}", response_model=ScoreResponse)
async def get_score(score_id: str):
    """
    특정 스코어 조회

    - **score_id**: 스코어 ID
    """
    score = mock_data_service.get_score(score_id)
    if not score:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Score with id {score_id} not found"
        )
    return score


@router.post("", response_model=ScoreResponse, status_code=status.HTTP_201_CREATED)
async def create_score(score: ScoreCreate):
    """
    새 스코어 생성

    - **player_id**: 플레이어 ID (필수)
    - **rounding_id**: 라운딩 ID (필수)
    - **total_score**: 총 스코어 (필수)
    - **par**: 파 (기본값: 72)
    - **birdies**: 버디 수 (기본값: 0)
    - **pars**: 파 수 (기본값: 0)
    - **bogeys**: 보기 수 (기본값: 0)
    - **hole_scores**: 홀별 스코어 배열 (18개, 필수)
    """
    # 플레이어 존재 확인
    player = mock_data_service.get_player(score.player_id)
    if not player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player with id {score.player_id} not found"
        )

    # 라운딩 존재 확인
    rounding = mock_data_service.get_rounding(score.rounding_id)
    if not rounding:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Rounding with id {score.rounding_id} not found"
        )

    # 홀 스코어 검증
    if len(score.hole_scores) != 18:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="hole_scores must contain exactly 18 scores"
        )

    score_data = score.model_dump()
    new_score = mock_data_service.create_score(score_data)
    return new_score


@router.put("/{score_id}", response_model=ScoreResponse)
async def update_score(score_id: str, score: ScoreUpdate):
    """
    스코어 정보 수정

    - **score_id**: 스코어 ID
    - 수정할 필드만 포함하여 요청 (부분 업데이트 가능)
    """
    # 스코어 존재 확인
    existing_score = mock_data_service.get_score(score_id)
    if not existing_score:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Score with id {score_id} not found"
        )

    # 홀 스코어 검증
    if score.hole_scores and len(score.hole_scores) != 18:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="hole_scores must contain exactly 18 scores"
        )

    # 업데이트
    score_data = score.model_dump(exclude_unset=True)
    updated_score = mock_data_service.update_score(score_id, score_data)

    return updated_score


@router.delete("/{score_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_score(score_id: str):
    """
    스코어 삭제

    - **score_id**: 스코어 ID
    """
    deleted = mock_data_service.delete_score(score_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Score with id {score_id} not found"
        )
    return None


@router.get("/player/{player_id}/recent", response_model=ScoreList)
async def get_recent_scores(
    player_id: str,
    limit: int = Query(default=10, ge=1, le=50)
):
    """
    플레이어의 최근 스코어 조회

    - **player_id**: 플레이어 ID
    - **limit**: 가져올 항목 수 (기본값: 10, 최소: 1, 최대: 50)
    """
    # 플레이어 존재 확인
    player = mock_data_service.get_player(player_id)
    if not player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player with id {player_id} not found"
        )

    scores = mock_data_service.get_recent_scores(player_id, limit)

    return ScoreList(total=len(scores), items=scores)
