/// 목업 데이터베이스 서비스 (간단 버전)
///
/// 실제 데이터베이스처럼 동작하는 목업 서비스입니다.

import 'dart:async';
import 'dart:math';

/// 데이터베이스 인터페이스
abstract class IDatabaseService {
  Future<String> testConnection();
  Map<String, int> getStats();
}

/// 목업 데이터베이스 서비스 구현
class MockDatabaseService implements IDatabaseService {
  static final MockDatabaseService _instance = MockDatabaseService._internal();
  factory MockDatabaseService() => _instance;
  MockDatabaseService._internal();

  final Random _random = Random();

  @override
  Future<String> testConnection() async {
    await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(400)));
    return 'Mock Database Connected';
  }

  @override
  Map<String, int> getStats() {
    return {
      'roundings': _random.nextInt(100),
      'groups': _random.nextInt(50),
      'players': _random.nextInt(200),
      'messages': _random.nextInt(1000),
    };
  }

  /// 데이터 초기화 (테스트용)
  Future<void> resetDatabase() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
