import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/player.dart';
import 'storage_service.dart';

/// 채팅 서비스
///
/// 메시지 전송, 반응, 답글, 파일 공유 등을 처리합니다.
/// 실제 구현 시 Firebase Firestore 또는 Supabase Realtime을 사용하세요.
class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  final _storageService = StorageService.instance;

  // Mock 메시지 저장소
  final Map<String, List<ChatMessage>> _messagesByGroup = {};

  /// 메시지 전송
  ///
  /// TODO: Firebase Firestore 또는 Supabase에 메시지 저장
  Future<ChatMessage?> sendMessage({
    required String groupId,
    required Player sender,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    List<MessageAttachment>? attachments,
  }) async {
    try {
      debugPrint('=== Send Message ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Sender: ${sender.name}');
      debugPrint('Content: $content');
      debugPrint('Type: ${type.name}');
      if (replyToId != null) debugPrint('Reply To: $replyToId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 500));

      // 메시지 생성
      final message = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: sender,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        replyToId: replyToId,
        attachments: attachments ?? [],
      );

      // Mock 저장소에 추가
      if (!_messagesByGroup.containsKey(groupId)) {
        _messagesByGroup[groupId] = [];
      }
      _messagesByGroup[groupId]!.add(message);

      debugPrint('Message sent: ${message.id}');
      return message;
    } catch (e) {
      debugPrint('Send Message Error: $e');
      return null;
    }
  }

  /// 이미지 메시지 전송
  Future<ChatMessage?> sendImageMessage({
    required String groupId,
    required Player sender,
    required File imageFile,
    String? caption,
    String? replyToId,
  }) async {
    try {
      debugPrint('=== Send Image Message ===');

      // 1. 이미지 업로드
      final uploadResult = await _storageService.uploadImage(
        file: imageFile,
        folder: 'chat/$groupId',
        userId: sender.id,
      );

      if (!uploadResult.success) {
        debugPrint('Image upload failed: ${uploadResult.error}');
        return null;
      }

      // 2. 첨부파일 생성
      final attachment = MessageAttachment(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        url: uploadResult.url!,
        fileName: uploadResult.fileName!,
        fileType: 'image',
        fileSize: uploadResult.fileSize,
      );

      // 3. 메시지 전송
      return await sendMessage(
        groupId: groupId,
        sender: sender,
        content: caption ?? '사진',
        type: MessageType.image,
        replyToId: replyToId,
        attachments: [attachment],
      );
    } catch (e) {
      debugPrint('Send Image Message Error: $e');
      return null;
    }
  }

  /// 파일 메시지 전송
  Future<ChatMessage?> sendFileMessage({
    required String groupId,
    required Player sender,
    required File file,
    String? message,
    String? replyToId,
  }) async {
    try {
      debugPrint('=== Send File Message ===');

      // 1. 파일 업로드
      final uploadResult = await _storageService.uploadFile(
        file: file,
        folder: 'chat/$groupId',
        userId: sender.id,
      );

      if (!uploadResult.success) {
        debugPrint('File upload failed: ${uploadResult.error}');
        return null;
      }

      // 2. 첨부파일 생성
      final fileName = uploadResult.fileName!;
      final attachment = MessageAttachment(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        url: uploadResult.url!,
        fileName: fileName,
        fileType: _storageService.getFileType(fileName),
        fileSize: uploadResult.fileSize,
      );

      // 3. 메시지 전송
      return await sendMessage(
        groupId: groupId,
        sender: sender,
        content: message ?? fileName,
        type: MessageType.file,
        replyToId: replyToId,
        attachments: [attachment],
      );
    } catch (e) {
      debugPrint('Send File Message Error: $e');
      return null;
    }
  }

  /// 메시지에 반응 추가
  Future<bool> addReaction({
    required String groupId,
    required String messageId,
    required String userId,
    required String emoji,
  }) async {
    try {
      debugPrint('=== Add Reaction ===');
      debugPrint('Message ID: $messageId');
      debugPrint('User ID: $userId');
      debugPrint('Emoji: $emoji');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock 저장소에서 메시지 찾기
      final messages = _messagesByGroup[groupId];
      if (messages == null) return false;

      final messageIndex = messages.indexWhere((m) => m.id == messageId);
      if (messageIndex == -1) return false;

      final message = messages[messageIndex];

      // 기존 반응 찾기
      final reactionIndex = message.reactions.indexWhere(
        (r) => r.emoji == emoji,
      );

      List<MessageReaction> updatedReactions;

      if (reactionIndex != -1) {
        // 이미 해당 이모지 반응이 있음
        final reaction = message.reactions[reactionIndex];

        if (reaction.userIds.contains(userId)) {
          // 사용자가 이미 반응함 -> 제거
          final updatedUserIds = List<String>.from(reaction.userIds)
            ..remove(userId);

          if (updatedUserIds.isEmpty) {
            // 반응한 사용자가 없으면 반응 자체를 제거
            updatedReactions = List.from(message.reactions)
              ..removeAt(reactionIndex);
          } else {
            // 사용자 목록 업데이트
            updatedReactions = List.from(message.reactions);
            updatedReactions[reactionIndex] = reaction.copyWith(
              userIds: updatedUserIds,
            );
          }
        } else {
          // 사용자 추가
          final updatedUserIds = List<String>.from(reaction.userIds)
            ..add(userId);
          updatedReactions = List.from(message.reactions);
          updatedReactions[reactionIndex] = reaction.copyWith(
            userIds: updatedUserIds,
          );
        }
      } else {
        // 새 반응 추가
        updatedReactions = List.from(message.reactions)
          ..add(MessageReaction(emoji: emoji, userIds: [userId]));
      }

      // 메시지 업데이트
      messages[messageIndex] = message.copyWith(reactions: updatedReactions);

      debugPrint('Reaction updated successfully');
      return true;
    } catch (e) {
      debugPrint('Add Reaction Error: $e');
      return false;
    }
  }

  /// 메시지에서 반응 제거
  Future<bool> removeReaction({
    required String groupId,
    required String messageId,
    required String userId,
    required String emoji,
  }) async {
    try {
      debugPrint('=== Remove Reaction ===');
      debugPrint('Message ID: $messageId');
      debugPrint('User ID: $userId');
      debugPrint('Emoji: $emoji');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock 저장소에서 메시지 찾기
      final messages = _messagesByGroup[groupId];
      if (messages == null) return false;

      final messageIndex = messages.indexWhere((m) => m.id == messageId);
      if (messageIndex == -1) return false;

      final message = messages[messageIndex];

      // 기존 반응 찾기
      final reactionIndex = message.reactions.indexWhere(
        (r) => r.emoji == emoji,
      );

      if (reactionIndex == -1) return false;

      final reaction = message.reactions[reactionIndex];
      final updatedUserIds = List<String>.from(reaction.userIds)
        ..remove(userId);

      List<MessageReaction> updatedReactions;

      if (updatedUserIds.isEmpty) {
        // 반응한 사용자가 없으면 반응 자체를 제거
        updatedReactions = List.from(message.reactions)
          ..removeAt(reactionIndex);
      } else {
        // 사용자 목록 업데이트
        updatedReactions = List.from(message.reactions);
        updatedReactions[reactionIndex] = reaction.copyWith(
          userIds: updatedUserIds,
        );
      }

      // 메시지 업데이트
      messages[messageIndex] = message.copyWith(reactions: updatedReactions);

      debugPrint('Reaction removed successfully');
      return true;
    } catch (e) {
      debugPrint('Remove Reaction Error: $e');
      return false;
    }
  }

  /// 그룹의 메시지 조회
  Future<List<ChatMessage>> getMessages({
    required String groupId,
    int? limit = 50,
  }) async {
    try {
      debugPrint('=== Get Messages ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Limit: $limit');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 500));

      final messages = _messagesByGroup[groupId] ?? [];

      // 최신 메시지부터 반환
      final sortedMessages = List<ChatMessage>.from(messages)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (limit != null && sortedMessages.length > limit) {
        return sortedMessages.sublist(0, limit);
      }

      return sortedMessages;
    } catch (e) {
      debugPrint('Get Messages Error: $e');
      return [];
    }
  }

  /// 메시지 삭제
  Future<bool> deleteMessage({
    required String groupId,
    required String messageId,
  }) async {
    try {
      debugPrint('=== Delete Message ===');
      debugPrint('Message ID: $messageId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final messages = _messagesByGroup[groupId];
      if (messages == null) return false;

      final initialLength = messages.length;
      messages.removeWhere((m) => m.id == messageId);
      final removed = initialLength - messages.length;

      debugPrint('Message deleted: $removed');
      return removed > 0;
    } catch (e) {
      debugPrint('Delete Message Error: $e');
      return false;
    }
  }

  /// 메시지 읽음 처리
  Future<bool> markAsRead({
    required String groupId,
    required String messageId,
  }) async {
    try {
      debugPrint('=== Mark As Read ===');
      debugPrint('Message ID: $messageId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 200));

      final messages = _messagesByGroup[groupId];
      if (messages == null) return false;

      final messageIndex = messages.indexWhere((m) => m.id == messageId);
      if (messageIndex == -1) return false;

      messages[messageIndex] = messages[messageIndex].copyWith(isRead: true);

      debugPrint('Message marked as read');
      return true;
    } catch (e) {
      debugPrint('Mark As Read Error: $e');
      return false;
    }
  }

  /// 그룹 채팅 초기화 (Mock 데이터)
  ///
  /// 그룹 ID에 대한 채팅 메시지를 초기화합니다.
  void initializeGroupChat(
    String groupId,
    String groupName,
    List<Player> players,
  ) {
    if (_messagesByGroup.containsKey(groupId)) {
      // 이미 초기화된 경우 스킵
      return;
    }

    final now = DateTime.now();
    final messages = <ChatMessage>[];

    // 그룹 채팅 메시지들
    messages.addAll([
      ChatMessage(
        id: 'msg_g1',
        sender: players[1], // 이영희
        content: '다음 주 라운딩 날짜 확정되었나요?',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g2',
        sender: players[2], // 박철수
        content: '아직 확정은 안됐는데 토요일 아침으로 조율중입니다!',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 4, minutes: 55)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g3',
        sender: players[0], // 김민수 (나)
        content: '저는 토요일 괜찮아요~',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 4, minutes: 50)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g4',
        sender: players[3], // 정수진
        content: '저도 좋습니다! 😊',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 4, minutes: 45)),
        isRead: true,
        reactions: [
          const MessageReaction(emoji: '👍', userIds: ['1', '2']),
        ],
      ),
      ChatMessage(
        id: 'msg_g5',
        sender: players[1], // 이영희
        content: '골프장은 어디로 할까요? 추천 부탁드립니다~',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g6',
        sender: players[4], // 최동현
        content: '레이크우드 컨트리클럽 어때요? 날씨도 좋고 코스 상태도 좋더라고요',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g7',
        sender: players[2], // 박철수
        content: '좋아요! 레이크우드로 가죠 👍',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
        isRead: true,
        reactions: [
          const MessageReaction(emoji: '👍', userIds: ['1', '2', '3']),
          const MessageReaction(emoji: '⛳', userIds: ['1']),
        ],
      ),
      ChatMessage(
        id: 'msg_g8',
        sender: players[0], // 김민수 (나)
        content: '그럼 토요일 오전 8시 레이크우드로 확정할까요?',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g9',
        sender: players[1], // 이영희
        content: '네! 확정이요~ 🎉',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 55)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g10',
        sender: players[4], // 최동현
        content: '다들 연습 많이 하고 오세요! 저번에 너무 못쳤어요 ㅠㅠ',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_g11',
        sender: players[3], // 정수진
        content: '저도 연습해야되는데... 시간이 없네요 😅',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 25)),
        isRead: false,
      ),
      ChatMessage(
        id: 'msg_g12',
        sender: players[2], // 박철수
        content: '괜찮아요~ 즐겁게 치는게 중요하죠! 화이팅! 💪',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 20)),
        isRead: false,
      ),
    ]);

    _messagesByGroup[groupId] = messages;
    debugPrint(
      'Group chat initialized for "$groupName" with ${messages.length} messages',
    );
  }

  /// 라이브 라운딩 채팅 초기화 (Mock 데이터)
  ///
  /// 라운딩 ID '2'에 대한 실시간 채팅 메시지를 초기화합니다.
  void initializeLiveRoundingChat(String roundingId, List<Player> players) {
    if (_messagesByGroup.containsKey(roundingId)) {
      // 이미 초기화된 경우 스킵
      return;
    }

    final now = DateTime.now();
    final messages = <ChatMessage>[];

    // 14홀 진행 중인 라운딩에 대한 실시간 채팅 메시지들
    messages.addAll([
      ChatMessage(
        id: 'msg_1',
        sender: players[1], // 이영희
        content: '오늘 날씨 정말 좋네요! 🌞',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 45)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_2',
        sender: players[0], // 김민수 (나)
        content: '그러게요~ 라운딩하기 딱 좋은 날씨에요',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 43)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_3',
        sender: players[3], // 최동현
        content: '3홀에서 버디 나왔어요! 😊',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 35)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_4',
        sender: players[2], // 박철수
        content: '우와 축하해요! 👏',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 34)),
        isRead: true,
        reactions: [
          const MessageReaction(emoji: '👏', userIds: ['1', '2']),
        ],
      ),
      ChatMessage(
        id: 'msg_5',
        sender: players[1], // 이영희
        content: '7홀 Par 3 정말 어려웠어요 ㅠㅠ',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 25)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_6',
        sender: players[0], // 김민수 (나)
        content: '저도요... 바람이 너무 강했어요',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 24)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_7',
        sender: players[3], // 최동현
        content: '다들 화이팅하세요! 💪',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 18)),
        isRead: true,
        reactions: [
          const MessageReaction(emoji: '💪', userIds: ['1', '2', '3']),
          const MessageReaction(emoji: '🔥', userIds: ['1']),
        ],
      ),
      ChatMessage(
        id: 'msg_8',
        sender: players[2], // 박철수
        content: '점심 뭐 먹을까요?',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_9',
        sender: players[1], // 이영희
        content: '여기 돈까스가 맛있다던데요~',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 14)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_10',
        sender: players[0], // 김민수 (나)
        content: '좋아요! 돈까스 먹죠 👍',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 13)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_11',
        sender: players[3], // 최동현
        content: '13홀 티샷 정말 잘 맞았어요!',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_12',
        sender: players[2], // 박철수
        content: '아직 4홀 남았네요~ 집중합시다!',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
      ChatMessage(
        id: 'msg_13',
        sender: players[1], // 이영희
        content: '네! 80타 안에 들어가고 싶어요 ㅎㅎ',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(minutes: 1)),
        isRead: false,
      ),
    ]);

    _messagesByGroup[roundingId] = messages;
    debugPrint(
      'Live rounding chat initialized with ${messages.length} messages',
    );
  }
}
