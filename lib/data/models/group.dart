import '../../core/enums/group_enums.dart';

/// 그룹 모델 (리팩토링된 버전)
class Group {
  final String id;
  final String name;
  final String description;
  final GroupPrivacy privacy;
  final GroupCategory category;
  final int memberCount;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatar;
  final List<String> tags;
  final bool isActive;
  final int? maxMembers;
  final String? location;
  final String? website;

  const Group({
    required this.id,
    required this.name,
    required this.description,
    required this.privacy,
    required this.category,
    required this.memberCount,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    this.tags = const [],
    this.isActive = true,
    this.maxMembers,
    this.location,
    this.website,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    GroupPrivacy? privacy,
    GroupCategory? category,
    int? memberCount,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? avatar,
    List<String>? tags,
    bool? isActive,
    int? maxMembers,
    String? location,
    String? website,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      category: category ?? this.category,
      memberCount: memberCount ?? this.memberCount,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatar: avatar ?? this.avatar,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      maxMembers: maxMembers ?? this.maxMembers,
      location: location ?? this.location,
      website: website ?? this.website,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'privacy': privacy.apiValue,
      'category': category.apiValue,
      'memberCount': memberCount,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'avatar': avatar,
      'tags': tags,
      'isActive': isActive,
      'maxMembers': maxMembers,
      'location': location,
      'website': website,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      privacy: GroupPrivacy.fromString(json['privacy'] as String),
      category: GroupCategory.fromString(json['category'] as String),
      memberCount: json['memberCount'] as int,
      ownerId: json['ownerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      avatar: json['avatar'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isActive: json['isActive'] as bool? ?? true,
      maxMembers: json['maxMembers'] as int?,
      location: json['location'] as String?,
      website: json['website'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Group && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Group(id: $id, name: $name, memberCount: $memberCount)';
}
