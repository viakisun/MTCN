import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../core/enums/chat_enums.dart';
import '../../core/enums/group_enums.dart';
import '../../core/enums/rounding_enums.dart';
import '../../core/enums/score_enums.dart';
import '../models/chat_message.dart';
import '../models/group.dart';
import '../models/group_member.dart';
import '../models/invitation.dart';
import '../models/player.dart';
import '../models/rounding.dart';
import '../models/score_record.dart';
// import 'package:faker/faker.dart'; // 임시로 주석 처리
import 'dart:math';

/// Mock 데이터베이스 서비스 인터페이스
/// 실제 데이터베이스 서비스로 교체될 수 있도록 추상화합니다.
abstract class IDatabaseService {
  // Rounding
  Future<List<Rounding>> getRoundings({
    String? statusFilter,
    String? searchKeyword,
  });
  Future<Rounding?> getRoundingById(String id);
  Future<Rounding> createRounding(Rounding rounding);
  Future<Rounding> updateRounding(Rounding rounding);
  Future<void> deleteRounding(String id);

  // Group
  Future<List<Group>> getGroups({String? statusFilter, String? searchKeyword});
  Future<Group?> getGroupById(String id);
  Future<Group> createGroup(Group group);
  Future<Group> updateGroup(Group group);
  Future<void> deleteGroup(String id);

  // Player
  Future<List<Player>> getPlayers({String? searchKeyword});
  Future<Player?> getPlayerById(String id);
  Future<Player> createPlayer(Player player);
  Future<Player> updatePlayer(Player player);

  // ScoreRecord
  Future<List<ScoreRecord>> getScoreRecords({
    String? playerId,
    String? roundingId,
    String? qualityFilter,
  });
  Future<ScoreRecord?> getScoreRecordById(String id);
  Future<ScoreRecord> createScoreRecord(ScoreRecord scoreRecord);
  Future<ScoreRecord> updateScoreRecord(ScoreRecord scoreRecord);

  // ChatMessage
  Future<List<ChatMessage>> getChatMessages(String groupId);
  Future<ChatMessage> sendChatMessage(ChatMessage message);

  // GroupMember
  Future<List<GroupMember>> getGroupMembers(
    String groupId, {
    String? statusFilter,
  });
  Future<GroupMember> addGroupMember(GroupMember member);
  Future<GroupMember> updateGroupMember(GroupMember member);
  Future<void> removeGroupMember(String memberId);

  // Invitation
  Future<List<Invitation>> getInvitations({
    String? groupId,
    String? recipientId,
    String? statusFilter,
  });
  Future<Invitation> createInvitation(Invitation invitation);
  Future<Invitation> updateInvitation(Invitation invitation);
  Future<void> deleteInvitation(String id);
}

/// Mock 데이터베이스 서비스 구현체
/// 실제 백엔드 API 호출 대신 메모리 내 데이터를 사용합니다.
class MockDatabaseService implements IDatabaseService {
  final Uuid _uuid = const Uuid();
  // final Faker _faker = Faker(provider: FakerDataProvider.withLocale(FakerLocale.ko_KR)); // 임시로 주석 처리
  final Random _random = Random();

  // In-memory data stores
  final Map<String, Rounding> _roundings = {};
  final Map<String, Group> _groups = {};
  final Map<String, Player> _players = {};
  final Map<String, ScoreRecord> _scoreRecords = {};
  final Map<String, List<ChatMessage>> _chatMessages = {};
  final Map<String, GroupMember> _groupMembers = {};
  final Map<String, Invitation> _invitations = {};

  MockDatabaseService._internal() {
    _initializeMockData();
  }
  factory MockDatabaseService() => _instance;
  static final MockDatabaseService _instance = MockDatabaseService._internal();

  // Simulate network delay
  Future<T> _simulateDelay<T>(T result) async {
    await Future.delayed(Duration(milliseconds: _random.nextInt(400) + 100));
    return result;
  }

  // --- Mock Data Generation ---
  void _initializeMockData() {
    // Create sample players
    final players = [
      Player(
        id: 'player_1',
        name: '김철수',
        firstName: '철수',
        lastName: '김',
        averageScore: 85,
        bestScore: 72,
        handicap: 12,
        avatar: 'https://example.com/avatar1.jpg',
        isPlaying: false,
      ),
      Player(
        id: 'player_2',
        name: '이영희',
        firstName: '영희',
        lastName: '이',
        averageScore: 92,
        bestScore: 78,
        handicap: 18,
        avatar: 'https://example.com/avatar2.jpg',
        isPlaying: true,
      ),
      Player(
        id: 'player_3',
        name: '박민수',
        firstName: '민수',
        lastName: '박',
        averageScore: 88,
        bestScore: 75,
        handicap: 15,
        avatar: 'https://example.com/avatar3.jpg',
        isPlaying: false,
      ),
    ];

    // Store players
    for (final player in players) {
      _players[player.id] = player;
    }

    // Create sample groups
    final groups = [
      Group(
        id: 'group_1',
        name: '서울 골프 클럽',
        description: '서울 지역 골프 클럽',
        isPublic: true,
        status: GroupStatus.active,
        roundCount: 15, // 추가
        members: [
          GroupMember(
            id: 'member_1',
            groupId: 'group_1',
            playerId: 'player_1',
            role: MemberRole.admin,
            status: MemberStatus.active,
            joinedAt: DateTime.now().subtract(Duration(days: 30)),
            player: players[0],
          ),
          GroupMember(
            id: 'member_2',
            groupId: 'group_1',
            playerId: 'player_2',
            role: MemberRole.member,
            status: MemberStatus.active,
            joinedAt: DateTime.now().subtract(Duration(days: 15)),
            player: players[1],
          ),
        ],
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
    ];

    // Store groups
    for (final group in groups) {
      _groups[group.id] = group;
    }

    // Create sample roundings
    final roundings = [
      Rounding(
        id: 'rounding_1',
        title: '주말 라운딩',
        courseName: '스카이72 골프클럽',
        courseAddress: '인천광역시 중구 공항동로 424번길 186',
        date: DateTime.now()
            .add(Duration(days: 1))
            .toIso8601String()
            .split('T')[0],
        time: '09:00',
        status: RoundingStatus.upcoming,
        greenFee: 180000,
        weather: '맑음',
        temperature: 22,
        players: [players[0], players[1]],
        holes: 18,
        description: '주말 아침 라운딩',
        groupName: '서울 골프 클럽',
        fee: 50000,
        maxPlayers: 4,
        type: RoundingType.full18,
        privacy: RoundingPrivacy.public,
        difficulty: RoundingDifficulty.intermediate,
      ),
    ];

    // Store roundings
    for (final rounding in roundings) {
      _roundings[rounding.id] = rounding;
    }

    // Create sample scores
    final scores = [
      ScoreRecord(
        id: 'score_1',
        playerId: 'player_1',
        roundingId: 'rounding_1',
        scores: {for (int i = 1; i <= 18; i++) i: 4},
        totalScore: 72,
        quality: ScoreQuality.good,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    // Store scores
    for (final score in scores) {
      _scoreRecords[score.id] = score;
    }

    // Create sample chat messages
    final messages = [
      ChatMessage(
        id: 'msg_1',
        groupId: 'group_1',
        senderId: 'player_1',
        senderName: '김철수',
        senderAvatarUrl: 'https://example.com/avatar1.jpg',
        content: '안녕하세요! 라운딩 준비되셨나요?',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg_2',
        groupId: 'group_1',
        senderId: 'player_2',
        senderName: '이영희',
        senderAvatarUrl: 'https://example.com/avatar2.jpg',
        content: '네, 준비됐습니다!',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        type: MessageType.text,
      ),
    ];

    // Store chat messages
    _chatMessages['group_1'] = messages;
  }

  // --- Rounding CRUD ---
  @override
  Future<List<Rounding>> getRoundings({
    String? statusFilter,
    String? searchKeyword,
  }) async {
    return _simulateDelay(
      _roundings.values.where((r) {
        bool matchesFilter = true;
        if (statusFilter != null) {
          matchesFilter = r.status.apiValue == statusFilter;
        }
        bool matchesSearch = true;
        if (searchKeyword != null && searchKeyword.isNotEmpty) {
          final query = searchKeyword.toLowerCase();
          matchesSearch =
              r.title.toLowerCase().contains(query) ||
              r.courseName.toLowerCase().contains(query) ||
              r.groupName.toLowerCase().contains(query) ||
              r.players.any((p) => p.name.toLowerCase().contains(query));
        }
        return matchesFilter && matchesSearch;
      }).toList(),
    );
  }

  @override
  Future<Rounding?> getRoundingById(String id) async {
    return _simulateDelay(_roundings[id]);
  }

  @override
  Future<Rounding> createRounding(Rounding rounding) async {
    final newRounding = rounding.copyWith(id: _uuid.v4());
    _roundings[newRounding.id] = newRounding;
    return _simulateDelay(newRounding);
  }

  @override
  Future<Rounding> updateRounding(Rounding rounding) async {
    if (!_roundings.containsKey(rounding.id)) {
      throw Exception('Rounding not found');
    }
    _roundings[rounding.id] = rounding;
    return _simulateDelay(rounding);
  }

  @override
  Future<void> deleteRounding(String id) async {
    _roundings.remove(id);
    return _simulateDelay(null);
  }

  // --- Group CRUD ---
  @override
  Future<List<Group>> getGroups({
    String? statusFilter,
    String? searchKeyword,
  }) async {
    return _simulateDelay(
      _groups.values.where((g) {
        bool matchesFilter = true;
        if (statusFilter != null) {
          matchesFilter = g.status.apiValue == statusFilter;
        }
        bool matchesSearch = true;
        if (searchKeyword != null && searchKeyword.isNotEmpty) {
          final query = searchKeyword.toLowerCase();
          matchesSearch =
              g.name.toLowerCase().contains(query) ||
              g.description.toLowerCase().contains(query) ||
              g.members.any((m) => m.player.name.toLowerCase().contains(query));
        }
        return matchesFilter && matchesSearch;
      }).toList(),
    );
  }

  @override
  Future<Group?> getGroupById(String id) async {
    return _simulateDelay(_groups[id]);
  }

  @override
  Future<Group> createGroup(Group group) async {
    final newGroup = group.copyWith(id: _uuid.v4());
    _groups[newGroup.id] = newGroup;
    return _simulateDelay(newGroup);
  }

  @override
  Future<Group> updateGroup(Group group) async {
    if (!_groups.containsKey(group.id)) {
      throw Exception('Group not found');
    }
    _groups[group.id] = group;
    return _simulateDelay(group);
  }

  @override
  Future<void> deleteGroup(String id) async {
    _groups.remove(id);
    return _simulateDelay(null);
  }

  // --- Player CRUD ---
  @override
  Future<List<Player>> getPlayers({String? searchKeyword}) async {
    return _simulateDelay(
      _players.values.where((p) {
        if (searchKeyword != null && searchKeyword.isNotEmpty) {
          final query = searchKeyword.toLowerCase();
          return p.name.toLowerCase().contains(query) ||
              p.firstName.toLowerCase().contains(query) ||
              p.lastName.toLowerCase().contains(query);
        }
        return true;
      }).toList(),
    );
  }

  @override
  Future<Player?> getPlayerById(String id) async {
    return _simulateDelay(_players[id]);
  }

  @override
  Future<Player> createPlayer(Player player) async {
    final newPlayer = player.copyWith(id: _uuid.v4());
    _players[newPlayer.id] = newPlayer;
    return _simulateDelay(newPlayer);
  }

  @override
  Future<Player> updatePlayer(Player player) async {
    if (!_players.containsKey(player.id)) {
      throw Exception('Player not found');
    }
    _players[player.id] = player;
    return _simulateDelay(player);
  }

  // --- ScoreRecord CRUD ---
  @override
  Future<List<ScoreRecord>> getScoreRecords({
    String? playerId,
    String? roundingId,
    String? qualityFilter,
  }) async {
    return _simulateDelay(
      _scoreRecords.values.where((s) {
        bool matchesPlayer = playerId == null || s.playerId == playerId;
        bool matchesRounding = roundingId == null || s.roundingId == roundingId;
        bool matchesQuality =
            qualityFilter == null || s.quality.apiValue == qualityFilter;
        return matchesPlayer && matchesRounding && matchesQuality;
      }).toList(),
    );
  }

  @override
  Future<ScoreRecord?> getScoreRecordById(String id) async {
    return _simulateDelay(_scoreRecords[id]);
  }

  @override
  Future<ScoreRecord> createScoreRecord(ScoreRecord scoreRecord) async {
    final newScore = scoreRecord.copyWith(id: _uuid.v4());
    _scoreRecords[newScore.id] = newScore;
    return _simulateDelay(newScore);
  }

  @override
  Future<ScoreRecord> updateScoreRecord(ScoreRecord scoreRecord) async {
    if (!_scoreRecords.containsKey(scoreRecord.id)) {
      throw Exception('ScoreRecord not found');
    }
    _scoreRecords[scoreRecord.id] = scoreRecord;
    return _simulateDelay(scoreRecord);
  }

  // --- ChatMessage CRUD ---
  @override
  Future<List<ChatMessage>> getChatMessages(String groupId) async {
    return _simulateDelay(_chatMessages[groupId] ?? []);
  }

  @override
  Future<ChatMessage> sendChatMessage(ChatMessage message) async {
    final newMessage = message.copyWith(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
    );
    _chatMessages.putIfAbsent(message.groupId, () => []).add(newMessage);
    _chatMessages[message.groupId]!.sort(
      (a, b) => a.timestamp.compareTo(b.timestamp),
    );
    return _simulateDelay(newMessage);
  }

  // --- GroupMember CRUD ---
  @override
  Future<List<GroupMember>> getGroupMembers(
    String groupId, {
    String? statusFilter,
  }) async {
    return _simulateDelay(
      _groupMembers.values.where((gm) {
        bool matchesGroup = gm.groupId == groupId;
        bool matchesStatus =
            statusFilter == null || gm.status.apiValue == statusFilter;
        return matchesGroup && matchesStatus;
      }).toList(),
    );
  }

  @override
  Future<GroupMember> addGroupMember(GroupMember member) async {
    final newMember = member.copyWith(id: _uuid.v4(), joinedAt: DateTime.now());
    _groupMembers[newMember.id] = newMember;
    return _simulateDelay(newMember);
  }

  @override
  Future<GroupMember> updateGroupMember(GroupMember member) async {
    if (!_groupMembers.containsKey(member.id)) {
      throw Exception('GroupMember not found');
    }
    _groupMembers[member.id] = member;
    return _simulateDelay(member);
  }

  @override
  Future<void> removeGroupMember(String memberId) async {
    _groupMembers.remove(memberId);
    return _simulateDelay(null);
  }

  // --- Invitation CRUD ---
  @override
  Future<List<Invitation>> getInvitations({
    String? groupId,
    String? recipientId,
    String? statusFilter,
  }) async {
    return _simulateDelay(
      _invitations.values.where((inv) {
        bool matchesGroup = groupId == null || inv.groupId == groupId;
        bool matchesRecipient =
            recipientId == null || inv.recipientId == recipientId;
        bool matchesStatus =
            statusFilter == null || inv.status.apiValue == statusFilter;
        return matchesGroup && matchesRecipient && matchesStatus;
      }).toList(),
    );
  }

  @override
  Future<Invitation> createInvitation(Invitation invitation) async {
    final newInvitation = invitation.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    _invitations[newInvitation.id] = newInvitation;
    return _simulateDelay(newInvitation);
  }

  @override
  Future<Invitation> updateInvitation(Invitation invitation) async {
    if (!_invitations.containsKey(invitation.id)) {
      throw Exception('Invitation not found');
    }
    _invitations[invitation.id] = invitation;
    return _simulateDelay(invitation);
  }

  @override
  Future<void> deleteInvitation(String id) async {
    _invitations.remove(id);
    return _simulateDelay(null);
  }
}
