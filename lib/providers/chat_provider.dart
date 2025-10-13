import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../models/player.dart';
import '../services/chat_service.dart';

/// ChatService Provider
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService.instance;
});

/// 채팅 상태
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final ChatMessage? replyingTo; // 답글 대상 메시지

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.replyingTo,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    ChatMessage? replyingTo,
    bool clearReplyingTo = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      replyingTo: clearReplyingTo ? null : (replyingTo ?? this.replyingTo),
    );
  }
}

/// ChatNotifier
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  final String groupId;

  ChatNotifier(this._chatService, this.groupId) : super(const ChatState()) {
    loadMessages();
  }

  /// 메시지 로드
  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final messages = await _chatService.getMessages(groupId: groupId);
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 텍스트 메시지 전송
  Future<bool> sendMessage({
    required Player sender,
    required String content,
  }) async {
    try {
      final message = await _chatService.sendMessage(
        groupId: groupId,
        sender: sender,
        content: content,
        replyToId: state.replyingTo?.id,
      );

      if (message != null) {
        // 메시지 목록 업데이트
        final updatedMessages = [message, ...state.messages];
        state = state.copyWith(
          messages: updatedMessages,
          clearReplyingTo: true,
        );
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 이미지 메시지 전송
  Future<bool> sendImageMessage({
    required Player sender,
    required File imageFile,
    String? caption,
  }) async {
    try {
      final message = await _chatService.sendImageMessage(
        groupId: groupId,
        sender: sender,
        imageFile: imageFile,
        caption: caption,
        replyToId: state.replyingTo?.id,
      );

      if (message != null) {
        // 메시지 목록 업데이트
        final updatedMessages = [message, ...state.messages];
        state = state.copyWith(
          messages: updatedMessages,
          clearReplyingTo: true,
        );
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 파일 메시지 전송
  Future<bool> sendFileMessage({
    required Player sender,
    required File file,
    String? message,
  }) async {
    try {
      final chatMessage = await _chatService.sendFileMessage(
        groupId: groupId,
        sender: sender,
        file: file,
        message: message,
        replyToId: state.replyingTo?.id,
      );

      if (chatMessage != null) {
        // 메시지 목록 업데이트
        final updatedMessages = [chatMessage, ...state.messages];
        state = state.copyWith(
          messages: updatedMessages,
          clearReplyingTo: true,
        );
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 메시지에 반응 추가/제거 (토글)
  Future<bool> toggleReaction({
    required String messageId,
    required String userId,
    required String emoji,
  }) async {
    try {
      final success = await _chatService.addReaction(
        groupId: groupId,
        messageId: messageId,
        userId: userId,
        emoji: emoji,
      );

      if (success) {
        // 메시지 목록 다시 로드
        await loadMessages();
      }

      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 답글 대상 메시지 설정
  void setReplyingTo(ChatMessage? message) {
    state = state.copyWith(
      replyingTo: message,
      clearReplyingTo: message == null,
    );
  }

  /// 답글 취소
  void cancelReply() {
    state = state.copyWith(clearReplyingTo: true);
  }

  /// 메시지 삭제
  Future<bool> deleteMessage(String messageId) async {
    try {
      final success = await _chatService.deleteMessage(
        groupId: groupId,
        messageId: messageId,
      );

      if (success) {
        // 메시지 목록에서 제거
        final updatedMessages = state.messages
            .where((m) => m.id != messageId)
            .toList();
        state = state.copyWith(messages: updatedMessages);
      }

      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 메시지 읽음 처리
  Future<bool> markAsRead(String messageId) async {
    try {
      final success = await _chatService.markAsRead(
        groupId: groupId,
        messageId: messageId,
      );

      if (success) {
        // 메시지 목록 업데이트
        final updatedMessages = state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(isRead: true);
          }
          return m;
        }).toList();

        state = state.copyWith(messages: updatedMessages);
      }

      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Chat State Provider (그룹별)
final chatProvider =
    StateNotifierProvider.family<ChatNotifier, ChatState, String>((
      ref,
      groupId,
    ) {
      final chatService = ref.watch(chatServiceProvider);
      return ChatNotifier(chatService, groupId);
    });
