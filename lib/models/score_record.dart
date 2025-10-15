import '../data/models/player.dart';

enum ScoreQuality { excellent, good, average, poor }

class ScoreRecord {
  final String id;
  final Player player;
  final String courseName;
  final DateTime date;
  final int totalScore;
  final int par;
  final int handicap;
  final List<int>? holeScores;
  final String? notes;

  const ScoreRecord({
    required this.id,
    required this.player,
    required this.courseName,
    required this.date,
    required this.totalScore,
    required this.par,
    required this.handicap,
    this.holeScores,
    this.notes,
  });

  ScoreRecord copyWith({
    String? id,
    Player? player,
    String? courseName,
    DateTime? date,
    int? totalScore,
    int? par,
    int? handicap,
    List<int>? holeScores,
    String? notes,
  }) {
    return ScoreRecord(
      id: id ?? this.id,
      player: player ?? this.player,
      courseName: courseName ?? this.courseName,
      date: date ?? this.date,
      totalScore: totalScore ?? this.totalScore,
      par: par ?? this.par,
      handicap: handicap ?? this.handicap,
      holeScores: holeScores ?? this.holeScores,
      notes: notes ?? this.notes,
    );
  }

  int get scoreToPar => totalScore - par;

  ScoreQuality get quality {
    final diff = scoreToPar;
    if (diff <= -5) return ScoreQuality.excellent;
    if (diff <= 0) return ScoreQuality.good;
    if (diff <= 5) return ScoreQuality.average;
    return ScoreQuality.poor;
  }

  String get qualityString {
    switch (quality) {
      case ScoreQuality.excellent:
        return 'excellent';
      case ScoreQuality.good:
        return 'good';
      case ScoreQuality.average:
        return 'average';
      case ScoreQuality.poor:
        return 'poor';
    }
  }

  static ScoreQuality qualityFromString(String quality) {
    switch (quality) {
      case 'excellent':
        return ScoreQuality.excellent;
      case 'good':
        return ScoreQuality.good;
      case 'average':
        return ScoreQuality.average;
      case 'poor':
        return ScoreQuality.poor;
      default:
        return ScoreQuality.average;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player': player.toJson(),
      'courseName': courseName,
      'date': date.toIso8601String(),
      'totalScore': totalScore,
      'par': par,
      'handicap': handicap,
      'holeScores': holeScores,
      'notes': notes,
    };
  }

  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      id: json['id'] as String,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      courseName: json['courseName'] as String,
      date: DateTime.parse(json['date'] as String),
      totalScore: json['totalScore'] as int,
      par: json['par'] as int,
      handicap: json['handicap'] as int,
      holeScores: (json['holeScores'] as List?)?.cast<int>(),
      notes: json['notes'] as String?,
    );
  }
}
