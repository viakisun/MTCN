import '../../models/player.dart';
import '../mock/mock_players.dart';

/// Repository for player data access
/// This abstraction layer allows easy swapping between mock and real API
abstract class PlayerRepository {
  Future<Player> getCurrentUser();
  Future<List<Player>> getAllPlayers();
  Future<Player> getPlayerById(String id);
  Future<List<Player>> getPlayersByIds(List<String> ids);
  Future<Player> updatePlayer(Player player);
  Future<void> deletePlayer(String id);
}

/// Mock implementation of PlayerRepository
class MockPlayerRepository implements PlayerRepository {
  @override
  Future<Player> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return MockPlayers.currentUser;
  }

  @override
  Future<List<Player>> getAllPlayers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockPlayers.all;
  }

  @override
  Future<Player> getPlayerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockPlayers.findById(id);
  }

  @override
  Future<List<Player>> getPlayersByIds(List<String> ids) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockPlayers.findByIds(ids);
  }

  @override
  Future<Player> updatePlayer(Player player) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, this would call API
    return player;
  }

  @override
  Future<void> deletePlayer(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, this would call API
  }
}
