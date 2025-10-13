import '../../core/enums/group_enums.dart';
import 'player.dart';

/// 그룹 멤버 모델 (MockDatabaseService 호환)
class GroupMember {
  final String id;
  final String groupId;
  final String playerId;
  final MemberRole role;
  final MemberStatus status;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final String? nickname;
  final Map<String, dynamic>? permissions;
  final bool isActive;
  final Player player; // Added player field

  const GroupMember({
    required this.id,
    required this.groupId,
    required this.playerId,
    required this.role,
    required this.status,
    required this.joinedAt,
    required this.player, // Added to constructor
    this.leftAt,
    this.nickname,
    this.permissions,
    this.isActive = true,
  });

  GroupMember copyWith({
    String? id,
    String? groupId,
    String? playerId,
    MemberRole? role,
    MemberStatus? status,
    DateTime? joinedAt,
    DateTime? leftAt,
    String? nickname,
    Map<String, dynamic>? permissions,
    bool? isActive,
    Player? player,
  }) {
    return GroupMember(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      playerId: playerId ?? this.playerId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      nickname: nickname ?? this.nickname,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      player: player ?? this.player,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'playerId': playerId,
      'role': role.apiValue,
      'status': status.apiValue,
      'joinedAt': joinedAt.toIso8601String(),
      'leftAt': leftAt?.toIso8601String(),
      'nickname': nickname,
      'permissions': permissions,
      'isActive': isActive,
      'player': player.toJson(),
    };
  }

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      playerId: json['playerId'] as String,
      role: MemberRole.fromString(json['role'] as String),
      status: MemberStatus.fromString(json['status'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      leftAt: json['leftAt'] != null
          ? DateTime.parse(json['leftAt'] as String)
          : null,
      nickname: json['nickname'] as String?,
      permissions: json['permissions'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupMember &&
        other.id == id &&
        other.groupId == groupId &&
        other.playerId == playerId &&
        other.role == role &&
        other.status == status &&
        other.joinedAt == joinedAt &&
        other.leftAt == leftAt &&
        other.nickname == nickname &&
        other.permissions == permissions &&
        other.isActive == isActive &&
        other.player == player;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      groupId,
      playerId,
      role,
      status,
      joinedAt,
      leftAt,
      nickname,
      permissions,
      isActive,
      player,
    );
  }

  @override
  String toString() {
    return 'GroupMember(id: $id, groupId: $groupId, playerId: $playerId, role: $role, status: $status, joinedAt: $joinedAt, leftAt: $leftAt, nickname: $nickname, permissions: $permissions, isActive: $isActive, player: $player)';
  }
}
