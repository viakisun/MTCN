import 'dart:async';
import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/achievement.dart';
import '../data/mock/mock_players.dart';

class AchievementDemoService {
  static const _uuid = Uuid();
  static final _random = Random();

  /// Generate a random achievement for demo purposes
  static Achievement generateRandomAchievement() {
    final types = AchievementType.values;
    final type = types[_random.nextInt(types.length)];
    final players = MockPlayers.all;
    final player = players[_random.nextInt(players.length)];

    int? holeNumber;
    int? score;

    switch (type) {
      case AchievementType.holeInOne:
      case AchievementType.eagle:
      case AchievementType.albatross:
      case AchievementType.perfectPutt:
        holeNumber = 1 + _random.nextInt(18);
        break;
      case AchievementType.bestScore:
        score = 68 + _random.nextInt(15); // 68-82
        break;
      default:
        break;
    }

    return Achievement(
      id: _uuid.v4(),
      type: type,
      player: player,
      roundingId: _uuid.v4(),
      holeNumber: holeNumber,
      score: score,
      timestamp: DateTime.now(),
    );
  }

  /// Start demo timer that generates achievements every 40 seconds
  static Timer startDemoTimer(void Function(Achievement) onAchievement) {
    return Timer.periodic(const Duration(seconds: 40), (timer) {
      final achievement = generateRandomAchievement();
      onAchievement(achievement);
    });
  }
}
