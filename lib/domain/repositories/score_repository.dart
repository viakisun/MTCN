import '../../data/models/score_record.dart';

/// 스코어 데이터 접근 인터페이스
abstract class IScoreRepository {
  /// 플레이어의 스코어 목록 조회
  Future<List<ScoreRecord>> getPlayerScores(String playerId);

  /// 라운딩의 스코어 목록 조회
  Future<List<ScoreRecord>> getRoundingScores(String roundingId);

  /// 스코어 상세 정보 조회
  Future<ScoreRecord?> getScore(String id);

  /// 스코어 생성
  Future<ScoreRecord> createScore(ScoreRecord score);

  /// 스코어 수정
  Future<ScoreRecord> updateScore(ScoreRecord score);

  /// 스코어 삭제
  Future<void> deleteScore(String id);

  /// 플레이어의 최근 스코어 조회
  Future<List<ScoreRecord>> getRecentScores(String playerId, int limit);

  /// 플레이어의 최고 스코어 조회
  Future<ScoreRecord?> getBestScore(String playerId);

  /// 플레이어의 평균 스코어 조회
  Future<double> getAverageScore(String playerId);

  /// 플레이어의 핸디캡 계산
  Future<int> calculateHandicap(String playerId);
}
