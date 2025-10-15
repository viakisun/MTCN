import '../data/models/player.dart';

enum AchievementType {
  holeInOne, // 홀인원
  eagle, // 이글
  albatross, // 알바트로스
  firstPlace, // 우승
  secondPlace, // 준우승
  thirdPlace, // 3위
  bestScore, // 베스트 스코어 갱신
  underPar, // 언더파
  perfectPutt, // 퍼펙트 퍼트
}

class Achievement {
  final String id;
  final AchievementType type;
  final Player player;
  final String roundingId;
  final int? holeNumber;
  final int? score;
  final DateTime timestamp;
  final String? description;

  const Achievement({
    required this.id,
    required this.type,
    required this.player,
    required this.roundingId,
    this.holeNumber,
    this.score,
    required this.timestamp,
    this.description,
  });

  String get title {
    switch (type) {
      case AchievementType.holeInOne:
        return '🎯 홀인원!';
      case AchievementType.eagle:
        return '🦅 이글!';
      case AchievementType.albatross:
        return '🦢 알바트로스!';
      case AchievementType.firstPlace:
        return '🏆 우승!';
      case AchievementType.secondPlace:
        return '🥈 준우승!';
      case AchievementType.thirdPlace:
        return '🥉 3위!';
      case AchievementType.bestScore:
        return '⭐ 베스트 스코어 갱신!';
      case AchievementType.underPar:
        return '🎊 언더파 달성!';
      case AchievementType.perfectPutt:
        return '⛳ 퍼펙트 퍼트!';
    }
  }

  String get message {
    final name = player.name;
    switch (type) {
      case AchievementType.holeInOne:
        return '$name님이 $holeNumber번 홀에서 홀인원을 기록했습니다!';
      case AchievementType.eagle:
        return '$name님이 $holeNumber번 홀에서 이글을 기록했습니다!';
      case AchievementType.albatross:
        return '$name님이 $holeNumber번 홀에서 알바트로스를 기록했습니다!';
      case AchievementType.firstPlace:
        return '$name님이 우승했습니다! 🎉';
      case AchievementType.secondPlace:
        return '$name님이 준우승했습니다!';
      case AchievementType.thirdPlace:
        return '$name님이 3위를 차지했습니다!';
      case AchievementType.bestScore:
        return '$name님이 베스트 스코어 $score타를 기록했습니다!';
      case AchievementType.underPar:
        return '$name님이 언더파를 달성했습니다!';
      case AchievementType.perfectPutt:
        return '$name님이 $holeNumber번 홀에서 원퍼트를 성공했습니다!';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'player': player.toJson(),
      'roundingId': roundingId,
      'holeNumber': holeNumber,
      'score': score,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      roundingId: json['roundingId'] as String,
      holeNumber: json['holeNumber'] as int?,
      score: json['score'] as int?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      description: json['description'] as String?,
    );
  }
}
