import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';
import '../data/models/player.dart';
import '../models/rounding.dart';
import '../data/models/group.dart';
import '../data/models/group_member.dart';
import '../core/enums/group_enums.dart';
import '../models/score_record.dart';
import '../models/chat_message.dart';

class MockDataService {
  static final _faker = Faker();
  static const _uuid = Uuid();

  // Korean names for more authentic data
  static final List<String> _koreanNames = [
    '김민수',
    '이영희',
    '박철수',
    '최지혜',
    '정성훈',
    '강미영',
    '조현우',
    '윤서연',
    '임태준',
    '한지민',
    '서준호',
    '배수지',
    '오현석',
    '권나영',
    '송재현',
  ];

  static final List<String> _golfCourses = [
    '제주 핀크스 골프클럽',
    '남서울 컨트리클럽',
    '용인 베어크리크 골프클럽',
    '안양 베네스트 골프클럽',
    '레이크우드 컨트리클럽',
    '블루원 용인',
    '화산 컨트리클럽',
    '썬힐 골프클럽',
  ];

  static final List<String> _groupNames = [
    '서울대 경영대 동문회',
    '강남 사장님 모임',
    '성수동 스타트업 대표 모임',
    '주말 골프 크루',
    '대학 동기 모임',
    '여의도 금융맨 모임',
    '판교 IT 모임',
  ];

  // Generate mock players
  static List<Player> generatePlayers(int count) {
    return List.generate(count, (index) {
      final name = _koreanNames[index % _koreanNames.length];
      // Split Korean name into first and last name
      final lastName = name.substring(0, 1);
      final firstName = name.substring(1);

      return Player(
        id: _uuid.v4(),
        name: name,
        firstName: firstName,
        lastName: lastName,
        averageScore: 75 + _faker.randomGenerator.integer(30),
        bestScore: 68 + _faker.randomGenerator.integer(20),
        handicap: _faker.randomGenerator.integer(36),
        avatar: 'https://picsum.photos/150/150?random=${index + 1}',
        isPlaying: _faker.randomGenerator.boolean(),
      );
    }).toList();
  }

  // Generate mock roundings
  static List<Rounding> generateRoundings(int count, List<Player> players) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      final daysOffset = -30 + (index * 5);
      final date = now.add(Duration(days: daysOffset));

      RoundingStatus status;
      if (daysOffset < -2) {
        status = RoundingStatus.completed;
      } else if (daysOffset > 2) {
        status = RoundingStatus.upcoming;
      } else {
        status = RoundingStatus.inProgress;
      }

      final selectedPlayers = players
          .take(2 + _faker.randomGenerator.integer(3))
          .toList();

      return Rounding(
        id: _uuid.v4(),
        courseName:
            _golfCourses[_faker.randomGenerator.integer(_golfCourses.length)],
        eventName: '${_getMonth(date.month)}월 정기 라운딩',
        groupName:
            _groupNames[_faker.randomGenerator.integer(_groupNames.length)],
        date: _formatDate(date),
        time: '${8 + _faker.randomGenerator.integer(6)}:00',
        status: status,
        greenFee: 120000 + (_faker.randomGenerator.integer(10) * 10000),
        weather: _getWeather(),
        temperature: 15 + _faker.randomGenerator.integer(20),
        players: selectedPlayers,
        holes: 18,
        description: '즐거운 라운딩 되세요!',
        currentHole: status == RoundingStatus.inProgress
            ? 1 + _faker.randomGenerator.integer(17)
            : null,
        totalHoles: 18,
      );
    }).toList();
  }

  // Generate mock groups with varied sizes
  static List<Group> generateGroups(int count, List<Player> players) {
    // Premium alumni groups (100+ members)
    final alumniGroups = [
      '서울대 경영대 87학번 모임',
      '연세대 의대 92학번 동문회',
      '고려대 법대 89학번 골프회',
      'KAIST 전산학과 95학번',
    ];

    // Large groups (50+ members)
    final largeGroups = [
      '강남 CEO 골프클럽',
      '판교 스타트업 라운딩',
      '여의도 금융인 골프회',
      '삼성동 엘리트 모임',
    ];

    // Medium groups (20-50 members)
    final mediumGroups = ['주말 골프 크루', '월례 라운딩 모임', '경기도 골프회', '서초 골프 클럽'];

    // Small groups (nicknames)
    final smallGroups = [
      '버디헌터즈',
      '파 브레이커스',
      '이글 체이서즈',
      '홀인원 드림팀',
      '골프매니아',
      '주중 라운딩',
      '친구들',
      '골프 좋아하는 사람들',
    ];

    return List.generate(count, (index) {
      final createdAt = DateTime.now().subtract(
        Duration(days: _faker.randomGenerator.integer(90)),
      );

      // Determine group type and size
      String groupName;
      int memberCount;
      bool isPremium = false;
      String description;

      if (index == 0) {
        // Premium alumni group (100+ members)
        groupName = alumniGroups[0];
        memberCount = 135;
        isPremium = true;
        description = '서울대학교 경영대학 87학번 동문들의 프리미엄 골프 모임입니다';
      } else if (index == 1) {
        // Large group
        groupName = largeGroups[0];
        memberCount = 78;
        description = '강남 지역 CEO들의 네트워킹 골프 클럽입니다';
      } else if (index == 2) {
        // Premium alumni group
        groupName = alumniGroups[1];
        memberCount = 112;
        isPremium = true;
        description = '연세대학교 의과대학 92학번 동문들의 정기 라운딩 모임';
      } else if (index == 3) {
        // Medium group
        groupName = mediumGroups[index % mediumGroups.length];
        memberCount = 20 + _faker.randomGenerator.integer(30);
        description = '주말마다 함께하는 즐거운 골프 모임';
      } else if (index < 6) {
        // Small group
        groupName = mediumGroups[(index - 4) % mediumGroups.length];
        memberCount = 10 + _faker.randomGenerator.integer(10);
        description = '정기적으로 라운딩하는 친목 모임';
      } else {
        // Mini groups (nicknames)
        groupName = smallGroups[(index - 6) % smallGroups.length];
        memberCount = 3 + _faker.randomGenerator.integer(7);
        description = '골프를 사랑하는 사람들의 소규모 크루';
      }

      // Generate enough players if needed
      final selectedPlayers = <Player>[];

      // For the first premium group, add current user as the first member
      if (index == 0 && players.isNotEmpty) {
        selectedPlayers.add(players[0]); // Current user
      }

      for (int i = (index == 0 ? 1 : 0); i < memberCount; i++) {
        if (i < players.length) {
          selectedPlayers.add(players[i]);
        } else {
          // Generate additional players if needed
          final name = _koreanNames[i % _koreanNames.length];
          final lastName = name.substring(0, 1);
          final firstName = name.substring(1);

          selectedPlayers.add(
            Player(
              id: _uuid.v4(),
              name: '$name$i', // Add index to make unique
              firstName: firstName,
              lastName: lastName,
              averageScore: 75 + _faker.randomGenerator.integer(30),
              bestScore: 68 + _faker.randomGenerator.integer(20),
              handicap: _faker.randomGenerator.integer(36),
              avatar: '',
              isPlaying: false,
            ),
          );
        }
      }

      // Convert Player list to GroupMember list
      final groupId = _uuid.v4();
      final groupMembers = selectedPlayers.map((player) {
        return GroupMember(
          id: _uuid.v4(),
          groupId: groupId,
          playerId: player.id,
          player: player,
          role: MemberRole.member,
          status: MemberStatus.active,
          joinedAt: createdAt,
        );
      }).toList();

      return Group(
        id: groupId,
        name: groupName,
        description: description,
        isPublic: true,
        status: GroupStatus.active, // Premium groups are always active
        members: groupMembers,
        createdAt: createdAt,
        roundCount: 0,
        isPremium: isPremium,
      );
    }).toList();
  }

  // Generate mock score records
  static List<ScoreRecord> generateScoreRecords(
    int count,
    List<Player> players,
  ) {
    return List.generate(count, (index) {
      final player = players[index % players.length];
      final date = DateTime.now().subtract(
        Duration(days: _faker.randomGenerator.integer(180)),
      );
      final par = 72;
      final totalScore = 65 + _faker.randomGenerator.integer(40);

      return ScoreRecord(
        id: _uuid.v4(),
        player: player,
        courseName:
            _golfCourses[_faker.randomGenerator.integer(_golfCourses.length)],
        date: date,
        totalScore: totalScore,
        par: par,
        handicap: player.handicap,
        holeScores: _generateHoleScores(totalScore),
      );
    }).toList();
  }

  // Generate mock chat messages
  static List<ChatMessage> generateChatMessages(
    int count,
    List<Player> players,
  ) {
    final messages = <ChatMessage>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final sender = players[_faker.randomGenerator.integer(players.length)];
      final timestamp = now.subtract(Duration(minutes: count - i));

      messages.add(
        ChatMessage(
          id: _uuid.v4(),
          sender: sender,
          content: _getChatMessage(),
          type: MessageType.text,
          timestamp: timestamp,
          isRead: _faker.randomGenerator.boolean(),
        ),
      );
    }

    return messages;
  }

  // Helper methods
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String _getMonth(int month) {
    return month.toString();
  }

  static String _getWeather() {
    final weathers = ['맑음', '구름', '흐림', '비', '눈'];
    return weathers[_faker.randomGenerator.integer(weathers.length)];
  }

  static List<int> _generateHoleScores(int totalScore) {
    // Standard 18-hole course: 4 par-3s, 4 par-5s, 10 par-4s
    final parValues = [
      4, 5, 3, 4, 4, 5, 3, 4, 4, // Front 9 (par 36)
      4, 4, 5, 3, 4, 4, 5, 3, 4, // Back 9 (par 36)
    ];

    final scores = <int>[];
    int remaining = totalScore;

    // Generate scores for first 17 holes
    for (int i = 0; i < 17; i++) {
      final par = parValues[i];
      // Generate realistic scores around par (-1 to +3)
      final variance = _faker.randomGenerator.integer(5) - 1; // -1, 0, 1, 2, 3
      int score = par + variance;

      // Ensure score is reasonable (minimum 2 for eagle, maximum par+4)
      score = score.clamp(2, par + 4);

      scores.add(score);
      remaining -= score;
    }

    // Adjust the last hole to match total score
    // But keep it reasonable (between 2 and 9)
    final lastHoleScore = remaining.clamp(2, 9);
    scores.add(lastHoleScore);

    return scores;
  }

  static String _getChatMessage() {
    final messages = [
      '다음 주 라운딩 어떠세요?',
      '오늘 날씨가 좋네요!',
      '스코어 잘 나왔어요',
      '다음에는 꼭 참석하겠습니다',
      '골프장 추천 부탁드립니다',
      '저번 라운딩 재미있었어요',
      '다들 연습 많이 하셨나요?',
      '이번 주말 가능하신 분?',
    ];
    return messages[_faker.randomGenerator.integer(messages.length)];
  }
}
