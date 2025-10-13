import '../../data/models/player.dart';

/// 플레이어 데이터 접근 인터페이스
abstract class IPlayerRepository {
  /// 플레이어 목록 조회 (MockDatabaseService 호환)
  Future<List<Player>> getPlayers({
    String? searchKeyword,
    int? limit,
    int? offset,
  });

  /// 플레이어 상세 정보 조회
  Future<Player?> getPlayerById(String id);

  /// 플레이어 생성
  Future<Player> createPlayer(Player player);

  /// 플레이어 수정
  Future<Player> updatePlayer(Player player);
}
