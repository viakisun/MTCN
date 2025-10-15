import '../data/models/player.dart';

class Score {
  final String id;
  final Player player;
  final String courseName;
  final int totalScore;
  final int par;
  final String date;
  final int birdies;
  final int pars;
  final int bogeys;
  final List<int> holeScores;

  // Phase 2 Week 3: 실시간 스코어 추가 필드
  final int currentHole; // 현재 홀 번호 (1-18)
  final bool isLive; // 실시간 진행 중
  final DateTime? lastUpdated; // 마지막 업데이트 시간
  final double? latitude; // GPS 위도
  final double? longitude; // GPS 경도
  final String? roundingId; // 라운딩 ID

  const Score({
    required this.id,
    required this.player,
    required this.courseName,
    required this.totalScore,
    required this.par,
    required this.date,
    this.birdies = 0,
    this.pars = 0,
    this.bogeys = 0,
    this.holeScores = const [],
    this.currentHole = 1,
    this.isLive = false,
    this.lastUpdated,
    this.latitude,
    this.longitude,
    this.roundingId,
  });

  Score copyWith({
    String? id,
    Player? player,
    String? courseName,
    int? totalScore,
    int? par,
    String? date,
    int? birdies,
    int? pars,
    int? bogeys,
    List<int>? holeScores,
    int? currentHole,
    bool? isLive,
    DateTime? lastUpdated,
    double? latitude,
    double? longitude,
    String? roundingId,
  }) {
    return Score(
      id: id ?? this.id,
      player: player ?? this.player,
      courseName: courseName ?? this.courseName,
      totalScore: totalScore ?? this.totalScore,
      par: par ?? this.par,
      date: date ?? this.date,
      birdies: birdies ?? this.birdies,
      pars: pars ?? this.pars,
      bogeys: bogeys ?? this.bogeys,
      holeScores: holeScores ?? this.holeScores,
      currentHole: currentHole ?? this.currentHole,
      isLive: isLive ?? this.isLive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      roundingId: roundingId ?? this.roundingId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player': player.toJson(),
      'courseName': courseName,
      'totalScore': totalScore,
      'par': par,
      'date': date,
      'birdies': birdies,
      'pars': pars,
      'bogeys': bogeys,
      'holeScores': holeScores,
      'currentHole': currentHole,
      'isLive': isLive,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'roundingId': roundingId,
    };
  }

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'] as String,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      courseName: json['courseName'] as String,
      totalScore: json['totalScore'] as int,
      par: json['par'] as int,
      date: json['date'] as String,
      birdies: json['birdies'] as int? ?? 0,
      pars: json['pars'] as int? ?? 0,
      bogeys: json['bogeys'] as int? ?? 0,
      holeScores: (json['holeScores'] as List<dynamic>?)?.cast<int>() ?? [],
      currentHole: json['currentHole'] as int? ?? 1,
      isLive: json['isLive'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      roundingId: json['roundingId'] as String?,
    );
  }
}
