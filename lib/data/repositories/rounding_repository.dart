import '../../domain/repositories/rounding_repository.dart';
import '../../data/models/rounding.dart';
import '../../data/services/mock_database_service.dart';
import '../../core/enums/rounding_enums.dart';

/// Mock implementation of IRoundingRepository
class MockRoundingRepository implements IRoundingRepository {
  final IDatabaseService _databaseService;

  MockRoundingRepository(this._databaseService);

  @override
  Future<List<Rounding>> getRoundings({
    String? statusFilter,
    String? searchKeyword,
    int? limit,
    int? offset,
  }) async {
    return _databaseService.getRoundings(
      statusFilter: statusFilter,
      searchKeyword: searchKeyword,
    );
  }

  @override
  Future<Rounding?> getRoundingById(String id) async {
    return _databaseService.getRoundingById(id);
  }

  @override
  Future<Rounding> createRounding(Rounding rounding) async {
    return _databaseService.createRounding(rounding);
  }

  @override
  Future<Rounding> updateRounding(Rounding rounding) async {
    return _databaseService.updateRounding(rounding);
  }

  @override
  Future<void> deleteRounding(String id) async {
    return _databaseService.deleteRounding(id);
  }

  @override
  Future<Rounding> updateRoundingStatus(
    String id,
    RoundingStatus status,
  ) async {
    final rounding = await _databaseService.getRoundingById(id);
    if (rounding == null) {
      throw Exception('Rounding not found');
    }
    final updatedRounding = rounding.copyWith(status: status);
    return _databaseService.updateRounding(updatedRounding);
  }
}
