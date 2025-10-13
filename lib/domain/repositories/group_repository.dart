import '../../data/models/group.dart';

/// 그룹 데이터 접근 인터페이스
abstract class IGroupRepository {
  /// 그룹 목록 조회 (MockDatabaseService 호환)
  Future<List<Group>> getGroups({
    String? statusFilter,
    String? searchKeyword,
    int? limit,
    int? offset,
  });

  /// 그룹 상세 정보 조회
  Future<Group?> getGroupById(String id);

  /// 그룹 생성
  Future<Group> createGroup(Group group);

  /// 그룹 수정
  Future<Group> updateGroup(Group group);

  /// 그룹 삭제
  Future<void> deleteGroup(String id);
}
