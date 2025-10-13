import '../../core/enums/score_enums.dart';

/// 플레이어 모델 (리팩토링된 버전)
class Player {
  final String id;
  final String name;
  final String firstName;
  final String lastName;
  final int averageScore;
  final int bestScore;
  final int handicap;
  final String avatar;
  final int? currentHole;
  final int? currentScore;
  final Position? position;
  final bool isPlaying;
  final PlayerTier tier;
  final DateTime? lastPlayed;
  final int totalRounds;
  final int totalWins;
  final double winRate;

  const Player({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.averageScore,
    required this.bestScore,
    required this.handicap,
    required this.avatar,
    this.currentHole,
    this.currentScore,
    this.position,
    this.isPlaying = false,
    this.tier = PlayerTier.intermediate,
    this.lastPlayed,
    this.totalRounds = 0,
    this.totalWins = 0,
    this.winRate = 0.0,
  });

  Player copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    int? averageScore,
    int? bestScore,
    int? handicap,
    String? avatar,
    int? currentHole,
    int? currentScore,
    Position? position,
    bool? isPlaying,
    PlayerTier? tier,
    DateTime? lastPlayed,
    int? totalRounds,
    int? totalWins,
    double? winRate,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      averageScore: averageScore ?? this.averageScore,
      bestScore: bestScore ?? this.bestScore,
      handicap: handicap ?? this.handicap,
      avatar: avatar ?? this.avatar,
      currentHole: currentHole ?? this.currentHole,
      currentScore: currentScore ?? this.currentScore,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      tier: tier ?? this.tier,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      totalRounds: totalRounds ?? this.totalRounds,
      totalWins: totalWins ?? this.totalWins,
      winRate: winRate ?? this.winRate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'averageScore': averageScore,
      'bestScore': bestScore,
      'handicap': handicap,
      'avatar': avatar,
      'currentHole': currentHole,
      'currentScore': currentScore,
      'position': position?.toJson(),
      'isPlaying': isPlaying,
      'tier': tier.apiValue,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'totalRounds': totalRounds,
      'totalWins': totalWins,
      'winRate': winRate,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      averageScore: json['averageScore'] as int,
      bestScore: json['bestScore'] as int,
      handicap: json['handicap'] as int,
      avatar: json['avatar'] as String,
      currentHole: json['currentHole'] as int?,
      currentScore: json['currentScore'] as int?,
      position: json['position'] != null
          ? Position.fromJson(json['position'] as Map<String, dynamic>)
          : null,
      isPlaying: json['isPlaying'] as bool? ?? false,
      tier: PlayerTier.fromString(json['tier'] as String? ?? 'intermediate'),
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'] as String)
          : null,
      totalRounds: json['totalRounds'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Player(id: $id, name: $name, handicap: $handicap)';
}

/// 위치 정보
class Position {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final DateTime timestamp;

  const Position({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    required this.timestamp,
  });

  Position copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    DateTime? timestamp,
  }) {
    return Position(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      altitude: json['altitude'] as double?,
      accuracy: json['accuracy'] as double?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'Position(lat: $latitude, lng: $longitude)';
}
