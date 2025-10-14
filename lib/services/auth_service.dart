import 'package:flutter/foundation.dart';
import '../data/models/player.dart';

/// 인증 결과를 나타내는 클래스
class AuthResult {
  final bool success;
  final String? error;
  final Player? user;

  const AuthResult({required this.success, this.error, this.user});

  factory AuthResult.success(Player user) {
    return AuthResult(success: true, user: user);
  }

  factory AuthResult.failure(String error) {
    return AuthResult(success: false, error: error);
  }
}

/// 로그인 방법
enum LoginMethod { email, kakao, naver, google, apple }

/// 인증 서비스
///
/// 사용자 인증, 로그인, 로그아웃, 회원가입 등을 처리합니다.
/// 실제 구현 시 Firebase Auth 또는 Supabase Auth를 사용하세요.
class AuthService {
  // 싱글톤 패턴
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // 현재 로그인된 사용자
  Player? _currentUser;
  Player? get currentUser => _currentUser;

  // 로그인 상태 스트림
  final _authStateController = ValueNotifier<Player?>(null);
  ValueListenable<Player?> get authStateChanges => _authStateController;

  /// 초기화
  Future<void> initialize() async {
    // TODO: Firebase/Supabase 초기화
    // 저장된 세션이 있으면 자동 로그인
    await _loadSavedSession();
  }

  /// 이메일/비밀번호로 로그인
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Firebase/Supabase 이메일 로그인 구현
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

      // Mock user for development
      final user = Player(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: '사용자',
        firstName: '사용',
        lastName: '자',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=$email',
        handicap: 18,
        averageScore: 90,
        bestScore: 82,
      );

      await _setCurrentUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// 이메일/비밀번호로 회원가입
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // TODO: Firebase/Supabase 회원가입 구현
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

      final nameParts = name.split(' ');
      final user = Player(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        firstName: nameParts.length > 1 ? nameParts[1] : name,
        lastName: nameParts.isNotEmpty ? nameParts[0] : '',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=$email',
        handicap: 36, // 신규 사용자 기본 핸디캡
        averageScore: 100,
        bestScore: 92,
      );

      await _setCurrentUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// 카카오 로그인
  Future<AuthResult> signInWithKakao() async {
    try {
      // TODO: Kakao Login SDK 연동
      await Future.delayed(const Duration(seconds: 1));

      final user = Player(
        id: 'kakao_${DateTime.now().millisecondsSinceEpoch}',
        name: '카카오 사용자',
        firstName: '사용자',
        lastName: '카카오',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=kakao',
        handicap: 18,
        averageScore: 90,
        bestScore: 82,
      );

      await _setCurrentUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('카카오 로그인 실패: ${e.toString()}');
    }
  }

  /// 네이버 로그인
  Future<AuthResult> signInWithNaver() async {
    try {
      // TODO: Naver Login SDK 연동
      await Future.delayed(const Duration(seconds: 1));

      final user = Player(
        id: 'naver_${DateTime.now().millisecondsSinceEpoch}',
        name: '네이버 사용자',
        firstName: '사용자',
        lastName: '네이버',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=naver',
        handicap: 18,
        averageScore: 90,
        bestScore: 82,
      );

      await _setCurrentUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('네이버 로그인 실패: ${e.toString()}');
    }
  }

  /// 구글 로그인
  Future<AuthResult> signInWithGoogle() async {
    try {
      // TODO: Google Sign-In SDK 연동
      await Future.delayed(const Duration(seconds: 1));

      final user = Player(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Google 사용자',
        firstName: '사용자',
        lastName: 'Google',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=google',
        handicap: 18,
        averageScore: 90,
        bestScore: 82,
      );

      await _setCurrentUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('구글 로그인 실패: ${e.toString()}');
    }
  }

  /// Apple 로그인 (iOS only)
  Future<AuthResult> signInWithApple() async {
    try {
      // TODO: Apple Sign-In SDK 연동
      await Future.delayed(const Duration(seconds: 1));

      final user = Player(
        id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Apple 사용자',
        firstName: '사용자',
        lastName: 'Apple',
        avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=apple',
        handicap: 18,
        averageScore: 90,
        bestScore: 82,
      );

      await _setCurrentUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('Apple 로그인 실패: ${e.toString()}');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      // TODO: Firebase/Supabase 로그아웃
      await _clearSession();
      await _setCurrentUser(null);
    } catch (e) {
      debugPrint('로그아웃 에러: $e');
    }
  }

  /// 비밀번호 재설정 이메일 전송
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      // TODO: Firebase/Supabase 비밀번호 재설정
      await Future.delayed(const Duration(seconds: 1));
      return AuthResult.success(
        Player(
          id: 'temp',
          name: 'temp',
          firstName: 'temp',
          lastName: 'temp',
          avatar: '',
          handicap: 0,
          averageScore: 0,
          bestScore: 0,
        ),
      );
    } catch (e) {
      return AuthResult.failure('비밀번호 재설정 실패: ${e.toString()}');
    }
  }

  /// 회원 탈퇴
  Future<AuthResult> deleteAccount() async {
    try {
      // TODO: Firebase/Supabase 계정 삭제
      await Future.delayed(const Duration(seconds: 1));
      await _setCurrentUser(null);
      return const AuthResult(success: true);
    } catch (e) {
      return AuthResult.failure('계정 삭제 실패: ${e.toString()}');
    }
  }

  /// 저장된 세션 로드
  Future<void> _loadSavedSession() async {
    try {
      // TODO: SharedPreferences 또는 Secure Storage에서 토큰 로드
      // 토큰이 유효하면 사용자 정보 가져오기
    } catch (e) {
      debugPrint('세션 로드 에러: $e');
    }
  }

  /// 세션 저장
  Future<void> _saveSession() async {
    try {
      // TODO: SharedPreferences 또는 Secure Storage에 토큰 저장
    } catch (e) {
      debugPrint('세션 저장 에러: $e');
    }
  }

  /// 세션 삭제
  Future<void> _clearSession() async {
    try {
      // TODO: SharedPreferences 또는 Secure Storage에서 토큰 삭제
    } catch (e) {
      debugPrint('세션 삭제 에러: $e');
    }
  }

  /// 현재 사용자 설정
  Future<void> _setCurrentUser(Player? user) async {
    _currentUser = user;
    _authStateController.value = user;
    if (user != null) {
      await _saveSession();
    }
  }

  /// 리소스 정리
  void dispose() {
    _authStateController.dispose();
  }
}
