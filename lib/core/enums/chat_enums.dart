/// 채팅 관련 열거형들
import 'package:flutter/material.dart';

/// 메시지 타입
enum MessageType {
  text('텍스트', 'text'),
  image('이미지', 'image'),
  file('파일', 'file'),
  system('시스템', 'system'),
  location('위치', 'location'),
  voice('음성', 'voice');

  const MessageType(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static MessageType fromString(String value) {
    switch (value) {
      case '텍스트':
      case 'text':
        return MessageType.text;
      case '이미지':
      case 'image':
        return MessageType.image;
      case '파일':
      case 'file':
        return MessageType.file;
      case '시스템':
      case 'system':
        return MessageType.system;
      case '위치':
      case 'location':
        return MessageType.location;
      case '음성':
      case 'voice':
        return MessageType.voice;
      default:
        return MessageType.text;
    }
  }
}

/// 메시지 상태
enum MessageStatus {
  sending('전송중', 'sending'),
  sent('전송완료', 'sent'),
  delivered('전달완료', 'delivered'),
  read('읽음', 'read'),
  failed('전송실패', 'failed');

  const MessageStatus(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static MessageStatus fromString(String value) {
    switch (value) {
      case '전송중':
      case 'sending':
        return MessageStatus.sending;
      case '전송완료':
      case 'sent':
        return MessageStatus.sent;
      case '전달완료':
      case 'delivered':
        return MessageStatus.delivered;
      case '읽음':
      case 'read':
        return MessageStatus.read;
      case '전송실패':
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sending;
    }
  }
}

/// 채팅방 타입
enum ChatRoomType {
  group('그룹', 'group'),
  direct('개인', 'direct'),
  broadcast('공지', 'broadcast');

  const ChatRoomType(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static ChatRoomType fromString(String value) {
    switch (value) {
      case '그룹':
      case 'group':
        return ChatRoomType.group;
      case '개인':
      case 'direct':
        return ChatRoomType.direct;
      case '공지':
      case 'broadcast':
        return ChatRoomType.broadcast;
      default:
        return ChatRoomType.group;
    }
  }
}

/// 반응 타입
enum ReactionType {
  like('좋아요', '👍'),
  love('사랑해요', '❤️'),
  laugh('웃겨요', '😂'),
  wow('와우', '😮'),
  sad('슬퍼요', '😢'),
  angry('화나요', '😡');

  const ReactionType(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  static ReactionType fromString(String value) {
    switch (value) {
      case '좋아요':
      case 'like':
      case '👍':
        return ReactionType.like;
      case '사랑해요':
      case 'love':
      case '❤️':
        return ReactionType.love;
      case '웃겨요':
      case 'laugh':
      case '😂':
        return ReactionType.laugh;
      case '와우':
      case 'wow':
      case '😮':
        return ReactionType.wow;
      case '슬퍼요':
      case 'sad':
      case '😢':
        return ReactionType.sad;
      case '화나요':
      case 'angry':
      case '😡':
        return ReactionType.angry;
      default:
        return ReactionType.like;
    }
  }
}
