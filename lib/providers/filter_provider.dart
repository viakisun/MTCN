import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rounding.dart';
import '../data/models/group.dart';
import '../core/enums/group_enums.dart';
import '../models/score_record.dart';
import 'mock_data_provider.dart';

// Rounding filter state
final roundingFilterProvider = StateProvider<String>((ref) => 'all');
final roundingSearchProvider = StateProvider<String>((ref) => '');

// Filtered roundings provider
final filteredRoundingsProvider = Provider<List<Rounding>>((ref) {
  final roundings = ref.watch(roundingsProvider);
  final filter = ref.watch(roundingFilterProvider);
  final search = ref.watch(roundingSearchProvider);

  var filtered = roundings;

  // Apply status filter
  if (filter != 'all') {
    filtered = filtered.where((r) {
      switch (filter) {
        case 'upcoming':
          return r.status == RoundingStatus.upcoming;
        case 'in-progress':
          return r.status == RoundingStatus.inProgress;
        case 'completed':
          return r.status == RoundingStatus.completed;
        default:
          return true;
      }
    }).toList();
  }

  // Apply search
  if (search.isNotEmpty) {
    final query = search.toLowerCase();
    filtered = filtered.where((r) {
      return r.courseName.toLowerCase().contains(query) ||
          r.eventName.toLowerCase().contains(query) ||
          r.players.any((p) => p.name.toLowerCase().contains(query));
    }).toList();
  }

  // Sort by date
  filtered.sort((a, b) {
    final dateA = DateTime.parse(a.date);
    final dateB = DateTime.parse(b.date);
    return dateB.compareTo(dateA);
  });

  return filtered;
});

// Group filter state
final groupFilterProvider = StateProvider<String>((ref) => 'all');
final groupSearchProvider = StateProvider<String>((ref) => '');

// Filtered groups provider
final filteredGroupsProvider = Provider<List<Group>>((ref) {
  final groups = ref.watch(groupsProvider);
  final filter = ref.watch(groupFilterProvider);
  final search = ref.watch(groupSearchProvider);

  var filtered = groups;

  // Apply status filter
  if (filter != 'all') {
    filtered = filtered.where((g) {
      switch (filter) {
        case 'active':
          return g.status == GroupStatus.active;
        case 'inactive':
          return g.status == GroupStatus.inactive;
        case 'new':
          return g.isNew;
        default:
          return true;
      }
    }).toList();
  }

  // Apply search
  if (search.isNotEmpty) {
    final query = search.toLowerCase();
    filtered = filtered.where((g) {
      return g.name.toLowerCase().contains(query) ||
          g.description.toLowerCase().contains(query) ||
          g.members.any((m) => m.name.toLowerCase().contains(query));
    }).toList();
  }

  // Sort by creation date
  filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return filtered;
});

// Score filter state
final scoreFilterProvider = StateProvider<String>((ref) => 'all');
final scoreSearchProvider = StateProvider<String>((ref) => '');

// Filtered scores provider
final filteredScoresProvider = Provider<List<ScoreRecord>>((ref) {
  final scores = ref.watch(scoreRecordsProvider);
  final filter = ref.watch(scoreFilterProvider);
  final search = ref.watch(scoreSearchProvider);

  var filtered = scores;

  // Apply quality filter
  if (filter != 'all') {
    filtered = filtered.where((s) {
      switch (filter) {
        case 'excellent':
          return s.quality == ScoreQuality.excellent;
        case 'good':
          return s.quality == ScoreQuality.good;
        case 'average':
          return s.quality == ScoreQuality.average;
        case 'poor':
          return s.quality == ScoreQuality.poor;
        default:
          return true;
      }
    }).toList();
  }

  // Apply search
  if (search.isNotEmpty) {
    final query = search.toLowerCase();
    filtered = filtered.where((s) {
      return s.player.name.toLowerCase().contains(query) ||
          s.courseName.toLowerCase().contains(query);
    }).toList();
  }

  // Sort by date
  filtered.sort((a, b) => b.date.compareTo(a.date));

  return filtered;
});
