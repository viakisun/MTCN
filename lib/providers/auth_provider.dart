import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/player.dart';
import '../services/auth_service.dart';

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// 현재 사용자 Provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, Player?>(
  (ref) {
    final authService = ref.watch(authServiceProvider);
    return CurrentUserNotifier(authService);
  },
);

/// 현재 사용자 상태 관리
class CurrentUserNotifier extends StateNotifier<Player?> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService) : super(null) {
    _init();
  }

  void _init() {
    // AuthService의 상태 변경 리스닝
    _authService.authStateChanges.addListener(_onAuthStateChanged);
    state = _authService.currentUser;
  }

  void _onAuthStateChanged() {
    state = _authService.authStateChanges.value;
  }

  /// 이메일 로그인
  Future<AuthResult> signInWithEmail(String email, String password) async {
    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );
    if (result.success && result.user != null) {
      state = result.user;
    }
    return result;
  }

  /// 회원가입
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
    if (result.success && result.user != null) {
      state = result.user;
    }
    return result;
  }

  /// 카카오 로그인
  Future<AuthResult> signInWithKakao() async {
    final result = await _authService.signInWithKakao();
    if (result.success && result.user != null) {
      state = result.user;
    }
    return result;
  }

  /// 네이버 로그인
  Future<AuthResult> signInWithNaver() async {
    final result = await _authService.signInWithNaver();
    if (result.success && result.user != null) {
      state = result.user;
    }
    return result;
  }

  /// 구글 로그인
  Future<AuthResult> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();
    if (result.success && result.user != null) {
      state = result.user;
    }
    return result;
  }

  /// Apple 로그인
  Future<AuthResult> signInWithApple() async {
    final result = await _authService.signInWithApple();
    if (result.success && result.user != null) {
      state = result.user;
    }
    return result;
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }

  /// 비밀번호 재설정
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    return await _authService.sendPasswordResetEmail(email);
  }

  /// 계정 삭제
  Future<AuthResult> deleteAccount() async {
    final result = await _authService.deleteAccount();
    if (result.success) {
      state = null;
    }
    return result;
  }

  @override
  void dispose() {
    _authService.authStateChanges.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}

/// 인증 상태 Provider (로그인 여부)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// 로딩 상태 Provider
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// 에러 메시지 Provider
final authErrorProvider = StateProvider<String?>((ref) => null);
