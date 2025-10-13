import '../../domain/repositories/chat_repository.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/mock_database_service.dart';

/// Mock implementation of IChatRepository
class MockChatRepository implements IChatRepository {
  final IDatabaseService _databaseService;

  MockChatRepository(this._databaseService);

  @override
  Future<List<ChatMessage>> getMessages(
    String groupId, {
    int? limit,
    String? beforeMessageId,
  }) async {
    return _databaseService.getChatMessages(groupId);
  }

  @override
  Future<ChatMessage> sendMessage(ChatMessage message) async {
    return _databaseService.sendChatMessage(message);
  }

  @override
  Future<ChatMessage> updateMessage(ChatMessage message) async {
    // MockDatabaseService에는 updateMessage가 없으므로 임시로 message 반환
    return message;
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    // MockDatabaseService에는 deleteMessage가 없으므로 빈 구현
  }

  @override
  Future<ChatMessage> addReaction(
    String messageId,
    String userId,
    String reactionType,
  ) async {
    // MockDatabaseService에는 addReaction이 없으므로 임시로 빈 메시지 반환
    throw UnimplementedError(
      'addReaction not implemented in MockDatabaseService',
    );
  }

  @override
  Future<ChatMessage> removeReaction(
    String messageId,
    String userId,
    String reactionType,
  ) async {
    // MockDatabaseService에는 removeReaction이 없으므로 임시로 빈 메시지 반환
    throw UnimplementedError(
      'removeReaction not implemented in MockDatabaseService',
    );
  }

  @override
  Future<void> markAsRead(String messageId, String userId) async {
    // MockDatabaseService에는 markAsRead가 없으므로 빈 구현
  }

  @override
  Future<int> getUnreadMessageCount(String groupId, String userId) async {
    // MockDatabaseService에는 getUnreadMessageCount가 없으므로 임시로 0 반환
    return 0;
  }
}
