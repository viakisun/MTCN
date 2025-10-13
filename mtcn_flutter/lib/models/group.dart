import 'player.dart';

enum GroupStatus { active, inactive }

enum GroupSizeTier {
  mega, // 100+ members
  large, // 50-99 members
  medium, // 20-49 members
  small, // 10-19 members
  mini, // 0-9 members
}

class Group {
  final String id;
  final String name;
  final String description;
  final GroupStatus status;
  final List<Player> members;
  final DateTime createdAt;
  final String? image;
  final int roundCount;
  final bool isPremium;

  const Group({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.members,
    required this.createdAt,
    this.image,
    this.roundCount = 0,
    this.isPremium = false,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    GroupStatus? status,
    List<Player>? members,
    DateTime? createdAt,
    String? image,
    bool? isPremium,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  String get statusString {
    switch (status) {
      case GroupStatus.active:
        return 'active';
      case GroupStatus.inactive:
        return 'inactive';
    }
  }

  static GroupStatus statusFromString(String status) {
    switch (status) {
      case 'active':
        return GroupStatus.active;
      case 'inactive':
        return GroupStatus.inactive;
      default:
        return GroupStatus.active;
    }
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': statusString,
      'members': members.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'image': image,
      'isPremium': isPremium,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: statusFromString(json['status'] as String),
      members: (json['members'] as List)
          .map((m) => Player.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      image: json['image'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }
}
