import '../../core/enums/group_enums.dart';
import 'group_member.dart';

/// 그룹 모델 (MockDatabaseService 호환)
class Group {
  final String id;
  final String name;
  final String description;
  final String? avatarUrl;
  final bool isPublic;
  final GroupStatus status;
  final List<GroupMember> members;
  final DateTime createdAt;
  final int roundCount; // 추가 필드

  const Group({
    required this.id,
    required this.name,
    required this.description,
    required this.isPublic,
    required this.status,
    required this.members,
    required this.createdAt,
    required this.roundCount,
    this.avatarUrl,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    bool? isPublic,
    GroupStatus? status,
    List<GroupMember>? members,
    DateTime? createdAt,
    int? roundCount,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPublic: isPublic ?? this.isPublic,
      status: status ?? this.status,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      roundCount: roundCount ?? this.roundCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatarUrl': avatarUrl,
      'isPublic': isPublic,
      'status': status.apiValue,
      'members': members.map((member) => member.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'roundCount': roundCount,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isPublic: json['isPublic'] as bool,
      status: GroupStatus.fromString(json['status'] as String),
      members: (json['members'] as List)
          .map((m) => GroupMember.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      roundCount: json['roundCount'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Group &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.avatarUrl == avatarUrl &&
        other.isPublic == isPublic &&
        other.status == status &&
        other.members == members &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      avatarUrl,
      isPublic,
      status,
      members,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, description: $description, avatarUrl: $avatarUrl, isPublic: $isPublic, status: $status, members: $members, createdAt: $createdAt)';
  }
}
