from faker import Faker
from typing import Dict, List
from datetime import datetime, timedelta
import random
from app.schemas.player import PlayerResponse
from app.schemas.group import GroupResponse
from app.schemas.rounding import RoundingResponse, RoundingStatus
from app.schemas.score import ScoreResponse

# Faker 인스턴스 생성 (한국어 지원)
fake = Faker('ko_KR')


class MockDataService:
    """Mock 데이터를 제공하는 서비스"""

    def __init__(self):
        self.players: Dict[str, PlayerResponse] = {}
        self.groups: Dict[str, GroupResponse] = {}
        self.roundings: Dict[str, RoundingResponse] = {}
        self.scores: Dict[str, ScoreResponse] = {}
        self._initialize_mock_data()

    def _initialize_mock_data(self):
        """초기 Mock 데이터 생성"""
        # 1. Players 생성 (20명)
        self._create_mock_players(20)

        # 2. Groups 생성 (10개)
        self._create_mock_groups(10)

        # 3. Roundings 생성 (15개)
        self._create_mock_roundings(15)

        # 4. Scores 생성 (50개)
        self._create_mock_scores(50)

    def _create_mock_players(self, count: int):
        """Mock 플레이어 데이터 생성"""
        for i in range(count):
            player_id = f"player_{i+1:03d}"
            self.players[player_id] = PlayerResponse(
                id=player_id,
                name=fake.name(),
                email=fake.email(),
                phone=fake.phone_number(),
                handicap=random.randint(0, 36),
                avatar_url=f"https://i.pravatar.cc/150?img={random.randint(1, 70)}",
                created_at=datetime.now() - timedelta(days=random.randint(30, 365)),
                updated_at=datetime.now() - timedelta(days=random.randint(0, 30))
            )

    def _create_mock_groups(self, count: int):
        """Mock 그룹 데이터 생성"""
        group_names = [
            "서울 골프회", "주말 골퍼", "아침 골프 클럽", "프로 골퍼 모임",
            "친목 골프회", "비즈니스 골프", "동문 골프회", "가족 골프",
            "시니어 골프회", "주니어 골프 클럽"
        ]

        player_ids = list(self.players.keys())

        for i in range(count):
            group_id = f"group_{i+1:03d}"
            self.groups[group_id] = GroupResponse(
                id=group_id,
                name=group_names[i % len(group_names)] if i < len(group_names) else f"골프회 {i+1}",
                description=f"{fake.sentence()} 함께 즐기는 골프 모임입니다.",
                avatar_url=f"https://picsum.photos/seed/{group_id}/200/200",
                is_public=random.choice([True, False]),
                member_count=random.randint(5, 20),
                round_count=random.randint(1, 50),
                created_at=datetime.now() - timedelta(days=random.randint(60, 730)),
                created_by=random.choice(player_ids)
            )

    def _create_mock_roundings(self, count: int):
        """Mock 라운딩 데이터 생성"""
        courses = [
            "레이크사이드 CC", "스카이72 GC", "남서울 CC", "베어즈베스트 GC",
            "안양 CC", "블랙스톤 CC", "아시아나 CC", "화산 CC",
            "제주 CC", "골든비치 GC", "레이크우드 CC", "파인크릭 GC"
        ]

        event_names = [
            "월례 라운딩", "친선 라운딩", "챔피언십", "신년 라운딩",
            "봄맞이 라운딩", "여름 라운딩", "가을 라운딩", "송년 라운딩",
            "주말 라운딩", "비즈니스 라운딩", "친목 라운딩", "토너먼트"
        ]

        group_ids = list(self.groups.keys())

        for i in range(count):
            rounding_id = f"rounding_{i+1:03d}"
            date_offset = random.randint(-30, 30)  # -30일 ~ +30일
            rounding_date = datetime.now() + timedelta(days=date_offset)

            # 날짜에 따라 상태 결정
            if date_offset < -7:
                status = RoundingStatus.COMPLETED
            elif date_offset < 0:
                status = random.choice([RoundingStatus.COMPLETED, RoundingStatus.IN_PROGRESS])
            elif date_offset == 0:
                status = RoundingStatus.IN_PROGRESS
            else:
                status = RoundingStatus.SCHEDULED

            group_id = random.choice(group_ids)

            self.roundings[rounding_id] = RoundingResponse(
                id=rounding_id,
                event_name=random.choice(event_names),
                course_name=random.choice(courses),
                date=rounding_date.strftime("%Y-%m-%d"),
                tee_time=f"{random.randint(6, 14):02d}:{random.choice(['00', '30'])}",
                status=status,
                group_id=group_id,
                group_name=self.groups[group_id].name,
                player_count=random.randint(4, 8),
                created_at=rounding_date - timedelta(days=random.randint(7, 30))
            )

    def _create_mock_scores(self, count: int):
        """Mock 스코어 데이터 생성"""
        player_ids = list(self.players.keys())
        rounding_ids = list(self.roundings.keys())

        for i in range(count):
            score_id = f"score_{i+1:03d}"
            player_id = random.choice(player_ids)
            rounding_id = random.choice(rounding_ids)
            rounding = self.roundings[rounding_id]

            # 18홀 스코어 생성 (파72 기준)
            hole_scores = []
            birdies = 0
            pars = 0
            bogeys = 0

            for hole in range(18):
                par = 4 if hole % 3 != 0 else (3 if hole % 2 == 0 else 5)
                score = random.choices(
                    [par - 1, par, par + 1, par + 2],
                    weights=[10, 40, 35, 15]
                )[0]
                hole_scores.append(score)

                if score == par - 1:
                    birdies += 1
                elif score == par:
                    pars += 1
                elif score == par + 1:
                    bogeys += 1

            total_score = sum(hole_scores)

            self.scores[score_id] = ScoreResponse(
                id=score_id,
                player_id=player_id,
                player_name=self.players[player_id].name,
                rounding_id=rounding_id,
                course_name=rounding.course_name,
                total_score=total_score,
                par=72,
                birdies=birdies,
                pars=pars,
                bogeys=bogeys,
                hole_scores=hole_scores,
                date=datetime.fromisoformat(rounding.date),
                created_at=datetime.fromisoformat(rounding.date) + timedelta(hours=5)
            )

    # Player 관련 메서드
    def get_players(self, skip: int = 0, limit: int = 100) -> List[PlayerResponse]:
        """플레이어 목록 조회"""
        players = list(self.players.values())
        return players[skip:skip + limit]

    def get_player(self, player_id: str) -> PlayerResponse | None:
        """특정 플레이어 조회"""
        return self.players.get(player_id)

    def create_player(self, player_data: dict) -> PlayerResponse:
        """플레이어 생성"""
        player_id = f"player_{len(self.players) + 1:03d}"
        player = PlayerResponse(
            id=player_id,
            name=player_data['name'],
            email=player_data['email'],
            phone=player_data.get('phone'),
            handicap=player_data.get('handicap', 0),
            avatar_url=player_data.get('avatar_url'),
            created_at=datetime.now(),
            updated_at=None
        )
        self.players[player_id] = player
        return player

    def update_player(self, player_id: str, player_data: dict) -> PlayerResponse | None:
        """플레이어 수정"""
        player = self.players.get(player_id)
        if not player:
            return None

        update_data = {k: v for k, v in player_data.items() if v is not None}
        updated_player = player.model_copy(update=update_data)
        updated_player.updated_at = datetime.now()
        self.players[player_id] = updated_player
        return updated_player

    def delete_player(self, player_id: str) -> bool:
        """플레이어 삭제"""
        if player_id in self.players:
            del self.players[player_id]
            return True
        return False

    # Group 관련 메서드
    def get_groups(self, skip: int = 0, limit: int = 100) -> List[GroupResponse]:
        """그룹 목록 조회"""
        groups = list(self.groups.values())
        return groups[skip:skip + limit]

    def get_group(self, group_id: str) -> GroupResponse | None:
        """특정 그룹 조회"""
        return self.groups.get(group_id)

    def create_group(self, group_data: dict, created_by: str) -> GroupResponse:
        """그룹 생성"""
        group_id = f"group_{len(self.groups) + 1:03d}"
        group = GroupResponse(
            id=group_id,
            name=group_data['name'],
            description=group_data.get('description'),
            avatar_url=group_data.get('avatar_url'),
            is_public=group_data.get('is_public', True),
            member_count=1,
            round_count=0,
            created_at=datetime.now(),
            created_by=created_by
        )
        self.groups[group_id] = group
        return group

    def update_group(self, group_id: str, group_data: dict) -> GroupResponse | None:
        """그룹 수정"""
        group = self.groups.get(group_id)
        if not group:
            return None

        update_data = {k: v for k, v in group_data.items() if v is not None}
        updated_group = group.model_copy(update=update_data)
        self.groups[group_id] = updated_group
        return updated_group

    def delete_group(self, group_id: str) -> bool:
        """그룹 삭제"""
        if group_id in self.groups:
            del self.groups[group_id]
            return True
        return False

    # Rounding 관련 메서드
    def get_roundings(self, skip: int = 0, limit: int = 100) -> List[RoundingResponse]:
        """라운딩 목록 조회"""
        roundings = list(self.roundings.values())
        # 날짜 순으로 정렬 (최신순)
        roundings.sort(key=lambda x: x.date, reverse=True)
        return roundings[skip:skip + limit]

    def get_rounding(self, rounding_id: str) -> RoundingResponse | None:
        """특정 라운딩 조회"""
        return self.roundings.get(rounding_id)

    def create_rounding(self, rounding_data: dict) -> RoundingResponse:
        """라운딩 생성"""
        rounding_id = f"rounding_{len(self.roundings) + 1:03d}"
        group = self.groups.get(rounding_data['group_id'])

        rounding = RoundingResponse(
            id=rounding_id,
            event_name=rounding_data['event_name'],
            course_name=rounding_data['course_name'],
            date=rounding_data['date'],
            tee_time=rounding_data['tee_time'],
            status=rounding_data.get('status', RoundingStatus.SCHEDULED),
            group_id=rounding_data['group_id'],
            group_name=group.name if group else "Unknown Group",
            player_count=len(rounding_data.get('player_ids', [])),
            created_at=datetime.now()
        )
        self.roundings[rounding_id] = rounding
        return rounding

    def update_rounding(self, rounding_id: str, rounding_data: dict) -> RoundingResponse | None:
        """라운딩 수정"""
        rounding = self.roundings.get(rounding_id)
        if not rounding:
            return None

        update_data = {k: v for k, v in rounding_data.items() if v is not None}
        updated_rounding = rounding.model_copy(update=update_data)
        self.roundings[rounding_id] = updated_rounding
        return updated_rounding

    def delete_rounding(self, rounding_id: str) -> bool:
        """라운딩 삭제"""
        if rounding_id in self.roundings:
            del self.roundings[rounding_id]
            return True
        return False

    # Score 관련 메서드
    def get_scores(self, skip: int = 0, limit: int = 100) -> List[ScoreResponse]:
        """스코어 목록 조회"""
        scores = list(self.scores.values())
        # 날짜 순으로 정렬 (최신순)
        scores.sort(key=lambda x: x.date, reverse=True)
        return scores[skip:skip + limit]

    def get_score(self, score_id: str) -> ScoreResponse | None:
        """특정 스코어 조회"""
        return self.scores.get(score_id)

    def get_recent_scores(self, player_id: str, limit: int = 10) -> List[ScoreResponse]:
        """플레이어의 최근 스코어 조회"""
        player_scores = [s for s in self.scores.values() if s.player_id == player_id]
        player_scores.sort(key=lambda x: x.date, reverse=True)
        return player_scores[:limit]

    def create_score(self, score_data: dict) -> ScoreResponse:
        """스코어 생성"""
        score_id = f"score_{len(self.scores) + 1:03d}"
        player = self.players.get(score_data['player_id'])
        rounding = self.roundings.get(score_data['rounding_id'])

        score = ScoreResponse(
            id=score_id,
            player_id=score_data['player_id'],
            player_name=player.name if player else "Unknown Player",
            rounding_id=score_data['rounding_id'],
            course_name=rounding.course_name if rounding else "Unknown Course",
            total_score=score_data['total_score'],
            par=score_data.get('par', 72),
            birdies=score_data.get('birdies', 0),
            pars=score_data.get('pars', 0),
            bogeys=score_data.get('bogeys', 0),
            hole_scores=score_data['hole_scores'],
            date=datetime.fromisoformat(rounding.date) if rounding else datetime.now(),
            created_at=datetime.now()
        )
        self.scores[score_id] = score
        return score

    def update_score(self, score_id: str, score_data: dict) -> ScoreResponse | None:
        """스코어 수정"""
        score = self.scores.get(score_id)
        if not score:
            return None

        update_data = {k: v for k, v in score_data.items() if v is not None}
        updated_score = score.model_copy(update=update_data)
        self.scores[score_id] = updated_score
        return updated_score

    def delete_score(self, score_id: str) -> bool:
        """스코어 삭제"""
        if score_id in self.scores:
            del self.scores[score_id]
            return True
        return False


# 싱글톤 인스턴스
mock_data_service = MockDataService()
