import '../../models/rounding.dart';
import '../mock/mock_roundings.dart';

/// Repository for rounding data access
abstract class RoundingRepository {
  Future<List<Rounding>> getAllRoundings();
  Future<Rounding> getRoundingById(String id);
  Future<List<Rounding>> getUpcomingRoundings();
  Future<List<Rounding>> getInProgressRoundings();
  Future<List<Rounding>> getCompletedRoundings();
  Future<Rounding> createRounding(Rounding rounding);
  Future<Rounding> updateRounding(Rounding rounding);
  Future<void> deleteRounding(String id);
}

/// Mock implementation of RoundingRepository
class MockRoundingRepository implements RoundingRepository {
  @override
  Future<List<Rounding>> getAllRoundings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockRoundings.all;
  }

  @override
  Future<Rounding> getRoundingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockRoundings.findById(id);
  }

  @override
  Future<List<Rounding>> getUpcomingRoundings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockRoundings.upcomingRoundings();
  }

  @override
  Future<List<Rounding>> getInProgressRoundings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockRoundings.inProgressRoundings();
  }

  @override
  Future<List<Rounding>> getCompletedRoundings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockRoundings.completedRoundings();
  }

  @override
  Future<Rounding> createRounding(Rounding rounding) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return rounding;
  }

  @override
  Future<Rounding> updateRounding(Rounding rounding) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return rounding;
  }

  @override
  Future<void> deleteRounding(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
