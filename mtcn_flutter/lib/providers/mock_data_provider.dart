import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/rounding.dart';
import '../models/group.dart';
import '../models/score_record.dart';
import '../services/mock_data_service.dart';
import '../data/mock/mock_roundings.dart';
import '../data/mock/mock_players.dart';

// Players provider
final playersProvider = Provider<List<Player>>((ref) {
  return MockPlayers.all;
});

// Roundings provider - MockRoundings 직접 사용
final roundingsProvider = Provider<List<Rounding>>((ref) {
  return MockRoundings.all;
});

// Groups provider
final groupsProvider = Provider<List<Group>>((ref) {
  final players = ref.watch(playersProvider);
  return MockDataService.generateGroups(8, players);
});

// Score records provider
final scoreRecordsProvider = Provider<List<ScoreRecord>>((ref) {
  final players = ref.watch(playersProvider);
  return MockDataService.generateScoreRecords(20, players);
});

// My in-progress rounding (내가 참여 중인 진행 중 라운딩)
final myInProgressRoundingProvider = Provider<Rounding?>((ref) {
  final roundings = ref.watch(roundingsProvider);
  final currentUserId = MockPlayers.currentUser.id;

  final myInProgress = roundings.where((r) {
    return r.status == RoundingStatus.inProgress &&
        r.players.any((p) => p.id == currentUserId);
  }).toList();

  return myInProgress.isNotEmpty ? myInProgress.first : null;
});

// Others' in-progress roundings (동문들이 참여 중인 진행 중 라운딩 - 내가 참여하지 않는)
final othersInProgressRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingsProvider);
  final currentUserId = MockPlayers.currentUser.id;

  return roundings.where((r) {
    return r.status == RoundingStatus.inProgress &&
        !r.players.any((p) => p.id == currentUserId);
  }).toList();
});

// My upcoming roundings (내가 참가 예정인 라운딩)
final myUpcomingRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingsProvider);
  final currentUserId = MockPlayers.currentUser.id;
  final now = DateTime.now();

  final myUpcoming = roundings.where((r) {
    final roundingDate = DateTime.parse(r.date);
    return roundingDate.isAfter(now) &&
        r.status == RoundingStatus.upcoming &&
        r.players.any((p) => p.id == currentUserId);
  }).toList();

  myUpcoming.sort((a, b) {
    final dateA = DateTime.parse(a.date);
    final dateB = DateTime.parse(b.date);
    return dateA.compareTo(dateB);
  });

  return myUpcoming;
});

// Available roundings (참가 가능한 라운딩)
final availableRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingsProvider);
  final currentUserId = MockPlayers.currentUser.id;
  final now = DateTime.now();

  final available = roundings.where((r) {
    final roundingDate = DateTime.parse(r.date);
    final hasSpace = r.maxPlayers == null || r.players.length < r.maxPlayers!;
    final notJoined = !r.players.any((p) => p.id == currentUserId);

    return roundingDate.isAfter(now) &&
        r.status == RoundingStatus.upcoming &&
        hasSpace &&
        notJoined;
  }).toList();

  available.sort((a, b) {
    final dateA = DateTime.parse(a.date);
    final dateB = DateTime.parse(b.date);
    return dateA.compareTo(dateB);
  });

  return available;
});

// Recent scores provider (last 1 score for home)
final recentScoresProvider = Provider<List<ScoreRecord>>((ref) {
  final scores = ref.watch(scoreRecordsProvider);
  final sortedScores = [...scores];
  sortedScores.sort((a, b) => b.date.compareTo(a.date));
  return sortedScores.take(1).toList();
});

// Active groups provider (2-3 active groups for home)
final activeGroupsProvider = Provider<List<Group>>((ref) {
  final groups = ref.watch(groupsProvider);
  final activeGroups = groups
      .where((g) => g.status == GroupStatus.active)
      .toList();
  return activeGroups.take(3).toList();
});
