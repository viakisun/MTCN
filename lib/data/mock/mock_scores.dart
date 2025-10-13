import '../../models/score_record.dart';
import '../../models/score.dart';
import 'mock_players.dart';

/// Mock score data for development
class MockScores {
  /// 현재 진행 중인 라이브 스코어 (라운딩 ID: '2', 14홀 진행)
  static final List<Score> liveScores = [
    // 김민수 (나) - 14홀까지 +4 (58타)
    Score(
      id: 'live_score_1',
      player: MockPlayers.currentUser,
      courseName: '남서울 컨트리클럽',
      totalScore: 58, // 14홀까지
      par: 54, // 14홀 기준 par (4*10 + 3*2 + 5*2 = 54)
      date: '2025-10-08',
      holeScores: [4, 5, 3, 5, 4, 6, 3, 4, 5, 4, 5, 5, 3, 4], // 14홀
      birdies: 0,
      pars: 9,
      bogeys: 5,
      currentHole: 14,
      isLive: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 3)),
      roundingId: '2',
    ),
    // 이영희 - 14홀까지 +2 (56타) - 1등
    Score(
      id: 'live_score_2',
      player: MockPlayers.findById('2'),
      courseName: '남서울 컨트리클럽',
      totalScore: 56,
      par: 54,
      date: '2025-10-08',
      holeScores: [4, 4, 3, 4, 4, 5, 3, 4, 4, 4, 4, 5, 3, 5], // 14홀
      birdies: 0,
      pars: 11,
      bogeys: 3,
      currentHole: 14,
      isLive: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      roundingId: '2',
    ),
    // 박철수 - 14홀까지 +6 (60타)
    Score(
      id: 'live_score_3',
      player: MockPlayers.findById('3'),
      courseName: '남서울 컨트리클럽',
      totalScore: 60,
      par: 54,
      date: '2025-10-08',
      holeScores: [5, 5, 3, 5, 4, 6, 4, 4, 5, 4, 5, 5, 3, 6], // 14홀
      birdies: 0,
      pars: 8,
      bogeys: 6,
      currentHole: 14,
      isLive: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      roundingId: '2',
    ),
    // 최동현 - 14홀까지 +1 (55타) - 선두
    Score(
      id: 'live_score_4',
      player: MockPlayers.findById('5'),
      courseName: '남서울 컨트리클럽',
      totalScore: 55,
      par: 54,
      date: '2025-10-08',
      holeScores: [
        4,
        4,
        2,
        4,
        4,
        5,
        3,
        4,
        4,
        4,
        4,
        6,
        3,
        4,
      ], // 14홀 (1 birdie on hole 3)
      birdies: 1,
      pars: 11,
      bogeys: 2,
      currentHole: 14,
      isLive: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
      roundingId: '2',
    ),
  ];

  static final List<ScoreRecord> all = [
    ScoreRecord(
      id: '1',
      player: MockPlayers.currentUser,
      courseName: '용인 컨트리클럽',
      date: DateTime.now().subtract(const Duration(days: 3)),
      totalScore: 88,
      par: 72,
      handicap: 18,
      holeScores: [5, 4, 3, 5, 4, 6, 3, 4, 5, 4, 5, 6, 3, 4, 5, 6, 3, 5],
      notes: '좋은 컨디션으로 플레이',
    ),
    ScoreRecord(
      id: '2',
      player: MockPlayers.currentUser,
      courseName: '남서울 컨트리클럽',
      date: DateTime.now().subtract(const Duration(days: 10)),
      totalScore: 92,
      par: 72,
      handicap: 18,
      holeScores: [6, 5, 4, 5, 5, 6, 4, 5, 5, 5, 5, 6, 4, 5, 6, 6, 4, 6],
    ),
    ScoreRecord(
      id: '3',
      player: MockPlayers.currentUser,
      courseName: '레이크사이드 CC',
      date: DateTime.now().subtract(const Duration(days: 17)),
      totalScore: 85,
      par: 72,
      handicap: 18,
      holeScores: [4, 5, 3, 4, 5, 5, 3, 4, 4, 5, 4, 6, 3, 4, 5, 5, 3, 5],
      notes: '퍼팅이 좋았던 날',
    ),
    ScoreRecord(
      id: '4',
      player: MockPlayers.currentUser,
      courseName: '파인힐 골프클럽',
      date: DateTime.now().subtract(const Duration(days: 24)),
      totalScore: 90,
      par: 72,
      handicap: 18,
      holeScores: [5, 5, 4, 5, 5, 6, 4, 4, 5, 5, 5, 5, 3, 5, 5, 6, 4, 5],
    ),
    ScoreRecord(
      id: '5',
      player: MockPlayers.currentUser,
      courseName: '스카이72',
      date: DateTime.now().subtract(const Duration(days: 31)),
      totalScore: 95,
      par: 72,
      handicap: 18,
      holeScores: [6, 5, 4, 6, 5, 6, 4, 5, 6, 5, 6, 6, 4, 5, 6, 6, 4, 6],
      notes: '바람이 많이 불었음',
    ),
    ScoreRecord(
      id: '6',
      player: MockPlayers.currentUser,
      courseName: '안성 베네스트',
      date: DateTime.now().subtract(const Duration(days: 45)),
      totalScore: 87,
      par: 72,
      handicap: 18,
      holeScores: [5, 4, 3, 5, 4, 5, 3, 4, 5, 4, 5, 6, 3, 4, 5, 6, 3, 5],
    ),
  ];

  static ScoreRecord findById(String id) {
    return all.firstWhere((score) => score.id == id, orElse: () => all.first);
  }

  static List<ScoreRecord> excellentScores() {
    return all.where((s) => s.quality == ScoreQuality.excellent).toList();
  }

  static List<ScoreRecord> goodScores() {
    return all.where((s) => s.quality == ScoreQuality.good).toList();
  }

  static List<ScoreRecord> recentScores({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return all.where((s) => s.date.isAfter(cutoff)).toList();
  }
}
