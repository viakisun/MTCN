/// Firebase 설정 파일
///
/// Firebase 프로젝트 설정 후 google-services.json (Android) 및
/// GoogleService-Info.plist (iOS) 파일을 추가해야 합니다.
class FirebaseConfig {
  // Firebase 프로젝트가 설정되면 아래 값들을 업데이트하세요
  static const String androidApiKey = 'YOUR_ANDROID_API_KEY';
  static const String iosApiKey = 'YOUR_IOS_API_KEY';
  static const String projectId = 'mtcn-golf';
  static const String messagingSenderId = 'YOUR_MESSAGING_SENDER_ID';
  static const String appId = 'YOUR_APP_ID';

  // Storage bucket
  static const String storageBucket = 'mtcn-golf.appspot.com';

  // 환경별 설정
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;

  // Collection 이름
  static const String usersCollection = 'users';
  static const String roundingsCollection = 'roundings';
  static const String groupsCollection = 'groups';
  static const String scoresCollection = 'scores';
  static const String chatMessagesCollection = 'chat_messages';
  static const String notificationsCollection = 'notifications';
  static const String paymentsCollection = 'payments';
}
