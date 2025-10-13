from fastapi import APIRouter, HTTPException, status
from typing import Optional
from app.schemas.rounding import (
    RoundingCreate,
    RoundingResponse,
    RoundingList,
    RoundingStatus
)
from app.services.mock_data import mock_data_service

router = APIRouter(prefix="/roundings", tags=["roundings"])


@router.get("", response_model=RoundingList)
async def get_roundings(
    skip: int = 0,
    limit: int = 100,
    status: Optional[RoundingStatus] = None
):
    """
    라운딩 목록 조회

    - **skip**: 건너뛸 항목 수 (기본값: 0)
    - **limit**: 가져올 항목 수 (기본값: 100)
    - **status**: 라운딩 상태로 필터링 (선택)
    """
    roundings = mock_data_service.get_roundings(skip=skip, limit=limit)

    # 상태 필터링
    if status:
        roundings = [r for r in roundings if r.status == status]

    total = len(roundings)

    return RoundingList(total=total, items=roundings)


@router.get("/{rounding_id}", response_model=RoundingResponse)
async def get_rounding(rounding_id: str):
    """
    특정 라운딩 조회

    - **rounding_id**: 라운딩 ID
    """
    rounding = mock_data_service.get_rounding(rounding_id)
    if not rounding:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Rounding with id {rounding_id} not found"
        )
    return rounding


@router.post("", response_model=RoundingResponse, status_code=status.HTTP_201_CREATED)
async def create_rounding(rounding: RoundingCreate):
    """
    새 라운딩 생성

    - **event_name**: 이벤트 이름 (필수)
    - **course_name**: 골프장 이름 (필수)
    - **date**: 날짜 (YYYY-MM-DD 형식, 필수)
    - **tee_time**: 티타임 (HH:MM 형식, 필수)
    - **group_id**: 그룹 ID (필수)
    - **player_ids**: 참가 플레이어 ID 목록 (필수)
    - **status**: 라운딩 상태 (기본값: scheduled)
    """
    # 그룹 존재 확인
    group = mock_data_service.get_group(rounding.group_id)
    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Group with id {rounding.group_id} not found"
        )

    # 플레이어 존재 확인
    for player_id in rounding.player_ids:
        player = mock_data_service.get_player(player_id)
        if not player:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Player with id {player_id} not found"
            )

    rounding_data = rounding.model_dump()
    new_rounding = mock_data_service.create_rounding(rounding_data)
    return new_rounding


@router.put("/{rounding_id}", response_model=RoundingResponse)
async def update_rounding(rounding_id: str, rounding: RoundingCreate):
    """
    라운딩 정보 수정

    - **rounding_id**: 라운딩 ID
    - 수정할 모든 필드를 포함하여 요청
    """
    # 라운딩 존재 확인
    existing_rounding = mock_data_service.get_rounding(rounding_id)
    if not existing_rounding:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Rounding with id {rounding_id} not found"
        )

    # 업데이트
    rounding_data = rounding.model_dump()
    updated_rounding = mock_data_service.update_rounding(rounding_id, rounding_data)

    return updated_rounding


@router.delete("/{rounding_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_rounding(rounding_id: str):
    """
    라운딩 삭제

    - **rounding_id**: 라운딩 ID
    """
    deleted = mock_data_service.delete_rounding(rounding_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Rounding with id {rounding_id} not found"
        )
    return None


@router.patch("/{rounding_id}/status", response_model=RoundingResponse)
async def update_rounding_status(rounding_id: str, new_status: RoundingStatus):
    """
    라운딩 상태 업데이트

    - **rounding_id**: 라운딩 ID
    - **new_status**: 새로운 상태 (scheduled, in_progress, completed, cancelled)
    """
    # 라운딩 존재 확인
    existing_rounding = mock_data_service.get_rounding(rounding_id)
    if not existing_rounding:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Rounding with id {rounding_id} not found"
        )

    # 상태 업데이트
    updated_rounding = mock_data_service.update_rounding(
        rounding_id,
        {"status": new_status}
    )

    return updated_rounding
