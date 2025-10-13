/// 푸시 알림 모델
class PushNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? data;

  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.data,
  });

  PushNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? data,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      data: data ?? this.data,
    );
  }
}

/// 알림 타입
enum NotificationType {
  roundingCreated,
  roundingUpdated,
  roundingCancelled,
  groupInvitation,
  newMessage,
  achievement,
  system,
}

/// 알림 설정 모델
class NotificationSettings {
  final Map<NotificationType, bool> enabledTypes;
  final bool pushEnabled;
  final bool emailEnabled;
  final String? emailAddress;

  const NotificationSettings({
    this.enabledTypes = const {
      NotificationType.roundingCreated: true,
      NotificationType.roundingUpdated: true,
      NotificationType.roundingCancelled: true,
      NotificationType.groupInvitation: true,
      NotificationType.newMessage: true,
      NotificationType.achievement: true,
      NotificationType.system: true,
    },
    this.pushEnabled = true,
    this.emailEnabled = false,
    this.emailAddress,
  });

  NotificationSettings copyWith({
    Map<NotificationType, bool>? enabledTypes,
    bool? pushEnabled,
    bool? emailEnabled,
    String? emailAddress,
  }) {
    return NotificationSettings(
      enabledTypes: enabledTypes ?? this.enabledTypes,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  bool isTypeEnabled(NotificationType type) {
    return enabledTypes[type] ?? true;
  }
}
