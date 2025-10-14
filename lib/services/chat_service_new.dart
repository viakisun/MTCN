import '../data/models/chat_message.dart';
import '../data/models/player.dart';
import '../core/enums/chat_enums.dart';

/// 새로운 아키텍처에 맞는 채팅 서비스
class ChatServiceNew {
  ChatServiceNew._();
  static final ChatServiceNew instance = ChatServiceNew._();

  // Mock 메시지 저장소 (메모리 기반)
  final Map<String, List<ChatMessage>> _messagesByGroup = {};

  /// 메시지 전송
  Future<ChatMessage> sendMessage({
    required String groupId,
    required String content,
    required Player sender,
    MessageType type = MessageType.text,
    String? replyToId,
  }) async {
    final message = ChatMessage(
      id: _generateId(),
      groupId: groupId,
      senderId: sender.id,
      senderName: sender.name,
      senderAvatarUrl: sender.avatar,
      content: content,
      timestamp: DateTime.now(),
      type: type,
      replyToId: replyToId,
    );

    _messagesByGroup.putIfAbsent(groupId, () => []).add(message);

    return message;
  }

  /// 메시지 목록 조회
  Future<List<ChatMessage>> getMessages(String groupId) async {
    if (_messagesByGroup.containsKey(groupId)) {
      return List.from(_messagesByGroup[groupId]!);
    }

    return [];
  }

  /// 라이브 라운딩 채팅 초기화
  Future<void> initializeLiveRoundingChat(
    String roundingId,
    List<Player> players,
  ) async {
    final groupId = 'rounding_$roundingId';

    // 이미 초기화되었으면 스킵
    if (_messagesByGroup.containsKey(groupId)) return;

    final now = DateTime.now();
    final messages = [
      ChatMessage(
        id: 'msg_1',
        groupId: groupId,
        senderId: players[0].id,
        senderName: players[0].name,
        senderAvatarUrl: players[0].avatar,
        content: '안녕하세요! 오늘 라운딩 화이팅해요! 🏌️‍♂️',
        timestamp: now.subtract(const Duration(minutes: 60)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg_2',
        groupId: groupId,
        senderId: players[1].id,
        senderName: players[1].name,
        senderAvatarUrl: players[1].avatar,
        content: '네! 좋은 날씨네요 ☀️',
        timestamp: now.subtract(const Duration(minutes: 58)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: 'msg_3',
        groupId: groupId,
        senderId: players[0].id,
        senderName: players[0].name,
        senderAvatarUrl: players[0].avatar,
        content: '1홀 Par 4 시작합니다!',
        timestamp: now.subtract(const Duration(minutes: 45)),
        type: MessageType.text,
      ),
    ];

    _messagesByGroup[groupId] = messages;
  }

  /// 그룹 채팅 초기화
  Future<void> initializeGroupChat(String groupId) async {
    // 이미 초기화되었으면 스킵
    if (_messagesByGroup.containsKey(groupId)) return;

    final now = DateTime.now();
    final messages = [
      ChatMessage(
        id: 'group_msg_1',
        groupId: groupId,
        senderId: 'system',
        senderName: '시스템',
        senderAvatarUrl: '',
        content: '그룹 채팅이 시작되었습니다.',
        timestamp: now.subtract(const Duration(days: 1)),
        type: MessageType.system,
      ),
    ];

    _messagesByGroup[groupId] = messages;
  }

  /// ID 생성
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 그룹별 메시지 수 조회
  int getMessageCount(String groupId) {
    return _messagesByGroup[groupId]?.length ?? 0;
  }

  /// 최근 메시지 조회
  ChatMessage? getLastMessage(String groupId) {
    final messages = _messagesByGroup[groupId];
    if (messages == null || messages.isEmpty) return null;
    return messages.last;
  }
}
