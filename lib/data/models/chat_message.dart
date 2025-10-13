import '../../core/enums/chat_enums.dart';

/// 채팅 메시지 모델 (MockDatabaseService 호환)
class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? replyToId;

  const ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.content,
    required this.timestamp,
    required this.type,
    this.replyToId,
  });

  ChatMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? senderName,
    String? senderAvatarUrl,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      replyToId: replyToId ?? this.replyToId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.apiValue,
      'replyToId': replyToId,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MessageType.fromString(json['type'] as String),
      replyToId: json['replyToId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.groupId == groupId &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.senderAvatarUrl == senderAvatarUrl &&
        other.content == content &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.replyToId == replyToId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      groupId,
      senderId,
      senderName,
      senderAvatarUrl,
      content,
      timestamp,
      type,
      replyToId,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, groupId: $groupId, senderId: $senderId, senderName: $senderName, senderAvatarUrl: $senderAvatarUrl, content: $content, timestamp: $timestamp, type: $type, replyToId: $replyToId)';
  }
}
