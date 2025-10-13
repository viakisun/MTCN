import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/service_locator.dart';
import '../domain/usecases/rounding/create_rounding_usecase.dart';
import '../domain/repositories/rounding_repository.dart';
import '../../data/models/rounding.dart';
import '../core/enums/rounding_enums.dart';
import '../domain/utils/result.dart';

/// 서비스 로케이터 Provider
final serviceLocatorProvider = Provider<ServiceLocator>((ref) {
  return ServiceLocator();
});

/// 라운딩 Repository Provider
final roundingRepositoryProvider = Provider<IRoundingRepository>((ref) {
  return ref.watch(serviceLocatorProvider).roundingRepository;
});

/// 라운딩 생성 Use Case Provider
final createRoundingUseCaseProvider = Provider<CreateRoundingUseCase>((ref) {
  return ref.watch(serviceLocatorProvider).createRoundingUseCase;
});

/// 라운딩 목록 상태
class RoundingListState {
  final List<Rounding> roundings;
  final bool isLoading;
  final String? error;
  final String? statusFilter;
  final String? searchKeyword;

  const RoundingListState({
    this.roundings = const [],
    this.isLoading = false,
    this.error,
    this.statusFilter,
    this.searchKeyword,
  });

  RoundingListState copyWith({
    List<Rounding>? roundings,
    bool? isLoading,
    String? error,
    String? statusFilter,
    String? searchKeyword,
    bool clearError = false,
  }) {
    return RoundingListState(
      roundings: roundings ?? this.roundings,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      statusFilter: statusFilter ?? this.statusFilter,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

/// 라운딩 목록 Notifier
class RoundingListNotifier extends StateNotifier<RoundingListState> {
  final IRoundingRepository _repository;

  RoundingListNotifier(this._repository) : super(const RoundingListState()) {
    loadRoundings();
  }

  /// 라운딩 목록 로드
  Future<void> loadRoundings({
    String? statusFilter,
    String? searchKeyword,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      statusFilter: statusFilter,
      searchKeyword: searchKeyword,
    );

    try {
      final roundings = await _repository.getRoundings(
        statusFilter: statusFilter,
        searchKeyword: searchKeyword,
      );

      state = state.copyWith(roundings: roundings, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 라운딩 생성
  Future<Result<Rounding>> createRounding({
    required String title,
    required String courseName,
    required String date,
    required String time,
    required int greenFee,
    required String weather,
    required int temperature,
    required List<String> playerIds,
    required int holes,
    String? description,
    String? groupName,
    int? fee,
    int? maxPlayers,
    RoundingOptions? options,
    String? courseAddress,
    double? courseLatitude,
    double? courseLongitude,
    RoundingType? roundingType,
    RoundingPrivacy? privacy,
    RoundingDifficulty? difficulty,
  }) async {
    // Use Case를 통한 라운딩 생성은 별도 Provider에서 처리
    // 여기서는 Repository를 통한 직접 생성만 처리
    try {
      final newRounding = Rounding(
        id: '',
        title: title,
        courseName: courseName,
        date: date,
        time: time,
        status: RoundingStatus.upcoming,
        greenFee: greenFee,
        weather: weather,
        temperature: temperature,
        players: [], // 플레이어는 별도로 추가해야 함
        holes: holes,
        description: description,
        groupName: groupName ?? '개인 라운딩',
        fee: fee,
        maxPlayers: maxPlayers,
        options: options,
        courseAddress: courseAddress ?? '',
        courseLatitude: courseLatitude,
        courseLongitude: courseLongitude,
        type: roundingType ?? RoundingType.full18,
        privacy: privacy ?? RoundingPrivacy.public,
        difficulty: difficulty ?? RoundingDifficulty.intermediate,
      );

      final createdRounding = await _repository.createRounding(newRounding);

      // 목록 새로고침
      await loadRoundings(
        statusFilter: state.statusFilter,
        searchKeyword: state.searchKeyword,
      );

      return Result.success(createdRounding);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// 라운딩 상태 업데이트
  Future<void> updateRoundingStatus(String id, RoundingStatus newStatus) async {
    try {
      await _repository.updateRoundingStatus(id, newStatus);

      // 목록 새로고침
      await loadRoundings(
        statusFilter: state.statusFilter,
        searchKeyword: state.searchKeyword,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 라운딩 삭제
  Future<void> deleteRounding(String id) async {
    try {
      await _repository.deleteRounding(id);

      // 목록에서 제거
      final updatedRoundings = state.roundings
          .where((r) => r.id != id)
          .toList();

      state = state.copyWith(roundings: updatedRoundings);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 필터 적용
  void applyFilter(String? statusFilter) {
    loadRoundings(
      statusFilter: statusFilter,
      searchKeyword: state.searchKeyword,
    );
  }

  /// 검색
  void search(String? keyword) {
    loadRoundings(statusFilter: state.statusFilter, searchKeyword: keyword);
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadRoundings(
      statusFilter: state.statusFilter,
      searchKeyword: state.searchKeyword,
    );
  }
}

/// 라운딩 목록 Provider
final roundingListProvider =
    StateNotifierProvider<RoundingListNotifier, RoundingListState>((ref) {
      final repository = ref.watch(roundingRepositoryProvider);
      return RoundingListNotifier(repository);
    });

/// 내가 참여 중인 라운딩 Provider
final myRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingListProvider).roundings;
  final currentUserId = 'current_user'; // TODO: 실제 사용자 ID로 교체

  return roundings.where((r) {
    return r.players.any((p) => p.id == currentUserId);
  }).toList();
});

/// 진행 중인 라운딩 Provider
final inProgressRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingListProvider).roundings;

  return roundings.where((r) {
    return r.status == RoundingStatus.inProgress;
  }).toList();
});

/// 예정된 라운딩 Provider
final upcomingRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingListProvider).roundings;

  return roundings.where((r) {
    return r.status == RoundingStatus.upcoming;
  }).toList();
});

/// 완료된 라운딩 Provider
final completedRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingListProvider).roundings;

  return roundings.where((r) {
    return r.status == RoundingStatus.completed;
  }).toList();
});

/// 특정 라운딩 Provider
final roundingProvider = FutureProvider.family<Rounding?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(roundingRepositoryProvider);
  return repository.getRoundingById(id);
});
