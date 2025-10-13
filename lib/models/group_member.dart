import 'player.dart';

/// 멤버 권한
enum MemberRole {
  admin, // 그룹 관리자
  moderator, // 운영자
  member, // 일반 멤버
}

/// 멤버 상태
enum MemberStatus {
  active, // 활성
  pending, // 승인 대기
  rejected, // 거절됨
  left, // 탈퇴
  banned, // 차단
}

/// 그룹 멤버
class GroupMember {
  final String id;
  final Player player;
  final MemberRole role;
  final MemberStatus status;
  final DateTime joinedAt;
  final DateTime? approvedAt;
  final String? approvedBy; // 승인한 사람 ID
  final String? rejectedBy; // 거절한 사람 ID
  final String? rejectionReason;

  const GroupMember({
    required this.id,
    required this.player,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectedBy,
    this.rejectionReason,
  });

  GroupMember copyWith({
    String? id,
    Player? player,
    MemberRole? role,
    MemberStatus? status,
    DateTime? joinedAt,
    DateTime? approvedAt,
    String? approvedBy,
    String? rejectedBy,
    String? rejectionReason,
  }) {
    return GroupMember(
      id: id ?? this.id,
      player: player ?? this.player,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  String get roleString {
    switch (role) {
      case MemberRole.admin:
        return 'admin';
      case MemberRole.moderator:
        return 'moderator';
      case MemberRole.member:
        return 'member';
    }
  }

  String get statusString {
    switch (status) {
      case MemberStatus.active:
        return 'active';
      case MemberStatus.pending:
        return 'pending';
      case MemberStatus.rejected:
        return 'rejected';
      case MemberStatus.left:
        return 'left';
      case MemberStatus.banned:
        return 'banned';
    }
  }

  String get roleDisplayName {
    switch (role) {
      case MemberRole.admin:
        return '관리자';
      case MemberRole.moderator:
        return '운영자';
      case MemberRole.member:
        return '멤버';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case MemberStatus.active:
        return '활성';
      case MemberStatus.pending:
        return '승인 대기';
      case MemberStatus.rejected:
        return '거절됨';
      case MemberStatus.left:
        return '탈퇴';
      case MemberStatus.banned:
        return '차단';
    }
  }

  bool get isAdmin => role == MemberRole.admin;
  bool get isModerator => role == MemberRole.moderator;
  bool get isActive => status == MemberStatus.active;
  bool get isPending => status == MemberStatus.pending;

  static MemberRole roleFromString(String role) {
    switch (role) {
      case 'admin':
        return MemberRole.admin;
      case 'moderator':
        return MemberRole.moderator;
      case 'member':
        return MemberRole.member;
      default:
        return MemberRole.member;
    }
  }

  static MemberStatus statusFromString(String status) {
    switch (status) {
      case 'active':
        return MemberStatus.active;
      case 'pending':
        return MemberStatus.pending;
      case 'rejected':
        return MemberStatus.rejected;
      case 'left':
        return MemberStatus.left;
      case 'banned':
        return MemberStatus.banned;
      default:
        return MemberStatus.active;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player': player.toJson(),
      'role': roleString,
      'status': statusString,
      'joinedAt': joinedAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'approvedBy': approvedBy,
      'rejectedBy': rejectedBy,
      'rejectionReason': rejectionReason,
    };
  }

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'] as String,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      role: roleFromString(json['role'] as String),
      status: statusFromString(json['status'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'] as String)
          : null,
      approvedBy: json['approvedBy'] as String?,
      rejectedBy: json['rejectedBy'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }
}
