import '../../data/models/chat_message.dart';

/// 채팅 데이터 접근 인터페이스
abstract class IChatRepository {
  /// 그룹의 메시지 목록 조회
  Future<List<ChatMessage>> getMessages(
    String groupId, {
    int? limit,
    String? beforeMessageId,
  });

  /// 메시지 생성
  Future<ChatMessage> sendMessage(ChatMessage message);

  /// 메시지 수정
  Future<ChatMessage> updateMessage(ChatMessage message);

  /// 메시지 삭제
  Future<void> deleteMessage(String messageId);

  /// 메시지 반응 추가
  Future<ChatMessage> addReaction(
    String messageId,
    String userId,
    String reactionType,
  );

  /// 메시지 반응 제거
  Future<ChatMessage> removeReaction(
    String messageId,
    String userId,
    String reactionType,
  );

  /// 메시지 읽음 처리
  Future<void> markAsRead(String messageId, String userId);

  /// 그룹의 읽지 않은 메시지 수 조회
  Future<int> getUnreadMessageCount(String groupId, String userId);
}
