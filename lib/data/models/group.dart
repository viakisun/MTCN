import '../../core/enums/group_enums.dart';
import 'group_member.dart';

/// 그룹 모델 (MockDatabaseService 호환)
class Group {
  final String id;
  final String name;
  final String description;
  final String? avatarUrl;
  final String? image;
  final bool isPublic;
  final bool isPremium;
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
    this.image,
    this.isPremium = false,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    String? image,
    bool? isPublic,
    bool? isPremium,
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
      image: image ?? this.image,
      isPublic: isPublic ?? this.isPublic,
      isPremium: isPremium ?? this.isPremium,
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
      'image': image,
      'isPublic': isPublic,
      'isPremium': isPremium,
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
      image: json['image'] as String?,
      isPublic: json['isPublic'] as bool,
      isPremium: json['isPremium'] as bool? ?? false,
      status: GroupStatus.fromString(json['status'] as String),
      members: (json['members'] as List)
          .map((m) => GroupMember.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      roundCount: json['roundCount'] as int? ?? 0,
    );
  }

  // UI 관련 getter들
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays <= 7;
  }

  GroupSizeTier get sizeTier {
    final size = members.length;
    if (size >= 100) return GroupSizeTier.mega;
    if (size >= 50) return GroupSizeTier.large;
    if (size >= 20) return GroupSizeTier.medium;
    if (size >= 10) return GroupSizeTier.small;
    return GroupSizeTier.mini;
  }

  String get sizeLabel {
    switch (sizeTier) {
      case GroupSizeTier.mega:
        return '대규모 모임';
      case GroupSizeTier.large:
        return '큰 모임';
      case GroupSizeTier.medium:
        return '중규모 모임';
      case GroupSizeTier.small:
        return '소규모 모임';
      case GroupSizeTier.mini:
        return '친목 모임';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Group &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.avatarUrl == avatarUrl &&
        other.image == image &&
        other.isPublic == isPublic &&
        other.isPremium == isPremium &&
        other.status == status &&
        other.members == members &&
        other.createdAt == createdAt &&
        other.roundCount == roundCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      avatarUrl,
      image,
      isPublic,
      isPremium,
      status,
      members,
      createdAt,
      roundCount,
    );
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, description: $description, avatarUrl: $avatarUrl, image: $image, isPublic: $isPublic, isPremium: $isPremium, status: $status, members: $members, createdAt: $createdAt, roundCount: $roundCount)';
  }
}
