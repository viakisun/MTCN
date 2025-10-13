import 'package:flutter/foundation.dart';

/// 알림 타입
enum NotificationType {
  roundingInvite, // 라운딩 초대
  chatMessage, // 채팅 메시지
  gameStart, // 경기 시작
  paymentRequest, // 결제 요청
  announcement, // 공지사항
  system, // 시스템 알림
}

/// 푸시 알림 메시지
class PushNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final Map<String, dynamic>? data;
  final DateTime receivedAt;
  final bool isRead;

  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.receivedAt,
    this.isRead = false,
  });

  PushNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    Map<String, dynamic>? data,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// 푸시 알림 서비스
///
/// FCM(Firebase Cloud Messaging) 또는 OneSignal을 사용하여
/// 푸시 알림을 관리합니다.
class NotificationService {
  // 싱글톤 패턴
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // 알림 수신 리스너
  final _notificationController = ValueNotifier<PushNotification?>(null);
  ValueListenable<PushNotification?> get onNotificationReceived =>
      _notificationController;

  // 저장된 알림 목록
  final List<PushNotification> _notifications = [];
  List<PushNotification> get notifications => List.unmodifiable(_notifications);

  // 읽지 않은 알림 개수
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// 초기화
  Future<void> initialize() async {
    // TODO: FCM 또는 OneSignal 초기화
    await _requestPermission();
    await _setupListeners();
    debugPrint('NotificationService initialized');
  }

  /// 알림 권한 요청
  Future<bool> _requestPermission() async {
    try {
      // TODO: 플랫폼별 알림 권한 요청
      // iOS: UNUserNotificationCenter
      // Android: 기본적으로 허용됨 (Android 13+ 는 권한 필요)

      debugPrint('Notification permission requested');
      return true;
    } catch (e) {
      debugPrint('Failed to request notification permission: $e');
      return false;
    }
  }

  /// 알림 리스너 설정
  Future<void> _setupListeners() async {
    try {
      // TODO: FCM 또는 OneSignal 리스너 설정
      // onMessage: 앱이 foreground일 때
      // onMessageOpenedApp: 앱이 background일 때 알림 탭
      // onBackgroundMessage: 앱이 종료된 상태에서 알림 수신

      debugPrint('Notification listeners set up');
    } catch (e) {
      debugPrint('Failed to setup notification listeners: $e');
    }
  }

  /// FCM 토큰 가져오기
  Future<String?> getToken() async {
    try {
      // TODO: FCM 토큰 가져오기
      // final token = await FirebaseMessaging.instance.getToken();
      // return token;

      return 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  /// 토큰을 서버에 등록
  Future<void> registerToken(String userId) async {
    try {
      final token = await getToken();
      if (token == null) return;

      // TODO: 서버에 토큰 전송
      // await api.registerDeviceToken(userId: userId, token: token);

      debugPrint('FCM token registered for user: $userId');
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  /// 알림 수신 처리
  void _handleNotification(PushNotification notification) {
    _notifications.insert(0, notification);
    _notificationController.value = notification;
    debugPrint('Notification received: ${notification.title}');
  }

  /// 특정 알림 읽음 처리
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// 모든 알림 읽음 처리
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  /// 알림 삭제
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  /// 모든 알림 삭제
  void clearAllNotifications() {
    _notifications.clear();
  }

  /// 특정 타입의 알림 활성화/비활성화
  Future<void> setNotificationEnabled(
    NotificationType type,
    bool enabled,
  ) async {
    try {
      // TODO: 서버에 설정 저장
      // await api.updateNotificationSettings(type: type, enabled: enabled);

      debugPrint('Notification type $type ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Failed to update notification settings: $e');
    }
  }

  /// 테스트 알림 전송 (개발용)
  void sendTestNotification() {
    final testNotification = PushNotification(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: '테스트 알림',
      body: '푸시 알림이 정상적으로 작동합니다',
      type: NotificationType.system,
      receivedAt: DateTime.now(),
    );
    _handleNotification(testNotification);
  }

  /// 리소스 정리
  void dispose() {
    _notificationController.dispose();
    _notifications.clear();
  }
}
