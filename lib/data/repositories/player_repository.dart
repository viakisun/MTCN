import '../../domain/repositories/player_repository.dart';
import '../../data/models/player.dart';
import '../../data/services/mock_database_service.dart';

/// Mock implementation of IPlayerRepository
class MockPlayerRepository implements IPlayerRepository {
  final IDatabaseService _databaseService;

  MockPlayerRepository(this._databaseService);

  @override
  Future<List<Player>> getPlayers({
    String? searchKeyword,
    int? limit,
    int? offset,
  }) async {
    return _databaseService.getPlayers(searchKeyword: searchKeyword);
  }

  @override
  Future<Player?> getPlayerById(String id) async {
    return _databaseService.getPlayerById(id);
  }

  @override
  Future<Player> createPlayer(Player player) async {
    return _databaseService.createPlayer(player);
  }

  @override
  Future<Player> updatePlayer(Player player) async {
    return _databaseService.updatePlayer(player);
  }
}
