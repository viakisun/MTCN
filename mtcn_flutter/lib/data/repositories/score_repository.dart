import '../../models/score_record.dart';
import '../mock/mock_scores.dart';

/// Repository for score data access
abstract class ScoreRepository {
  Future<List<ScoreRecord>> getAllScores();
  Future<ScoreRecord> getScoreById(String id);
  Future<List<ScoreRecord>> getExcellentScores();
  Future<List<ScoreRecord>> getGoodScores();
  Future<List<ScoreRecord>> getRecentScores({int days = 30});
  Future<ScoreRecord> createScore(ScoreRecord score);
  Future<ScoreRecord> updateScore(ScoreRecord score);
  Future<void> deleteScore(String id);
}

/// Mock implementation of ScoreRepository
class MockScoreRepository implements ScoreRepository {
  @override
  Future<List<ScoreRecord>> getAllScores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockScores.all;
  }

  @override
  Future<ScoreRecord> getScoreById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockScores.findById(id);
  }

  @override
  Future<List<ScoreRecord>> getExcellentScores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockScores.excellentScores();
  }

  @override
  Future<List<ScoreRecord>> getGoodScores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockScores.goodScores();
  }

  @override
  Future<List<ScoreRecord>> getRecentScores({int days = 30}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockScores.recentScores(days: days);
  }

  @override
  Future<ScoreRecord> createScore(ScoreRecord score) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return score;
  }

  @override
  Future<ScoreRecord> updateScore(ScoreRecord score) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return score;
  }

  @override
  Future<void> deleteScore(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
