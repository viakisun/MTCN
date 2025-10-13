import '../../data/models/rounding.dart';
import '../../core/enums/rounding_enums.dart';

/// 알림 서비스 인터페이스
abstract class INotificationService {
  /// 라운딩 생성 알림
  Future<void> notifyRoundingCreated(Rounding rounding, List<String> playerIds);

  /// 라운딩 참가 알림
  Future<void> notifyRoundingJoined(Rounding rounding, String playerId);

  /// 라운딩 탈퇴 알림
  Future<void> notifyRoundingLeft(Rounding rounding, String playerId);

  /// 라운딩 상태 변경 알림
  Future<void> notifyRoundingStatusChanged(
    Rounding rounding,
    RoundingStatus oldStatus,
  );

  /// 그룹 초대 알림
  Future<void> notifyGroupInvitation(String groupId, String inviteeId);

  /// 그룹 가입 알림
  Future<void> notifyGroupJoined(String groupId, String playerId);

  /// 채팅 메시지 알림
  Future<void> notifyNewMessage(
    String groupId,
    String senderId,
    String message,
  );

  /// 푸시 알림 발송
  Future<void> sendPushNotification(String userId, String title, String body);

  /// 이메일 알림 발송
  Future<void> sendEmailNotification(String email, String subject, String body);
}

/// 알림 서비스 구현 (목업)
class NotificationService implements INotificationService {
  @override
  Future<void> notifyRoundingCreated(
    Rounding rounding,
    List<String> playerIds,
  ) async {
    // 실제 구현에서는 푸시 알림, 이메일 등을 발송
    print('라운딩 생성 알림: ${rounding.title} - 참가자 ${playerIds.length}명');

    for (final playerId in playerIds) {
      await sendPushNotification(
        playerId,
        '새로운 라운딩',
        '${rounding.title} 라운딩이 생성되었습니다',
      );
    }
  }

  @override
  Future<void> notifyRoundingJoined(Rounding rounding, String playerId) async {
    print('라운딩 참가 알림: ${rounding.title} - 참가자 $playerId');

    await sendPushNotification(
      playerId,
      '라운딩 참가',
      '${rounding.title} 라운딩에 참가되었습니다',
    );
  }

  @override
  Future<void> notifyRoundingLeft(Rounding rounding, String playerId) async {
    print('라운딩 탈퇴 알림: ${rounding.title} - 참가자 $playerId');

    await sendPushNotification(
      playerId,
      '라운딩 탈퇴',
      '${rounding.title} 라운딩에서 탈퇴되었습니다',
    );
  }

  @override
  Future<void> notifyRoundingStatusChanged(
    Rounding rounding,
    RoundingStatus oldStatus,
  ) async {
    print(
      '라운딩 상태 변경 알림: ${rounding.title} - ${oldStatus.displayName} → ${rounding.status.displayName}',
    );

    for (final player in rounding.players) {
      await sendPushNotification(
        player.id,
        '라운딩 상태 변경',
        '${rounding.title} 라운딩 상태가 ${rounding.status.displayName}로 변경되었습니다',
      );
    }
  }

  @override
  Future<void> notifyGroupInvitation(String groupId, String inviteeId) async {
    print('그룹 초대 알림: 그룹 $groupId - 초대받은 사용자 $inviteeId');

    await sendPushNotification(inviteeId, '그룹 초대', '새로운 그룹 초대가 있습니다');
  }

  @override
  Future<void> notifyGroupJoined(String groupId, String playerId) async {
    print('그룹 가입 알림: 그룹 $groupId - 가입한 사용자 $playerId');

    await sendPushNotification(playerId, '그룹 가입', '그룹에 성공적으로 가입되었습니다');
  }

  @override
  Future<void> notifyNewMessage(
    String groupId,
    String senderId,
    String message,
  ) async {
    print('새 메시지 알림: 그룹 $groupId - 발신자 $senderId');

    // 실제 구현에서는 그룹 멤버들에게 알림 발송
    await sendPushNotification(
      senderId,
      '새 메시지',
      message.length > 50 ? '${message.substring(0, 50)}...' : message,
    );
  }

  @override
  Future<void> sendPushNotification(
    String userId,
    String title,
    String body,
  ) async {
    // 실제 구현에서는 Firebase Cloud Messaging 등을 사용
    print('푸시 알림 발송: $userId - $title: $body');

    // 시뮬레이션된 네트워크 지연
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> sendEmailNotification(
    String email,
    String subject,
    String body,
  ) async {
    // 실제 구현에서는 이메일 서비스 사용
    print('이메일 알림 발송: $email - $subject');

    // 시뮬레이션된 네트워크 지연
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
