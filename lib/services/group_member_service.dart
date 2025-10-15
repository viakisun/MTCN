import 'package:flutter/foundation.dart';
import '../data/models/group_member.dart';
import '../data/models/player.dart';
import '../core/enums/group_enums.dart' as group_enums;
import '../models/invitation.dart' as invitation_models;

/// 그룹 멤버 서비스
///
/// 멤버 관리, 권한 관리, 승인/거절 등을 처리합니다.
/// 실제 구현 시 Firebase Firestore 또는 Supabase를 사용하세요.
class GroupMemberService {
  GroupMemberService._();
  static final GroupMemberService instance = GroupMemberService._();

  // Mock 저장소: 그룹별 멤버 목록
  final Map<String, List<GroupMember>> _membersByGroup = {};

  // Mock 저장소: 초대 목록
  final Map<String, List<invitation_models.Invitation>> _invitationsByGroup =
      {};

  /// 그룹 멤버 목록 조회
  Future<List<GroupMember>> getGroupMembers({
    required String groupId,
    group_enums.MemberStatus? status,
  }) async {
    try {
      debugPrint('=== Get Group Members ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Status filter: ${status?.name ?? "all"}');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final members = _membersByGroup[groupId] ?? [];

      // 상태 필터링
      if (status != null) {
        return members.where((m) => m.status == status).toList();
      }

      return members;
    } catch (e) {
      debugPrint('Error getting group members: $e');
      return [];
    }
  }

  /// 승인 대기 중인 멤버 조회
  Future<List<GroupMember>> getPendingMembers(String groupId) async {
    return getGroupMembers(
      groupId: groupId,
      status: group_enums.MemberStatus.pending,
    );
  }

  /// 활성 멤버 조회
  Future<List<GroupMember>> getActiveMembers(String groupId) async {
    return getGroupMembers(
      groupId: groupId,
      status: group_enums.MemberStatus.active,
    );
  }

  /// 멤버 승인
  Future<bool> approveMember({
    required String groupId,
    required String memberId,
    required String approverId,
  }) async {
    try {
      debugPrint('=== Approve Member ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Member ID: $memberId');
      debugPrint('Approver ID: $approverId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 500));

      final members = _membersByGroup[groupId];
      if (members == null) return false;

      final memberIndex = members.indexWhere((m) => m.id == memberId);
      if (memberIndex == -1) return false;

      final member = members[memberIndex];
      if (member.status != group_enums.MemberStatus.pending) {
        debugPrint('Member is not pending: ${member.status.name}');
        return false;
      }

      // 승인 처리
      members[memberIndex] = member.copyWith(
        status: group_enums.MemberStatus.active,
        approvedAt: DateTime.now(),
        approvedBy: approverId,
      );

      debugPrint('Member approved successfully');
      return true;
    } catch (e) {
      debugPrint('Error approving member: $e');
      return false;
    }
  }

  /// 멤버 거절
  Future<bool> rejectMember({
    required String groupId,
    required String memberId,
    required String rejecterId,
    String? reason,
  }) async {
    try {
      debugPrint('=== Reject Member ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Member ID: $memberId');
      debugPrint('Rejecter ID: $rejecterId');
      debugPrint('Reason: ${reason ?? "none"}');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 500));

      final members = _membersByGroup[groupId];
      if (members == null) return false;

      final memberIndex = members.indexWhere((m) => m.id == memberId);
      if (memberIndex == -1) return false;

      final member = members[memberIndex];
      if (member.status != group_enums.MemberStatus.pending) {
        debugPrint('Member is not pending: ${member.status.name}');
        return false;
      }

      // 거절 처리
      members[memberIndex] = member.copyWith(
        status: group_enums.MemberStatus.rejected,
        rejectedBy: rejecterId,
        rejectionReason: reason,
      );

      debugPrint('Member rejected successfully');
      return true;
    } catch (e) {
      debugPrint('Error rejecting member: $e');
      return false;
    }
  }

  /// 멤버 권한 변경
  Future<bool> changeMemberRole({
    required String groupId,
    required String memberId,
    required group_enums.MemberRole newRole,
    required String changedBy,
  }) async {
    try {
      debugPrint('=== Change Member Role ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Member ID: $memberId');
      debugPrint('New Role: ${newRole.name}');
      debugPrint('Changed By: $changedBy');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final members = _membersByGroup[groupId];
      if (members == null) return false;

      final memberIndex = members.indexWhere((m) => m.id == memberId);
      if (memberIndex == -1) return false;

      final member = members[memberIndex];
      if (member.status != group_enums.MemberStatus.active) {
        debugPrint('Member is not active: ${member.status.name}');
        return false;
      }

      // 권한 변경
      members[memberIndex] = member.copyWith(role: newRole);

      debugPrint('Member role changed successfully');
      return true;
    } catch (e) {
      debugPrint('Error changing member role: $e');
      return false;
    }
  }

  /// 멤버 추방
  Future<bool> kickMember({
    required String groupId,
    required String memberId,
    required String kickedBy,
  }) async {
    try {
      debugPrint('=== Kick Member ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Member ID: $memberId');
      debugPrint('Kicked By: $kickedBy');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final members = _membersByGroup[groupId];
      if (members == null) return false;

      final memberIndex = members.indexWhere((m) => m.id == memberId);
      if (memberIndex == -1) return false;

      // 추방 (상태를 left로 변경)
      members.removeAt(memberIndex);

      debugPrint('Member kicked successfully');
      return true;
    } catch (e) {
      debugPrint('Error kicking member: $e');
      return false;
    }
  }

  /// 멤버 차단
  Future<bool> banMember({
    required String groupId,
    required String memberId,
    required String bannedBy,
  }) async {
    try {
      debugPrint('=== Ban Member ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Member ID: $memberId');
      debugPrint('Banned By: $bannedBy');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final members = _membersByGroup[groupId];
      if (members == null) return false;

      final memberIndex = members.indexWhere((m) => m.id == memberId);
      if (memberIndex == -1) return false;

      final member = members[memberIndex];

      // 차단 처리
      members[memberIndex] = member.copyWith(
        status: group_enums.MemberStatus.banned,
      );

      debugPrint('Member banned successfully');
      return true;
    } catch (e) {
      debugPrint('Error banning member: $e');
      return false;
    }
  }

  /// 멤버 초대
  Future<invitation_models.Invitation?> inviteMember({
    required String groupId,
    required String groupName,
    required Player inviter,
    required Player invitee,
    String? message,
  }) async {
    try {
      debugPrint('=== Invite Member ===');
      debugPrint('Group: $groupName');
      debugPrint('Inviter: ${inviter.name}');
      debugPrint('Invitee: ${invitee.name}');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      // 초대 생성
      final invitation = invitation_models.Invitation(
        id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
        groupId: groupId,
        groupName: groupName,
        inviter: inviter,
        invitee: invitee,
        status: invitation_models.InvitationStatus.pending,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 7)), // 7일 후 만료
        message: message,
      );

      // 저장소에 추가
      if (!_invitationsByGroup.containsKey(groupId)) {
        _invitationsByGroup[groupId] = [];
      }
      _invitationsByGroup[groupId]!.add(invitation);

      debugPrint('Invitation created: ${invitation.id}');
      return invitation;
    } catch (e) {
      debugPrint('Error inviting member: $e');
      return null;
    }
  }

  /// 초대 수락
  Future<bool> acceptInvitation(String invitationId) async {
    try {
      debugPrint('=== Accept Invitation ===');
      debugPrint('Invitation ID: $invitationId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      // 초대 찾기
      invitation_models.Invitation? invitation;
      String? groupId;

      for (final entry in _invitationsByGroup.entries) {
        final inv = entry.value.firstWhere(
          (i) => i.id == invitationId,
          orElse: () => invitation_models.Invitation(
            id: '',
            groupId: '',
            groupName: '',
            inviter: Player(
              id: '',
              name: '',
              firstName: '',
              lastName: '',
              avatar: '',
              handicap: 0,
              averageScore: 0,
              bestScore: 0,
            ),
            invitee: Player(
              id: '',
              name: '',
              firstName: '',
              lastName: '',
              avatar: '',
              handicap: 0,
              averageScore: 0,
              bestScore: 0,
            ),
            status: invitation_models.InvitationStatus.pending,
            createdAt: DateTime.now(),
            expiresAt: DateTime.now(),
          ),
        );

        if (inv.id.isNotEmpty) {
          invitation = inv;
          groupId = entry.key;
          break;
        }
      }

      if (invitation == null || groupId == null) {
        debugPrint('Invitation not found');
        return false;
      }

      if (!invitation.isValid) {
        debugPrint('Invitation is not valid');
        return false;
      }

      // 초대 수락 처리
      final invitations = _invitationsByGroup[groupId]!;
      final invIndex = invitations.indexWhere((i) => i.id == invitationId);
      invitations[invIndex] = invitation.copyWith(
        status: invitation_models.InvitationStatus.accepted,
        respondedAt: DateTime.now(),
      );

      // 그룹에 멤버 추가
      final member = GroupMember(
        id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
        groupId: groupId,
        playerId: invitation.invitee.id,
        player: invitation.invitee,
        role: group_enums.MemberRole.member,
        status: group_enums.MemberStatus.active,
        joinedAt: DateTime.now(),
        approvedAt: DateTime.now(),
      );

      if (!_membersByGroup.containsKey(groupId)) {
        _membersByGroup[groupId] = [];
      }
      _membersByGroup[groupId]!.add(member);

      debugPrint('Invitation accepted, member added');
      return true;
    } catch (e) {
      debugPrint('Error accepting invitation: $e');
      return false;
    }
  }

  /// 초대 거절
  Future<bool> declineInvitation(String invitationId) async {
    try {
      debugPrint('=== Decline Invitation ===');
      debugPrint('Invitation ID: $invitationId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      // 초대 찾기 및 거절 처리
      for (final entry in _invitationsByGroup.entries) {
        final invitations = entry.value;
        final invIndex = invitations.indexWhere((i) => i.id == invitationId);

        if (invIndex != -1) {
          final invitation = invitations[invIndex];

          if (!invitation.isValid) {
            debugPrint('Invitation is not valid');
            return false;
          }

          invitations[invIndex] = invitation.copyWith(
            status: invitation_models.InvitationStatus.declined,
            respondedAt: DateTime.now(),
          );

          debugPrint('Invitation declined');
          return true;
        }
      }

      debugPrint('Invitation not found');
      return false;
    } catch (e) {
      debugPrint('Error declining invitation: $e');
      return false;
    }
  }

  /// 사용자의 초대 목록 조회
  Future<List<invitation_models.Invitation>> getUserInvitations({
    required String userId,
    invitation_models.InvitationStatus? status,
  }) async {
    try {
      debugPrint('=== Get User Invitations ===');
      debugPrint('User ID: $userId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final allInvitations = _invitationsByGroup.values
          .expand((invitations) => invitations)
          .where((inv) => inv.invitee.id == userId);

      // 상태 필터링
      if (status != null) {
        return allInvitations.where((inv) => inv.status == status).toList();
      }

      return allInvitations.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error getting user invitations: $e');
      return [];
    }
  }
}
