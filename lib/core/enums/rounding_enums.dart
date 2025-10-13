/// 라운딩 관련 열거형들
enum RoundingType {
  full18('18홀', 18),
  half9('9홀', 9),
  practice('연습', 1);

  const RoundingType(this.displayName, this.holeCount);

  final String displayName;
  final int holeCount;

  String get apiValue => name;

  static RoundingType fromString(String value) {
    switch (value) {
      case '18홀':
      case 'full18':
        return RoundingType.full18;
      case '9홀':
      case 'half9':
        return RoundingType.half9;
      case '연습':
      case 'practice':
        return RoundingType.practice;
      default:
        return RoundingType.full18;
    }
  }
}

/// 라운딩 상태
enum RoundingStatus {
  upcoming('예정', 'upcoming'),
  inProgress('진행중', 'in-progress'),
  completed('완료', 'completed'),
  cancelled('취소', 'cancelled');

  const RoundingStatus(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static RoundingStatus fromString(String value) {
    switch (value) {
      case '예정':
      case 'upcoming':
        return RoundingStatus.upcoming;
      case '진행중':
      case 'in-progress':
      case 'in_progress':
        return RoundingStatus.inProgress;
      case '완료':
      case 'completed':
        return RoundingStatus.completed;
      case '취소':
      case 'cancelled':
        return RoundingStatus.cancelled;
      default:
        return RoundingStatus.upcoming;
    }
  }
}

/// 날씨 조건
enum WeatherCondition {
  sunny('맑음', '☀️'),
  cloudy('구름', '☁️'),
  overcast('흐림', '🌥️'),
  rainy('비', '🌧️'),
  snowy('눈', '❄️');

  const WeatherCondition(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  static WeatherCondition fromString(String value) {
    switch (value) {
      case '맑음':
      case 'sunny':
        return WeatherCondition.sunny;
      case '구름':
      case 'cloudy':
        return WeatherCondition.cloudy;
      case '흐림':
      case 'overcast':
        return WeatherCondition.overcast;
      case '비':
      case 'rainy':
        return WeatherCondition.rainy;
      case '눈':
      case 'snowy':
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.sunny;
    }
  }
}

/// 라운딩 프라이버시 설정
enum RoundingPrivacy {
  public('공개', 'public'),
  private('비공개', 'private'),
  inviteOnly('초대만', 'invite_only');

  const RoundingPrivacy(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static RoundingPrivacy fromString(String value) {
    switch (value) {
      case '공개':
      case 'public':
        return RoundingPrivacy.public;
      case '비공개':
      case 'private':
        return RoundingPrivacy.private;
      case '초대만':
      case 'invite_only':
      case 'inviteOnly':
        return RoundingPrivacy.inviteOnly;
      default:
        return RoundingPrivacy.public;
    }
  }
}

/// 라운딩 난이도
enum RoundingDifficulty {
  beginner('초급', 1),
  intermediate('중급', 2),
  advanced('고급', 3),
  expert('전문가', 4);

  const RoundingDifficulty(this.displayName, this.level);

  final String displayName;
  final int level;

  String get apiValue => name;

  static RoundingDifficulty fromString(String value) {
    switch (value) {
      case '초급':
      case 'beginner':
        return RoundingDifficulty.beginner;
      case '중급':
      case 'intermediate':
        return RoundingDifficulty.intermediate;
      case '고급':
      case 'advanced':
        return RoundingDifficulty.advanced;
      case '전문가':
      case 'expert':
        return RoundingDifficulty.expert;
      default:
        return RoundingDifficulty.intermediate;
    }
  }
}
