import 'player.dart';

enum RoundingStatus { upcoming, inProgress, completed }

/// 라운딩 옵션 (캐디, 카트, 식사 등)
class RoundingOptions {
  final bool includeCaddie;
  final bool includeCart;
  final bool includeMeal;
  final String? mealType; // 'breakfast', 'lunch', 'dinner'
  final Map<String, dynamic>? extras; // 추가 옵션

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
      includeCaddie: json['includeCaddie'] ?? false,
      includeCart: json['includeCart'] ?? false,
      includeMeal: json['includeMeal'] ?? false,
      mealType: json['mealType'],
      extras: json['extras'],
    );
  }
}

class Rounding {
  final String id;
  final String courseName;
  final String eventName;
  final String groupName; // 동문회 이름
  final String date;
  final String time;
  final RoundingStatus status;
  final int greenFee;
  final String weather;
  final int temperature;
  final List<Player> players;
  final int holes;
  final String? description;
  final int? currentHole;
  final int? totalHoles;
  final String? notice;

  // Phase 2 추가 필드
  final int? fee; // 참가비 (그린피와 별도)
  final int? maxPlayers; // 최대 참가 인원
  final RoundingOptions? options; // 라운딩 옵션
  final String? courseAddress; // 골프장 주소
  final double? courseLatitude; // 골프장 위도
  final double? courseLongitude; // 골프장 경도

  const Rounding({
    required this.id,
    required this.courseName,
    required this.eventName,
    required this.groupName,
    required this.date,
    required this.time,
    required this.status,
    required this.greenFee,
    required this.weather,
    required this.temperature,
    required this.players,
    required this.holes,
    this.description,
    this.currentHole,
    this.totalHoles,
    this.notice,
    this.fee,
    this.maxPlayers,
    this.options,
    this.courseAddress,
    this.courseLatitude,
    this.courseLongitude,
  });

  Rounding copyWith({
    String? id,
    String? courseName,
    String? eventName,
    String? groupName,
    String? date,
    String? time,
    RoundingStatus? status,
    int? greenFee,
    String? weather,
    int? temperature,
    List<Player>? players,
    int? holes,
    String? description,
    int? currentHole,
    int? totalHoles,
    String? notice,
    int? fee,
    int? maxPlayers,
    RoundingOptions? options,
    String? courseAddress,
    double? courseLatitude,
    double? courseLongitude,
  }) {
    return Rounding(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      eventName: eventName ?? this.eventName,
      groupName: groupName ?? this.groupName,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      greenFee: greenFee ?? this.greenFee,
      weather: weather ?? this.weather,
      temperature: temperature ?? this.temperature,
      players: players ?? this.players,
      holes: holes ?? this.holes,
      description: description ?? this.description,
      currentHole: currentHole ?? this.currentHole,
      totalHoles: totalHoles ?? this.totalHoles,
      notice: notice ?? this.notice,
      fee: fee ?? this.fee,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      options: options ?? this.options,
      courseAddress: courseAddress ?? this.courseAddress,
      courseLatitude: courseLatitude ?? this.courseLatitude,
      courseLongitude: courseLongitude ?? this.courseLongitude,
    );
  }

  String get statusString {
    switch (status) {
      case RoundingStatus.upcoming:
        return 'upcoming';
      case RoundingStatus.inProgress:
        return 'in-progress';
      case RoundingStatus.completed:
        return 'completed';
    }
  }

  static RoundingStatus statusFromString(String status) {
    switch (status) {
      case 'upcoming':
        return RoundingStatus.upcoming;
      case 'in-progress':
        return RoundingStatus.inProgress;
      case 'completed':
        return RoundingStatus.completed;
      default:
        return RoundingStatus.upcoming;
    }
  }
}
