import '../../core/enums/score_enums.dart';

/// 스코어 레코드 모델 (리팩토링된 버전)
class ScoreRecord {
  final String id;
  final String playerId;
  final String roundingId;
  final Map<int, int> scores; // 홀별 스코어 (홀 번호 -> 타수)
  final int totalScore;
  final ScoreQuality quality;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ScoreType type;
  final Map<int, int>? putts; // 홀별 퍼트 수
  final Map<int, bool>? fairwayHits; // 홀별 페어웨이 적중
  final Map<int, bool>? greenInRegulation; // 홀별 그린 적중
  final String? notes;
  final List<String> achievements;

  const ScoreRecord({
    required this.id,
    required this.playerId,
    required this.roundingId,
    required this.scores,
    required this.totalScore,
    required this.quality,
    required this.createdAt,
    required this.updatedAt,
    this.type = ScoreType.stroke,
    this.putts,
    this.fairwayHits,
    this.greenInRegulation,
    this.notes,
    this.achievements = const [],
  });

  ScoreRecord copyWith({
    String? id,
    String? playerId,
    String? roundingId,
    Map<int, int>? scores,
    int? totalScore,
    ScoreQuality? quality,
    DateTime? createdAt,
    DateTime? updatedAt,
    ScoreType? type,
    Map<int, int>? putts,
    Map<int, bool>? fairwayHits,
    Map<int, bool>? greenInRegulation,
    String? notes,
    List<String>? achievements,
  }) {
    return ScoreRecord(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      roundingId: roundingId ?? this.roundingId,
      scores: scores ?? this.scores,
      totalScore: totalScore ?? this.totalScore,
      quality: quality ?? this.quality,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      putts: putts ?? this.putts,
      fairwayHits: fairwayHits ?? this.fairwayHits,
      greenInRegulation: greenInRegulation ?? this.greenInRegulation,
      notes: notes ?? this.notes,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'roundingId': roundingId,
      'scores': scores,
      'totalScore': totalScore,
      'quality': quality.apiValue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'type': type.apiValue,
      'putts': putts,
      'fairwayHits': fairwayHits,
      'greenInRegulation': greenInRegulation,
      'notes': notes,
      'achievements': achievements,
    };
  }

  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      roundingId: json['roundingId'] as String,
      scores: Map<int, int>.from(json['scores'] as Map),
      totalScore: json['totalScore'] as int,
      quality: ScoreQuality.fromString(json['quality'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      type: ScoreType.fromString(json['type'] as String? ?? 'stroke'),
      putts: json['putts'] != null
          ? Map<int, int>.from(json['putts'] as Map)
          : null,
      fairwayHits: json['fairwayHits'] != null
          ? Map<int, bool>.from(json['fairwayHits'] as Map)
          : null,
      greenInRegulation: json['greenInRegulation'] != null
          ? Map<int, bool>.from(json['greenInRegulation'] as Map)
          : null,
      notes: json['notes'] as String?,
      achievements: List<String>.from(json['achievements'] as List? ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoreRecord && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ScoreRecord(id: $id, playerId: $playerId, totalScore: $totalScore)';
}
