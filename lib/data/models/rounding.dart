import '../../core/constants/golf_courses.dart';
import '../../core/enums/rounding_enums.dart';

/// 라운딩 모델 (리팩토링된 버전)
class Rounding {
  final String id;
  final String title;
  final GolfCourse golfCourse;
  final DateTime date;
  final RoundingType type;
  final RoundingStatus status;
  final String organizerId;
  final String groupId;
  final List<String> players;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final RoundingPrivacy privacy;
  final RoundingDifficulty difficulty;
  final int maxPlayers;
  final int? fee;
  final RoundingOptions? options;

  const Rounding({
    required this.id,
    required this.title,
    required this.golfCourse,
    required this.date,
    required this.type,
    required this.status,
    required this.organizerId,
    required this.groupId,
    required this.players,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.privacy = RoundingPrivacy.public,
    this.difficulty = RoundingDifficulty.intermediate,
    this.maxPlayers = 4,
    this.fee,
    this.options,
  });

  Rounding copyWith({
    String? id,
    String? title,
    GolfCourse? golfCourse,
    DateTime? date,
    RoundingType? type,
    RoundingStatus? status,
    String? organizerId,
    String? groupId,
    List<String>? players,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    RoundingPrivacy? privacy,
    RoundingDifficulty? difficulty,
    int? maxPlayers,
    int? fee,
    RoundingOptions? options,
  }) {
    return Rounding(
      id: id ?? this.id,
      title: title ?? this.title,
      golfCourse: golfCourse ?? this.golfCourse,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      organizerId: organizerId ?? this.organizerId,
      groupId: groupId ?? this.groupId,
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      difficulty: difficulty ?? this.difficulty,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      fee: fee ?? this.fee,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'golfCourse': golfCourse.name,
      'date': date.toIso8601String(),
      'type': type.apiValue,
      'status': status.apiValue,
      'organizerId': organizerId,
      'groupId': groupId,
      'players': players,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'description': description,
      'privacy': privacy.apiValue,
      'difficulty': difficulty.apiValue,
      'maxPlayers': maxPlayers,
      'fee': fee,
      'options': options?.toJson(),
    };
  }

  factory Rounding.fromJson(Map<String, dynamic> json) {
    return Rounding(
      id: json['id'] as String,
      title: json['title'] as String,
      golfCourse: GolfCourseConstants.koreanCourses.firstWhere(
        (course) => course.name == json['golfCourse'],
        orElse: () => GolfCourseConstants.koreanCourses.first,
      ),
      date: DateTime.parse(json['date'] as String),
      type: RoundingType.fromString(json['type'] as String),
      status: RoundingStatus.fromString(json['status'] as String),
      organizerId: json['organizerId'] as String,
      groupId: json['groupId'] as String,
      players: List<String>.from(json['players'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      privacy: RoundingPrivacy.fromString(
        json['privacy'] as String? ?? 'public',
      ),
      difficulty: RoundingDifficulty.fromString(
        json['difficulty'] as String? ?? 'intermediate',
      ),
      maxPlayers: json['maxPlayers'] as int? ?? 4,
      fee: json['fee'] as int?,
      options: json['options'] != null
          ? RoundingOptions.fromJson(json['options'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rounding && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Rounding(id: $id, title: $title, date: $date)';
}

/// 라운딩 옵션
class RoundingOptions {
  final bool includeCaddie;
  final bool includeCart;
  final bool includeMeal;
  final String? mealType;
  final Map<String, dynamic>? extras;

  const RoundingOptions({
    this.includeCaddie = false,
    this.includeCart = false,
    this.includeMeal = false,
    this.mealType,
    this.extras,
  });

  RoundingOptions copyWith({
    bool? includeCaddie,
    bool? includeCart,
    bool? includeMeal,
    String? mealType,
    Map<String, dynamic>? extras,
  }) {
    return RoundingOptions(
      includeCaddie: includeCaddie ?? this.includeCaddie,
      includeCart: includeCart ?? this.includeCart,
      includeMeal: includeMeal ?? this.includeMeal,
      mealType: mealType ?? this.mealType,
      extras: extras ?? this.extras,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'includeCaddie': includeCaddie,
      'includeCart': includeCart,
      'includeMeal': includeMeal,
      'mealType': mealType,
      'extras': extras,
    };
  }

  factory RoundingOptions.fromJson(Map<String, dynamic> json) {
    return RoundingOptions(
      includeCaddie: json['includeCaddie'] as bool? ?? false,
      includeCart: json['includeCart'] as bool? ?? false,
      includeMeal: json['includeMeal'] as bool? ?? false,
      mealType: json['mealType'] as String?,
      extras: json['extras'] as Map<String, dynamic>?,
    );
  }
}
