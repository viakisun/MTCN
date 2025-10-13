import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// NotificationService Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// 알림 목록 Provider
final notificationsProvider = StateProvider<List<PushNotification>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.notifications;
});

/// 읽지 않은 알림 개수 Provider
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

/// 알림 타입별 활성화 상태 Provider
final notificationEnabledProvider =
    StateProvider.family<bool, NotificationType>((ref, type) {
      // TODO: 실제로는 SharedPreferences나 서버에서 가져와야 함
      return true;
    });
