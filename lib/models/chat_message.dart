import '../data/models/player.dart';

enum MessageType { text, image, file, system }

/// 메시지 첨부파일
class MessageAttachment {
  final String id;
  final String url;
  final String fileName;
  final String fileType; // image, video, document, etc.
  final int? fileSize; // bytes

  const MessageAttachment({
    required this.id,
    required this.url,
    required this.fileName,
    required this.fileType,
    this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
    };
  }

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      url: json['url'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int?,
    );
  }
}

/// 메시지 반응 (이모지)
class MessageReaction {
  final String emoji;
  final List<String> userIds; // 반응한 사용자 ID 목록

  const MessageReaction({required this.emoji, required this.userIds});

  MessageReaction copyWith({String? emoji, List<String>? userIds}) {
    return MessageReaction(
      emoji: emoji ?? this.emoji,
      userIds: userIds ?? this.userIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {'emoji': emoji, 'userIds': userIds};
  }

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      emoji: json['emoji'] as String,
      userIds: List<String>.from(json['userIds'] as List),
    );
  }
}

class ChatMessage {
  final String id;
  final Player sender;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  // Phase 2 추가 필드
  final List<MessageReaction> reactions; // 메시지 반응
  final String? replyToId; // 답글 대상 메시지 ID
  final ChatMessage? replyToMessage; // 답글 대상 메시지 (populated)
  final List<MessageAttachment> attachments; // 첨부파일

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.reactions = const [],
    this.replyToId,
    this.replyToMessage,
    this.attachments = const [],
  });

  ChatMessage copyWith({
    String? id,
    Player? sender,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    List<MessageReaction>? reactions,
    String? replyToId,
    ChatMessage? replyToMessage,
    List<MessageAttachment>? attachments,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      reactions: reactions ?? this.reactions,
      replyToId: replyToId ?? this.replyToId,
      replyToMessage: replyToMessage ?? this.replyToMessage,
      attachments: attachments ?? this.attachments,
    );
  }

  String get typeString {
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.file:
        return 'file';
      case MessageType.system:
        return 'system';
    }
  }

  static MessageType typeFromString(String type) {
    switch (type) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'content': content,
      'type': typeString,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'reactions': reactions.map((r) => r.toJson()).toList(),
      'replyToId': replyToId,
      'replyToMessage': replyToMessage?.toJson(),
      'attachments': attachments.map((a) => a.toJson()).toList(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      sender: Player.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
      type: typeFromString(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      reactions:
          (json['reactions'] as List<dynamic>?)
              ?.map((r) => MessageReaction.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      replyToId: json['replyToId'] as String?,
      replyToMessage: json['replyToMessage'] != null
          ? ChatMessage.fromJson(json['replyToMessage'] as Map<String, dynamic>)
          : null,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map(
                (a) => MessageAttachment.fromJson(a as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
