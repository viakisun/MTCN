import '../../core/enums/rounding_enums.dart';
import 'player.dart';

/// 라운딩 옵션 모델
class RoundingOptions {
  final bool allowLateJoin;
  final bool requireHandicap;
  final bool allowGuests;
  final String? specialRules;

  const RoundingOptions({
    this.allowLateJoin = true,
    this.requireHandicap = false,
    this.allowGuests = true,
    this.specialRules,
  });

  Map<String, dynamic> toJson() {
    return {
      'allowLateJoin': allowLateJoin,
      'requireHandicap': requireHandicap,
      'allowGuests': allowGuests,
      'specialRules': specialRules,
    };
  }

  factory RoundingOptions.fromJson(Map<String, dynamic> json) {
    return RoundingOptions(
      allowLateJoin: json['allowLateJoin'] as bool? ?? true,
      requireHandicap: json['requireHandicap'] as bool? ?? false,
      allowGuests: json['allowGuests'] as bool? ?? true,
      specialRules: json['specialRules'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoundingOptions &&
        other.allowLateJoin == allowLateJoin &&
        other.requireHandicap == requireHandicap &&
        other.allowGuests == allowGuests &&
        other.specialRules == specialRules;
  }

  @override
  int get hashCode {
    return Object.hash(
      allowLateJoin,
      requireHandicap,
      allowGuests,
      specialRules,
    );
  }

  @override
  String toString() {
    return 'RoundingOptions(allowLateJoin: $allowLateJoin, requireHandicap: $requireHandicap, allowGuests: $allowGuests, specialRules: $specialRules)';
  }
}

/// 라운딩 모델 (MockDatabaseService 호환)
class Rounding {
  final String id;
  final String title;
  final String courseName;
  final String? courseAddress;
  final double? courseLatitude;
  final double? courseLongitude;
  final String date;
  final String time;
  final RoundingStatus status;
  final int greenFee;
  final String weather;
  final int temperature;
  final List<Player> players;
  final int holes;
  final String? description;
  final String groupName;
  final int? fee;
  final int? maxPlayers;
  final RoundingOptions? options;
  final RoundingType type;
  final RoundingPrivacy privacy;
  final RoundingDifficulty difficulty;

  const Rounding({
    required this.id,
    required this.title,
    required this.courseName,
    required this.date,
    required this.time,
    required this.status,
    required this.greenFee,
    required this.weather,
    required this.temperature,
    required this.players,
    required this.holes,
    required this.groupName,
    this.courseAddress = '',
    this.courseLatitude,
    this.courseLongitude,
    this.description,
    this.fee,
    this.maxPlayers,
    this.options,
    this.type = RoundingType.full18,
    this.privacy = RoundingPrivacy.public,
    this.difficulty = RoundingDifficulty.intermediate,
  });

  Rounding copyWith({
    String? id,
    String? title,
    String? courseName,
    String? courseAddress,
    double? courseLatitude,
    double? courseLongitude,
    String? date,
    String? time,
    RoundingStatus? status,
    int? greenFee,
    String? weather,
    int? temperature,
    List<Player>? players,
    int? holes,
    String? description,
    String? groupName,
    int? fee,
    int? maxPlayers,
    RoundingOptions? options,
    RoundingType? type,
    RoundingPrivacy? privacy,
    RoundingDifficulty? difficulty,
  }) {
    return Rounding(
      id: id ?? this.id,
      title: title ?? this.title,
      courseName: courseName ?? this.courseName,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      greenFee: greenFee ?? this.greenFee,
      weather: weather ?? this.weather,
      temperature: temperature ?? this.temperature,
      players: players ?? this.players,
      holes: holes ?? this.holes,
      groupName: groupName ?? this.groupName,
      courseAddress: courseAddress ?? this.courseAddress,
      courseLatitude: courseLatitude ?? this.courseLatitude,
      courseLongitude: courseLongitude ?? this.courseLongitude,
      description: description ?? this.description,
      fee: fee ?? this.fee,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      options: options ?? this.options,
      type: type ?? this.type,
      privacy: privacy ?? this.privacy,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseName': courseName,
      'courseAddress': courseAddress,
      'courseLatitude': courseLatitude,
      'courseLongitude': courseLongitude,
      'date': date,
      'time': time,
      'status': status.apiValue,
      'greenFee': greenFee,
      'weather': weather,
      'temperature': temperature,
      'players': players.map((p) => p.toJson()).toList(),
      'holes': holes,
      'description': description,
      'groupName': groupName,
      'fee': fee,
      'maxPlayers': maxPlayers,
      'options': options?.toJson(),
      'type': type.apiValue,
      'privacy': privacy.apiValue,
      'difficulty': difficulty.apiValue,
    };
  }

  factory Rounding.fromJson(Map<String, dynamic> json) {
    return Rounding(
      id: json['id'] as String,
      title: json['title'] as String,
      courseName: json['courseName'] as String,
      courseAddress: json['courseAddress'] as String? ?? '',
      courseLatitude: json['courseLatitude'] as double?,
      courseLongitude: json['courseLongitude'] as double?,
      date: json['date'] as String,
      time: json['time'] as String,
      status: RoundingStatus.fromString(json['status'] as String),
      greenFee: json['greenFee'] as int,
      weather: json['weather'] as String,
      temperature: json['temperature'] as int,
      players: (json['players'] as List)
          .map((p) => Player.fromJson(p as Map<String, dynamic>))
          .toList(),
      holes: json['holes'] as int,
      description: json['description'] as String?,
      groupName: json['groupName'] as String,
      fee: json['fee'] as int?,
      maxPlayers: json['maxPlayers'] as int?,
      options: json['options'] != null
          ? RoundingOptions.fromJson(json['options'] as Map<String, dynamic>)
          : null,
      type: RoundingType.fromString(json['type'] as String? ?? 'full18'),
      privacy: RoundingPrivacy.fromString(
        json['privacy'] as String? ?? 'public',
      ),
      difficulty: RoundingDifficulty.fromString(
        json['difficulty'] as String? ?? 'intermediate',
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rounding &&
        other.id == id &&
        other.title == title &&
        other.courseName == courseName &&
        other.courseAddress == courseAddress &&
        other.courseLatitude == courseLatitude &&
        other.courseLongitude == courseLongitude &&
        other.date == date &&
        other.time == time &&
        other.status == status &&
        other.greenFee == greenFee &&
        other.weather == weather &&
        other.temperature == temperature &&
        other.players == players &&
        other.holes == holes &&
        other.description == description &&
        other.groupName == groupName &&
        other.fee == fee &&
        other.maxPlayers == maxPlayers &&
        other.options == options &&
        other.type == type &&
        other.privacy == privacy &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    return Object.hash(
          id,
          title,
          courseName,
          courseAddress,
          courseLatitude,
          courseLongitude,
          date,
          time,
          status,
          greenFee,
          weather,
          temperature,
          players,
          holes,
          description,
          groupName,
          fee,
          maxPlayers,
          options,
        ) ^
        Object.hash(type, privacy, difficulty);
  }

  @override
  String toString() {
    return 'Rounding(id: $id, title: $title, courseName: $courseName, courseAddress: $courseAddress, courseLatitude: $courseLatitude, courseLongitude: $courseLongitude, date: $date, time: $time, status: $status, greenFee: $greenFee, weather: $weather, temperature: $temperature, players: $players, holes: $holes, description: $description, groupName: $groupName, fee: $fee, maxPlayers: $maxPlayers, options: $options, type: $type, privacy: $privacy, difficulty: $difficulty)';
  }
}
