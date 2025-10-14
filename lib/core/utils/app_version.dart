import 'package:package_info_plus/package_info_plus.dart';

/// 앱 버전 정보를 관리하는 유틸리티 클래스
class AppVersion {
  /// 버전 정보를 문자열로 반환
  /// 형식: v0.1.0+1 (2025-01-14 15:30)
  static Future<String> getVersionString() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final buildDate = DateTime.now();

      return 'v${packageInfo.version}+${packageInfo.buildNumber} (${_formatDate(buildDate)})';
    } catch (e) {
      // 에러 발생 시 기본값 반환
      final buildDate = DateTime.now();
      return 'v0.1.0+1 (${_formatDate(buildDate)})';
    }
  }

  /// 날짜를 YYYY-MM-DD 형식으로 포맷팅
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 간단한 버전 번호만 반환 (v0.1.0)
  static Future<String> getSimpleVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return 'v${packageInfo.version}';
    } catch (e) {
      return 'v0.1.0';
    }
  }

  /// 빌드 번호만 반환
  static Future<String> getBuildNumber() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      return '1';
    }
  }
}
