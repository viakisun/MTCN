import '../../core/enums/group_enums.dart';

/// 초대 모델 (리팩토링된 버전)
class Invitation {
  final String id;
  final String groupId;
  final String inviterId;
  final String inviteeId;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? message;
  final Map<String, dynamic>? metadata;

  const Invitation({
    required this.id,
    required this.groupId,
    required this.inviterId,
    required this.inviteeId,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.message,
    this.metadata,
  });

  // recipientId는 inviteeId와 같음
  String get recipientId => inviteeId;

  Invitation copyWith({
    String? id,
    String? groupId,
    String? inviterId,
    String? inviteeId,
    InvitationStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return Invitation(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      inviterId: inviterId ?? this.inviterId,
      inviteeId: inviteeId ?? this.inviteeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      message: message ?? this.message,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'inviterId': inviterId,
      'inviteeId': inviteeId,
      'status': status.apiValue,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'message': message,
      'metadata': metadata,
    };
  }

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      inviterId: json['inviterId'] as String,
      inviteeId: json['inviteeId'] as String,
      status: InvitationStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      message: json['message'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// 초대가 만료되었는지 확인
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 초대가 유효한지 확인 (대기중이고 만료되지 않음)
  bool get isValid => status == InvitationStatus.pending && !isExpired;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Invitation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Invitation(id: $id, groupId: $groupId, inviteeId: $inviteeId, status: $status)';
}
