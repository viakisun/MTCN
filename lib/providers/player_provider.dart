import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/service_locator.dart';
import '../domain/repositories/player_repository.dart';
import '../../data/models/player.dart';
import '../domain/utils/result.dart';

/// 플레이어 Repository Provider
final playerRepositoryProvider = Provider<IPlayerRepository>((ref) {
  return ref.watch(serviceLocatorProvider).playerRepository;
});

/// 플레이어 목록 상태
class PlayerListState {
  final List<Player> players;
  final bool isLoading;
  final String? error;
  final String? searchKeyword;

  const PlayerListState({
    this.players = const [],
    this.isLoading = false,
    this.error,
    this.searchKeyword,
  });

  PlayerListState copyWith({
    List<Player>? players,
    bool? isLoading,
    String? error,
    String? searchKeyword,
    bool clearError = false,
  }) {
    return PlayerListState(
      players: players ?? this.players,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

/// 플레이어 목록 Notifier
class PlayerListNotifier extends StateNotifier<PlayerListState> {
  final IPlayerRepository _repository;

  PlayerListNotifier(this._repository) : super(const PlayerListState()) {
    loadPlayers();
  }

  /// 플레이어 목록 로드
  Future<void> loadPlayers({String? searchKeyword}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      searchKeyword: searchKeyword,
    );

    try {
      final players = await _repository.getPlayers(
        searchKeyword: searchKeyword,
      );

      state = state.copyWith(players: players, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 플레이어 생성
  Future<Result<Player>> createPlayer({
    required String name,
    required String firstName,
    required String lastName,
    required int averageScore,
    required int bestScore,
    required int handicap,
    String? avatar,
    bool isPlaying = false,
  }) async {
    try {
      final newPlayer = Player(
        id: '',
        name: name,
        firstName: firstName,
        lastName: lastName,
        averageScore: averageScore,
        bestScore: bestScore,
        handicap: handicap,
        avatar: avatar ?? '',
        isPlaying: isPlaying,
      );

      final createdPlayer = await _repository.createPlayer(newPlayer);

      // 목록 새로고침
      await loadPlayers(searchKeyword: state.searchKeyword);

      return Result.success(createdPlayer);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// 플레이어 업데이트
  Future<void> updatePlayer(Player player) async {
    try {
      await _repository.updatePlayer(player);

      // 목록에서 업데이트
      final updatedPlayers = state.players.map((p) {
        return p.id == player.id ? player : p;
      }).toList();

      state = state.copyWith(players: updatedPlayers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 검색
  void search(String? keyword) {
    loadPlayers(searchKeyword: keyword);
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadPlayers(searchKeyword: state.searchKeyword);
  }
}

/// 플레이어 목록 Provider
final playerListProvider =
    StateNotifierProvider<PlayerListNotifier, PlayerListState>((ref) {
      final repository = ref.watch(playerRepositoryProvider);
      return PlayerListNotifier(repository);
    });

/// 현재 플레이어 Provider
final currentPlayerProvider = Provider<Player>((ref) {
  // TODO: 실제 인증 시스템과 연동하여 현재 사용자 정보 가져오기
  return Player(
    id: 'current_user',
    name: '현재 사용자',
    firstName: '현재',
    lastName: '사용자',
    averageScore: 85,
    bestScore: 72,
    handicap: 12,
    avatar: '',
    isPlaying: false,
  );
});

/// 플레이어 검색 Provider
final playerSearchProvider = Provider<List<Player>>((ref) {
  final playerState = ref.watch(playerListProvider);
  final searchKeyword = playerState.searchKeyword;

  if (searchKeyword == null || searchKeyword.isEmpty) {
    return playerState.players;
  }

  final keyword = searchKeyword.toLowerCase();
  return playerState.players.where((player) {
    return player.name.toLowerCase().contains(keyword) ||
        player.firstName.toLowerCase().contains(keyword) ||
        player.lastName.toLowerCase().contains(keyword);
  }).toList();
});

/// 특정 플레이어 Provider
final playerProvider = FutureProvider.family<Player?, String>((ref, id) async {
  final repository = ref.watch(playerRepositoryProvider);
  return repository.getPlayerById(id);
});

/// 핸디캡별 플레이어 그룹 Provider
final playersByHandicapProvider = Provider<Map<String, List<Player>>>((ref) {
  final players = ref.watch(playerListProvider).players;

  final groupedPlayers = <String, List<Player>>{
    '초급 (0-9)': [],
    '중급 (10-19)': [],
    '고급 (20-29)': [],
    '프로급 (30+)': [],
  };

  for (final player in players) {
    if (player.handicap <= 9) {
      groupedPlayers['초급 (0-9)']!.add(player);
    } else if (player.handicap <= 19) {
      groupedPlayers['중급 (10-19)']!.add(player);
    } else if (player.handicap <= 29) {
      groupedPlayers['고급 (20-29)']!.add(player);
    } else {
      groupedPlayers['프로급 (30+)']!.add(player);
    }
  }

  return groupedPlayers;
});
