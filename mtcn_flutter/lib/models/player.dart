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
    );
  }
}

class Position {
  final double x;
  final double y;

  const Position({required this.x, required this.y});

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}
