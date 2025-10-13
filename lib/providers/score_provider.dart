import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/service_locator.dart';
import '../domain/repositories/score_repository.dart';
import '../../data/models/score_record.dart';
import '../core/enums/score_enums.dart';
import '../domain/utils/result.dart';

/// 스코어 Repository Provider
final scoreRepositoryProvider = Provider<IScoreRepository>((ref) {
  return ref.watch(serviceLocatorProvider).scoreRepository;
});

/// 스코어 목록 상태
class ScoreListState {
  final List<ScoreRecord> scores;
  final bool isLoading;
  final String? error;
  final String? playerId;
  final String? roundingId;
  final String? qualityFilter;

  const ScoreListState({
    this.scores = const [],
    this.isLoading = false,
    this.error,
    this.playerId,
    this.roundingId,
    this.qualityFilter,
  });

  ScoreListState copyWith({
    List<ScoreRecord>? scores,
    bool? isLoading,
    String? error,
    String? playerId,
    String? roundingId,
    String? qualityFilter,
    bool clearError = false,
  }) {
    return ScoreListState(
      scores: scores ?? this.scores,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      playerId: playerId ?? this.playerId,
      roundingId: roundingId ?? this.roundingId,
      qualityFilter: qualityFilter ?? this.qualityFilter,
    );
  }
}

/// 스코어 목록 Notifier
class ScoreListNotifier extends StateNotifier<ScoreListState> {
  final IScoreRepository _repository;

  ScoreListNotifier(this._repository) : super(const ScoreListState()) {
    loadScores();
  }

  /// 스코어 목록 로드
  Future<void> loadScores({
    String? playerId,
    String? roundingId,
    String? qualityFilter,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      playerId: playerId,
      roundingId: roundingId,
      qualityFilter: qualityFilter,
    );

    try {
      final scores = await _repository.getScoreRecords(
        playerId: playerId,
        roundingId: roundingId,
        qualityFilter: qualityFilter,
      );

      state = state.copyWith(scores: scores, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 스코어 생성
  Future<Result<ScoreRecord>> createScore({
    required String playerId,
    required String roundingId,
    required int totalScore,
    required int par,
    required int birdies,
    required int pars,
    required int bogeys,
    required List<int> holeScores,
    required DateTime date,
    required ScoreQuality quality,
    String? notes,
  }) async {
    try {
      final newScore = ScoreRecord(
        id: '',
        playerId: playerId,
        roundingId: roundingId,
        scores: {
          for (int i = 0; i < holeScores.length; i++) i + 1: holeScores[i],
        },
        totalScore: totalScore,
        quality: quality,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: notes,
      );

      final createdScore = await _repository.createScoreRecord(newScore);

      // 목록 새로고침
      await loadScores(
        playerId: state.playerId,
        roundingId: state.roundingId,
        qualityFilter: state.qualityFilter,
      );

      return Result.success(createdScore);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// 스코어 업데이트
  Future<void> updateScore(ScoreRecord score) async {
    try {
      await _repository.updateScoreRecord(score);

      // 목록에서 업데이트
      final updatedScores = state.scores.map((s) {
        return s.id == score.id ? score : s;
      }).toList();

      state = state.copyWith(scores: updatedScores);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 필터 적용
  void applyFilters({
    String? playerId,
    String? roundingId,
    String? qualityFilter,
  }) {
    loadScores(
      playerId: playerId,
      roundingId: roundingId,
      qualityFilter: qualityFilter,
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadScores(
      playerId: state.playerId,
      roundingId: state.roundingId,
      qualityFilter: state.qualityFilter,
    );
  }
}

/// 스코어 목록 Provider
final scoreListProvider =
    StateNotifierProvider<ScoreListNotifier, ScoreListState>((ref) {
      final repository = ref.watch(scoreRepositoryProvider);
      return ScoreListNotifier(repository);
    });

/// 플레이어별 스코어 Provider
final playerScoresProvider = Provider.family<List<ScoreRecord>, String>((
  ref,
  playerId,
) {
  final scores = ref.watch(scoreListProvider).scores;

  return scores.where((s) => s.playerId == playerId).toList();
});

/// 라운딩별 스코어 Provider
final roundingScoresProvider = Provider.family<List<ScoreRecord>, String>((
  ref,
  roundingId,
) {
  final scores = ref.watch(scoreListProvider).scores;

  return scores.where((s) => s.roundingId == roundingId).toList();
});

/// 최근 스코어 Provider (홈 화면용)
final recentScoresProvider = Provider<List<ScoreRecord>>((ref) {
  final scores = ref.watch(scoreListProvider).scores;

  // 날짜순으로 정렬하고 최근 5개만 반환
  final sortedScores = [...scores];
  sortedScores.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return sortedScores.take(5).toList();
});

/// 품질별 스코어 통계 Provider
final scoreQualityStatsProvider = Provider<Map<ScoreQuality, int>>((ref) {
  final scores = ref.watch(scoreListProvider).scores;

  final stats = <ScoreQuality, int>{};
  for (final quality in ScoreQuality.values) {
    stats[quality] = 0;
  }

  for (final score in scores) {
    stats[score.quality] = (stats[score.quality] ?? 0) + 1;
  }

  return stats;
});

/// 플레이어 평균 스코어 Provider
final playerAverageScoreProvider = Provider.family<double, String>((
  ref,
  playerId,
) {
  final playerScores = ref.watch(playerScoresProvider(playerId));

  if (playerScores.isEmpty) return 0.0;

  final totalScore = playerScores.fold<int>(
    0,
    (sum, score) => sum + score.totalScore,
  );
  return totalScore / playerScores.length;
});

/// 특정 스코어 Provider
final scoreProvider = FutureProvider.family<ScoreRecord?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(scoreRepositoryProvider);
  return repository.getScoreRecordById(id);
});
