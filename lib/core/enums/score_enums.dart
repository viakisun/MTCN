/// 스코어 관련 열거형들
import 'package:flutter/material.dart';

/// 스코어 품질
enum ScoreQuality {
  excellent('우수', 'excellent'),
  good('양호', 'good'),
  average('보통', 'average'),
  poor('부족', 'poor');

  const ScoreQuality(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static ScoreQuality fromString(String value) {
    switch (value) {
      case '우수':
      case 'excellent':
        return ScoreQuality.excellent;
      case '양호':
      case 'good':
        return ScoreQuality.good;
      case '보통':
      case 'average':
        return ScoreQuality.average;
      case '부족':
      case 'poor':
        return ScoreQuality.poor;
      default:
        return ScoreQuality.average;
    }
  }
}

/// 스코어 타입
enum ScoreType {
  stroke('타수', 'stroke'),
  stableford('스테이블포드', 'stableford'),
  match('매치플레이', 'match'),
  skins('스킨스', 'skins');

  const ScoreType(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static ScoreType fromString(String value) {
    switch (value) {
      case '타수':
      case 'stroke':
        return ScoreType.stroke;
      case '스테이블포드':
      case 'stableford':
        return ScoreType.stableford;
      case '매치플레이':
      case 'match':
        return ScoreType.match;
      case '스킨스':
      case 'skins':
        return ScoreType.skins;
      default:
        return ScoreType.stroke;
    }
  }
}

/// 홀 상태
enum HoleStatus {
  notStarted('시작전', 'not_started'),
  inProgress('진행중', 'in_progress'),
  completed('완료', 'completed'),
  skipped('건너뜀', 'skipped');

  const HoleStatus(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static HoleStatus fromString(String value) {
    switch (value) {
      case '시작전':
      case 'not_started':
        return HoleStatus.notStarted;
      case '진행중':
      case 'in_progress':
        return HoleStatus.inProgress;
      case '완료':
      case 'completed':
        return HoleStatus.completed;
      case '건너뜀':
      case 'skipped':
        return HoleStatus.skipped;
      default:
        return HoleStatus.notStarted;
    }
  }
}

/// 스코어 결과
enum ScoreResult {
  holeInOne('홀인원', 'hole_in_one'),
  albatross('알바트로스', 'albatross'),
  eagle('이글', 'eagle'),
  birdie('버디', 'birdie'),
  par('파', 'par'),
  bogey('보기', 'bogey'),
  doubleBogey('더블보기', 'double_bogey'),
  tripleBogey('트리플보기', 'triple_bogey'),
  other('기타', 'other');

  const ScoreResult(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static ScoreResult fromScore(int score, int par) {
    final difference = score - par;

    switch (difference) {
      case -3:
        return ScoreResult.albatross;
      case -2:
        return ScoreResult.eagle;
      case -1:
        return ScoreResult.birdie;
      case 0:
        return ScoreResult.par;
      case 1:
        return ScoreResult.bogey;
      case 2:
        return ScoreResult.doubleBogey;
      case 3:
        return ScoreResult.tripleBogey;
      default:
        if (score == 1) return ScoreResult.holeInOne;
        return ScoreResult.other;
    }
  }

  static ScoreResult fromString(String value) {
    switch (value) {
      case '홀인원':
      case 'hole_in_one':
        return ScoreResult.holeInOne;
      case '알바트로스':
      case 'albatross':
        return ScoreResult.albatross;
      case '이글':
      case 'eagle':
        return ScoreResult.eagle;
      case '버디':
      case 'birdie':
        return ScoreResult.birdie;
      case '파':
      case 'par':
        return ScoreResult.par;
      case '보기':
      case 'bogey':
        return ScoreResult.bogey;
      case '더블보기':
      case 'double_bogey':
        return ScoreResult.doubleBogey;
      case '트리플보기':
      case 'triple_bogey':
        return ScoreResult.tripleBogey;
      case '기타':
      case 'other':
        return ScoreResult.other;
      default:
        return ScoreResult.par;
    }
  }
}

/// 플레이어 티어
enum PlayerTier {
  beginner('초보', 'beginner', 0xFF8B4513),
  intermediate('중급', 'intermediate', 0xFFCD7F32),
  expert('고급', 'expert', 0xFFC0C0C0),
  pro('프로', 'pro', 0xFFFFD700);

  const PlayerTier(this.displayName, this.apiValue, this.colorValue);

  final String displayName;
  final String apiValue;
  final int colorValue;

  Color get color => Color(colorValue);

  static PlayerTier fromHandicap(int handicap) {
    if (handicap <= 5) return PlayerTier.pro;
    if (handicap <= 12) return PlayerTier.expert;
    if (handicap <= 20) return PlayerTier.intermediate;
    return PlayerTier.beginner;
  }

  static PlayerTier fromString(String value) {
    switch (value) {
      case '초보':
      case 'beginner':
        return PlayerTier.beginner;
      case '중급':
      case 'intermediate':
        return PlayerTier.intermediate;
      case '고급':
      case 'expert':
        return PlayerTier.expert;
      case '프로':
      case 'pro':
        return PlayerTier.pro;
      default:
        return PlayerTier.intermediate;
    }
  }
}

/// 통계 타입
enum StatisticsType {
  average('평균', 'average'),
  best('최고', 'best'),
  worst('최저', 'worst'),
  trend('트렌드', 'trend'),
  handicap('핸디캡', 'handicap');

  const StatisticsType(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static StatisticsType fromString(String value) {
    switch (value) {
      case '평균':
      case 'average':
        return StatisticsType.average;
      case '최고':
      case 'best':
        return StatisticsType.best;
      case '최저':
      case 'worst':
        return StatisticsType.worst;
      case '트렌드':
      case 'trend':
        return StatisticsType.trend;
      case '핸디캡':
      case 'handicap':
        return StatisticsType.handicap;
      default:
        return StatisticsType.average;
    }
  }
}
