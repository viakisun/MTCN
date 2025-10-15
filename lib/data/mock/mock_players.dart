import '../models/player.dart';

/// Mock player data for development
class MockPlayers {
  static final Player currentUser = Player(
    id: '1',
    name: '김민수',
    firstName: '민수',
    lastName: '김',
    averageScore: 82,
    bestScore: 75,
    handicap: 10,
    avatar: '',
  );

  static final List<Player> all = [
    currentUser,
    // Pro tier (handicap 0-5)
    Player(
      id: '2',
      name: '이영희',
      firstName: '영희',
      lastName: '이',
      averageScore: 74,
      bestScore: 68,
      handicap: 3,
      avatar: '',
    ),
    // Expert tier (handicap 6-12)
    Player(
      id: '3',
      name: '박철수',
      firstName: '철수',
      lastName: '박',
      averageScore: 82,
      bestScore: 76,
      handicap: 10,
      avatar: '',
    ),
    // Intermediate tier (handicap 13-20)
    Player(
      id: '4',
      name: '정수진',
      firstName: '수진',
      lastName: '정',
      averageScore: 88,
      bestScore: 80,
      handicap: 15,
      avatar: '',
    ),
    // Expert tier
    Player(
      id: '5',
      name: '최동현',
      firstName: '동현',
      lastName: '최',
      averageScore: 79,
      bestScore: 72,
      handicap: 7,
      avatar: '',
    ),
    // Beginner tier (handicap 21+)
    Player(
      id: '6',
      name: '한미영',
      firstName: '미영',
      lastName: '한',
      averageScore: 98,
      bestScore: 89,
      handicap: 24,
      avatar: '',
    ),
    // Expert tier
    Player(
      id: '7',
      name: '강태훈',
      firstName: '태훈',
      lastName: '강',
      averageScore: 84,
      bestScore: 77,
      handicap: 11,
      avatar: '',
    ),
    // Pro tier
    Player(
      id: '8',
      name: '윤서연',
      firstName: '서연',
      lastName: '윤',
      averageScore: 76,
      bestScore: 70,
      handicap: 5,
      avatar: '',
    ),
  ];

  static Player findById(String id) {
    return all.firstWhere(
      (player) => player.id == id,
      orElse: () => currentUser,
    );
  }

  static List<Player> findByIds(List<String> ids) {
    return ids.map((id) => findById(id)).toList();
  }

  static List<Player> getRandomPlayers(int count) {
    final shuffled = List<Player>.from(all)..shuffle();
    return shuffled.take(count).toList();
  }
}
