import 'package:flutter/material.dart';

/// 네비게이션 서비스
///
/// 전역에서 네비게이션을 관리할 수 있도록 도와주는 서비스입니다.
/// main.dart에서 navigatorKey를 MaterialApp에 설정해야 합니다.
class NavigationService {
  // 싱글톤 패턴
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 현재 컨텍스트
  BuildContext? get context => navigatorKey.currentContext;

  /// 현재 상태
  NavigatorState? get navigator => navigatorKey.currentState;

  /// 새로운 페이지로 이동
  Future<T?> navigateTo<T>(Widget page, {bool replace = false}) async {
    if (navigator == null) return null;

    if (replace) {
      return await navigator!.pushReplacement(
        MaterialPageRoute<T>(builder: (_) => page),
      );
    } else {
      return await navigator!.push(MaterialPageRoute<T>(builder: (_) => page));
    }
  }

  /// Named route로 이동
  Future<T?> navigateToNamed<T>(String routeName, {Object? arguments}) async {
    if (navigator == null) return null;
    return await navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// 현재 페이지를 교체하면서 이동
  Future<T?> navigateToReplacement<T, TO>(Widget page, {TO? result}) async {
    if (navigator == null) return null;
    return await navigator!.pushReplacement(
      MaterialPageRoute<T>(builder: (_) => page),
      result: result,
    );
  }

  /// 모든 스택을 제거하고 새로운 페이지로 이동
  Future<T?> navigateToAndRemoveUntil<T>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) async {
    if (navigator == null) return null;
    return await navigator!.pushAndRemoveUntil(
      MaterialPageRoute<T>(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }

  /// 뒤로 가기
  void goBack<T>([T? result]) {
    if (navigator == null) return;
    if (navigator!.canPop()) {
      navigator!.pop<T>(result);
    }
  }

  /// 특정 페이지까지 뒤로 가기
  void popUntil(bool Function(Route<dynamic>) predicate) {
    if (navigator == null) return;
    navigator!.popUntil(predicate);
  }

  /// Dialog 표시
  Future<T?> showDialogWidget<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) async {
    if (context == null) return null;
    return await showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog,
    );
  }

  /// BottomSheet 표시
  Future<T?> showBottomSheetWidget<T>({
    required Widget content,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    if (context == null) return null;
    return await showModalBottomSheet<T>(
      context: context!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => content,
    );
  }

  /// SnackBar 표시
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    if (context == null) return;
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  /// 성공 SnackBar
  void showSuccessSnackBar(String message) {
    showSnackBar(message: message, backgroundColor: Colors.green);
  }

  /// 에러 SnackBar
  void showErrorSnackBar(String message) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }

  /// 정보 SnackBar
  void showInfoSnackBar(String message) {
    showSnackBar(message: message, backgroundColor: Colors.blue);
  }
}
