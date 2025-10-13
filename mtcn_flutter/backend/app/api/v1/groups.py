from fastapi import APIRouter, HTTPException, status
from typing import Optional
from app.schemas.group import (
    GroupCreate,
    GroupUpdate,
    GroupResponse,
    GroupList
)
from app.schemas.player import PlayerList
from app.services.mock_data import mock_data_service

router = APIRouter(prefix="/groups", tags=["groups"])


@router.get("", response_model=GroupList)
async def get_groups(
    skip: int = 0,
    limit: int = 100
):
    """
    그룹 목록 조회

    - **skip**: 건너뛸 항목 수 (기본값: 0)
    - **limit**: 가져올 항목 수 (기본값: 100)
    """
    groups = mock_data_service.get_groups(skip=skip, limit=limit)
    total = len(mock_data_service.groups)

    return GroupList(total=total, items=groups)


@router.get("/{group_id}", response_model=GroupResponse)
async def get_group(group_id: str):
    """
    특정 그룹 조회

    - **group_id**: 그룹 ID
    """
    group = mock_data_service.get_group(group_id)
    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Group with id {group_id} not found"
        )
    return group


@router.post("", response_model=GroupResponse, status_code=status.HTTP_201_CREATED)
async def create_group(
    group: GroupCreate,
    created_by: str = "player_001"  # 실제로는 인증된 사용자 ID를 사용해야 함
):
    """
    새 그룹 생성

    - **name**: 그룹 이름 (필수)
    - **description**: 그룹 설명 (선택)
    - **avatar_url**: 그룹 이미지 URL (선택)
    - **is_public**: 공개 여부 (기본값: True)
    """
    group_data = group.model_dump()
    new_group = mock_data_service.create_group(group_data, created_by)
    return new_group


@router.put("/{group_id}", response_model=GroupResponse)
async def update_group(group_id: str, group: GroupUpdate):
    """
    그룹 정보 수정

    - **group_id**: 그룹 ID
    - 수정할 필드만 포함하여 요청 (부분 업데이트 가능)
    """
    # 그룹 존재 확인
    existing_group = mock_data_service.get_group(group_id)
    if not existing_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Group with id {group_id} not found"
        )

    # 업데이트
    group_data = group.model_dump(exclude_unset=True)
    updated_group = mock_data_service.update_group(group_id, group_data)

    return updated_group


@router.delete("/{group_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_group(group_id: str):
    """
    그룹 삭제

    - **group_id**: 그룹 ID
    """
    deleted = mock_data_service.delete_group(group_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Group with id {group_id} not found"
        )
    return None


@router.get("/{group_id}/members", response_model=PlayerList)
async def get_group_members(
    group_id: str,
    skip: int = 0,
    limit: int = 100
):
    """
    그룹 멤버 목록 조회

    - **group_id**: 그룹 ID
    - **skip**: 건너뛸 항목 수 (기본값: 0)
    - **limit**: 가져올 항목 수 (기본값: 100)

    참고: 현재 Mock 데이터에서는 임의의 플레이어를 반환합니다.
    실제 구현에서는 그룹-멤버 관계를 관리해야 합니다.
    """
    # 그룹 존재 확인
    group = mock_data_service.get_group(group_id)
    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Group with id {group_id} not found"
        )

    # Mock: 일부 플레이어를 그룹 멤버로 반환
    # 실제로는 group-member 관계 테이블에서 조회해야 함
    all_players = mock_data_service.get_players(skip=0, limit=group.member_count)
    players = all_players[skip:skip + limit]

    return PlayerList(total=group.member_count, items=players)
