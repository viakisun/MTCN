import '../../data/models/group.dart';
import '../../data/models/group_member.dart';
import '../../data/models/invitation.dart';

/// 그룹 데이터 접근 인터페이스
abstract class IGroupRepository {
  /// 사용자가 속한 그룹 목록 조회
  Future<List<Group>> getUserGroups(String userId);

  /// 그룹 상세 정보 조회
  Future<Group?> getGroup(String id);

  /// 그룹 생성
  Future<Group> createGroup(Group group);

  /// 그룹 수정
  Future<Group> updateGroup(Group group);

  /// 그룹 삭제
  Future<void> deleteGroup(String id);

  /// 그룹 검색
  Future<List<Group>> searchGroups(String query);

  /// 그룹 멤버 목록 조회
  Future<List<GroupMember>> getGroupMembers(String groupId);

  /// 그룹 멤버 추가
  Future<GroupMember> addGroupMember(GroupMember member);

  /// 그룹 멤버 수정
  Future<GroupMember> updateGroupMember(GroupMember member);

  /// 그룹 멤버 제거
  Future<void> removeGroupMember(String memberId);

  /// 그룹 초대 목록 조회
  Future<List<Invitation>> getGroupInvitations(String groupId);

  /// 사용자 초대 목록 조회
  Future<List<Invitation>> getUserInvitations(String userId);

  /// 그룹 초대 생성
  Future<Invitation> createInvitation(Invitation invitation);

  /// 초대 수락
  Future<Invitation> acceptInvitation(String invitationId);

  /// 초대 거절
  Future<Invitation> declineInvitation(String invitationId);
}
