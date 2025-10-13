/// 앱 전반에서 사용되는 상수들
///
/// 하드코딩된 값들을 중앙화하여 관리합니다.
class AppConstants {
  // 앱 정보
  static const String appName = '몇타치니';
  static const String appVersion = '1.0.0';

  // API 설정
  static const String baseUrl = 'https://api.mtcn.app';
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // 데이터베이스 설정
  static const String databaseName = 'mtcn.db';
  static const int databaseVersion = 1;

  // 캐시 설정
  static const int cacheExpirationDays = 7;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // 파일 업로드
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx', 'txt'];

  // UI 설정
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 4.0;

  // 애니메이션
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // 페이지네이션
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // 검색 설정
  static const int minSearchLength = 2;
  static const int maxSearchResults = 50;
  static const Duration searchDebounceDuration = Duration(milliseconds: 300);

  // 알림 설정
  static const int maxNotificationRetries = 3;
  static const Duration notificationTimeout = Duration(seconds: 10);

  // 보안 설정
  static const int passwordMinLength = 8;
  static const int otpLength = 6;
  static const int otpExpirationMinutes = 5;

  // 골프 관련 설정
  static const int maxHolesPerRound = 18;
  static const int minHolesPerRound = 9;
  static const int maxPlayersPerGroup = 4;
  static const int minPlayersPerGroup = 1;

  // 점수 관련 설정
  static const int maxScorePerHole = 10;
  static const int minScorePerHole = 1;
  static const int parDefault = 4;

  // 채팅 설정
  static const int maxMessageLength = 1000;
  static const int maxAttachmentsPerMessage = 5;
  static const Duration messageRetentionDays = Duration(days: 30);

  // 그룹 설정
  static const int maxGroupMembers = 50;
  static const int maxGroupDescriptionLength = 500;
  static const int maxGroupNameLength = 30;

  // 프로필 설정
  static const int maxBioLength = 200;
  static const int maxNameLength = 20;
  static const List<String> allowedAvatarTypes = ['jpg', 'jpeg', 'png'];
  static const int maxAvatarSize = 5 * 1024 * 1024; // 5MB

  // 통계 설정
  static const int minRoundsForStatistics = 5;
  static const Duration statisticsUpdateInterval = Duration(hours: 1);

  // 에러 메시지
  static const String networkErrorMessage = '네트워크 연결을 확인해주세요';
  static const String serverErrorMessage = '서버에 문제가 발생했습니다';
  static const String unknownErrorMessage = '알 수 없는 오류가 발생했습니다';

  // 성공 메시지
  static const String saveSuccessMessage = '저장되었습니다';
  static const String deleteSuccessMessage = '삭제되었습니다';
  static const String updateSuccessMessage = '업데이트되었습니다';

  // 날짜 형식
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'yyyy년 MM월 dd일';
  static const String displayTimeFormat = 'HH시 mm분';

  // 정규표현식
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$';
  static const String urlRegex = r'^https?://[^\s/$.?#].[^\s]*$';

  // 색상 코드
  static const int primaryColorValue = 0xFF2563EB;
  static const int secondaryColorValue = 0xFF059669;
  static const int errorColorValue = 0xFFDC2626;
  static const int warningColorValue = 0xFFD97706;
  static const int successColorValue = 0xFF16A34A;

  // 테마
  static const String lightThemeId = 'light';
  static const String darkThemeId = 'dark';
  static const String systemThemeId = 'system';

  // 언어 설정
  static const String defaultLanguage = 'ko';
  static const List<String> supportedLanguages = ['ko', 'en'];

  // 개발 설정
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = true;

  // 테스트 설정
  static const String testUserId = 'test_user_123';
  static const String testGroupId = 'test_group_456';
  static const String testRoundingId = 'test_rounding_789';

  // 기능 플래그
  static const bool enableChatReactions = true;
  static const bool enableFileSharing = true;
  static const bool enableLiveTracking = true;
  static const bool enableAchievements = true;
  static const bool enableSocialFeatures = true;

  // 제한사항
  static const int maxDailyRounds = 2;
  static const int maxWeeklyRounds = 10;
  static const int maxMonthlyRounds = 40;

  // 프리미엄 기능
  static const bool enablePremiumFeatures = true;
  static const int freeRoundsLimit = 5;
  static const int premiumRoundsLimit = -1; // 무제한
}
