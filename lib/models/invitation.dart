import '../data/models/player.dart';

/// 초대 상태
enum InvitationStatus {
  pending, // 대기 중
  accepted, // 수락됨
  declined, // 거절됨
  expired, // 만료됨
}

/// 그룹 초대
class Invitation {
  final String id;
  final String groupId;
  final String groupName;
  final Player inviter; // 초대한 사람
  final Player invitee; // 초대받은 사람
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? respondedAt;
  final String? message;

  const Invitation({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.inviter,
    required this.invitee,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.respondedAt,
    this.message,
  });

  Invitation copyWith({
    String? id,
    String? groupId,
    String? groupName,
    Player? inviter,
    Player? invitee,
    InvitationStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? respondedAt,
    String? message,
  }) {
    return Invitation(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      inviter: inviter ?? this.inviter,
      invitee: invitee ?? this.invitee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }

  String get statusString {
    switch (status) {
      case InvitationStatus.pending:
        return 'pending';
      case InvitationStatus.accepted:
        return 'accepted';
      case InvitationStatus.declined:
        return 'declined';
      case InvitationStatus.expired:
        return 'expired';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case InvitationStatus.pending:
        return '대기 중';
      case InvitationStatus.accepted:
        return '수락됨';
      case InvitationStatus.declined:
        return '거절됨';
      case InvitationStatus.expired:
        return '만료됨';
    }
  }

  bool get isPending => status == InvitationStatus.pending;
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => isPending && !isExpired;

  static InvitationStatus statusFromString(String status) {
    switch (status) {
      case 'pending':
        return InvitationStatus.pending;
      case 'accepted':
        return InvitationStatus.accepted;
      case 'declined':
        return InvitationStatus.declined;
      case 'expired':
        return InvitationStatus.expired;
      default:
        return InvitationStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'groupName': groupName,
      'inviter': inviter.toJson(),
      'invitee': invitee.toJson(),
      'status': statusString,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'message': message,
    };
  }

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      inviter: Player.fromJson(json['inviter'] as Map<String, dynamic>),
      invitee: Player.fromJson(json['invitee'] as Map<String, dynamic>),
      status: statusFromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
      message: json['message'] as String?,
    );
  }
}
