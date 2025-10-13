import '../../data/models/score_record.dart';

/// 스코어 데이터 접근 인터페이스
abstract class IScoreRepository {
  /// 스코어 목록 조회 (MockDatabaseService 호환)
  Future<List<ScoreRecord>> getScoreRecords({
    String? playerId,
    String? roundingId,
    String? qualityFilter,
    int? limit,
    int? offset,
  });

  /// 스코어 상세 정보 조회
  Future<ScoreRecord?> getScoreRecordById(String id);

  /// 스코어 생성
  Future<ScoreRecord> createScoreRecord(ScoreRecord scoreRecord);

  /// 스코어 수정
  Future<ScoreRecord> updateScoreRecord(ScoreRecord scoreRecord);
}
