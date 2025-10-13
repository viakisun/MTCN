from fastapi import APIRouter, HTTPException, status
from typing import Optional
from app.schemas.player import (
    PlayerCreate,
    PlayerUpdate,
    PlayerResponse,
    PlayerList
)
from app.services.mock_data import mock_data_service

router = APIRouter(prefix="/players", tags=["players"])


@router.get("", response_model=PlayerList)
async def get_players(
    skip: int = 0,
    limit: int = 100
):
    """
    플레이어 목록 조회

    - **skip**: 건너뛸 항목 수 (기본값: 0)
    - **limit**: 가져올 항목 수 (기본값: 100)
    """
    players = mock_data_service.get_players(skip=skip, limit=limit)
    total = len(mock_data_service.players)

    return PlayerList(total=total, items=players)


@router.get("/{player_id}", response_model=PlayerResponse)
async def get_player(player_id: str):
    """
    특정 플레이어 조회

    - **player_id**: 플레이어 ID
    """
    player = mock_data_service.get_player(player_id)
    if not player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player with id {player_id} not found"
        )
    return player


@router.post("", response_model=PlayerResponse, status_code=status.HTTP_201_CREATED)
async def create_player(player: PlayerCreate):
    """
    새 플레이어 생성

    - **name**: 플레이어 이름 (필수)
    - **email**: 이메일 주소 (필수)
    - **phone**: 전화번호 (선택)
    - **handicap**: 핸디캡 (기본값: 0)
    - **avatar_url**: 프로필 이미지 URL (선택)
    - **password**: 비밀번호 (필수)
    """
    player_data = player.model_dump(exclude={'password'})
    new_player = mock_data_service.create_player(player_data)
    return new_player


@router.put("/{player_id}", response_model=PlayerResponse)
async def update_player(player_id: str, player: PlayerUpdate):
    """
    플레이어 정보 수정

    - **player_id**: 플레이어 ID
    - 수정할 필드만 포함하여 요청 (부분 업데이트 가능)
    """
    # 플레이어 존재 확인
    existing_player = mock_data_service.get_player(player_id)
    if not existing_player:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player with id {player_id} not found"
        )

    # 업데이트
    player_data = player.model_dump(exclude_unset=True)
    updated_player = mock_data_service.update_player(player_id, player_data)

    return updated_player


@router.delete("/{player_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_player(player_id: str):
    """
    플레이어 삭제

    - **player_id**: 플레이어 ID
    """
    deleted = mock_data_service.delete_player(player_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Player with id {player_id} not found"
        )
    return None
