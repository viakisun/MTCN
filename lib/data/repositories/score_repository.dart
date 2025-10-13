import '../../domain/repositories/score_repository.dart';
import '../../data/models/score_record.dart';
import '../../data/services/mock_database_service.dart';

/// Mock implementation of IScoreRepository
class MockScoreRepository implements IScoreRepository {
  final IDatabaseService _databaseService;

  MockScoreRepository(this._databaseService);

  @override
  Future<List<ScoreRecord>> getScoreRecords({
    String? playerId,
    String? roundingId,
    String? qualityFilter,
    int? limit,
    int? offset,
  }) async {
    return _databaseService.getScoreRecords(
      playerId: playerId,
      roundingId: roundingId,
      qualityFilter: qualityFilter,
    );
  }

  @override
  Future<ScoreRecord?> getScoreRecordById(String id) async {
    return _databaseService.getScoreRecordById(id);
  }

  @override
  Future<ScoreRecord> createScoreRecord(ScoreRecord scoreRecord) async {
    return _databaseService.createScoreRecord(scoreRecord);
  }

  @override
  Future<ScoreRecord> updateScoreRecord(ScoreRecord scoreRecord) async {
    return _databaseService.updateScoreRecord(scoreRecord);
  }
}
