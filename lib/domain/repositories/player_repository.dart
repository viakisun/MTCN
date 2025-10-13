import '../../data/models/player.dart';

/// 플레이어 데이터 접근 인터페이스
abstract class IPlayerRepository {
  /// 모든 플레이어 목록 조회
  Future<List<Player>> getAllPlayers();

  /// 플레이어 상세 정보 조회
  Future<Player?> getPlayer(String id);

  /// 플레이어 생성
  Future<Player> createPlayer(Player player);

  /// 플레이어 수정
  Future<Player> updatePlayer(Player player);

  /// 플레이어 삭제
  Future<void> deletePlayer(String id);

  /// 플레이어 검색
  Future<List<Player>> searchPlayers(String query);

  /// 핸디캡별 플레이어 조회
  Future<List<Player>> getPlayersByHandicap(int minHandicap, int maxHandicap);

  /// 플레이어 통계 업데이트
  Future<Player> updatePlayerStats(
    String playerId, {
    int? totalRounds,
    int? totalWins,
    double? winRate,
    int? averageScore,
    int? bestScore,
  });
}
