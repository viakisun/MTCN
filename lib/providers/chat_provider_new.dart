import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/chat_message.dart';
import '../data/models/player.dart';
import '../services/chat_service_new.dart';
import '../core/enums/chat_enums.dart';

/// 새로운 ChatService Provider
final chatServiceNewProvider = Provider<ChatServiceNew>((ref) {
  return ChatServiceNew.instance;
});

/// 채팅 상태 모델
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? currentGroupId;
  final ChatMessage? replyingTo;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentGroupId,
    this.replyingTo,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? currentGroupId,
    ChatMessage? replyingTo,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      currentGroupId: currentGroupId ?? this.currentGroupId,
      replyingTo: replyingTo ?? this.replyingTo,
    );
  }
}

/// 채팅 상태 관리 Provider
final chatStateProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.watch(chatServiceNewProvider));
});

/// 채팅 상태 관리 Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatServiceNew _chatService;

  ChatNotifier(this._chatService) : super(const ChatState());

  /// 메시지 로드
  Future<void> loadMessages(String groupId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final messages = await _chatService.getMessages(groupId);
      state = state.copyWith(
        messages: messages,
        isLoading: false,
        currentGroupId: groupId,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 메시지 전송
  Future<void> sendMessage({
    required String groupId,
    required String content,
    required Player sender,
    MessageType type = MessageType.text,
    String? replyToId,
  }) async {
    try {
      final message = await _chatService.sendMessage(
        groupId: groupId,
        content: content,
        sender: sender,
        type: type,
        replyToId: replyToId,
      );

      final updatedMessages = [...state.messages, message];
      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 라이브 라운딩 채팅 초기화
  Future<void> initializeLiveRoundingChat(
    String roundingId,
    List<Player> players,
  ) async {
    await _chatService.initializeLiveRoundingChat(roundingId, players);
    await loadMessages('rounding_$roundingId');
  }

  /// 그룹 채팅 초기화
  Future<void> initializeGroupChat(String groupId) async {
    await _chatService.initializeGroupChat(groupId);
    await loadMessages(groupId);
  }

  /// 에러 클리어
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 메시지 새로고침
  Future<void> refreshMessages() async {
    if (state.currentGroupId != null) {
      await loadMessages(state.currentGroupId!);
    }
  }

  /// 이미지 메시지 전송
  Future<void> sendImageMessage({
    required String groupId,
    required String imageUrl,
    required Player sender,
  }) async {
    try {
      final message = await _chatService.sendMessage(
        groupId: groupId,
        content: '[이미지]',
        sender: sender,
        type: MessageType.image,
      );

      final updatedMessages = [...state.messages, message];
      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 파일 메시지 전송
  Future<void> sendFileMessage({
    required String groupId,
    required String fileName,
    required Player sender,
  }) async {
    try {
      final message = await _chatService.sendMessage(
        groupId: groupId,
        content: '[파일] $fileName',
        sender: sender,
        type: MessageType.file,
      );

      final updatedMessages = [...state.messages, message];
      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 반응 토글 (간단한 구현)
  Future<void> toggleReaction({
    required String messageId,
    required String emoji,
    required Player player,
  }) async {
    // 간단한 구현 - 실제로는 메시지에 반응을 추가/제거
    debugPrint('반응 토글: $messageId, $emoji, ${player.name}');
  }

  /// 답장 설정
  void setReplyingTo(ChatMessage message) {
    state = state.copyWith(replyingTo: message);
  }

  /// 답장 취소
  void cancelReply() {
    state = state.copyWith(replyingTo: null);
  }
}
