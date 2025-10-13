import '../../domain/repositories/group_repository.dart';
import '../../data/models/group.dart';
import '../../data/services/mock_database_service.dart';

/// Mock implementation of IGroupRepository
class MockGroupRepository implements IGroupRepository {
  final IDatabaseService _databaseService;

  MockGroupRepository(this._databaseService);

  @override
  Future<List<Group>> getGroups({
    String? statusFilter,
    String? searchKeyword,
    int? limit,
    int? offset,
  }) async {
    return _databaseService.getGroups(
      statusFilter: statusFilter,
      searchKeyword: searchKeyword,
    );
  }

  @override
  Future<Group?> getGroupById(String id) async {
    return _databaseService.getGroupById(id);
  }

  @override
  Future<Group> createGroup(Group group) async {
    return _databaseService.createGroup(group);
  }

  @override
  Future<Group> updateGroup(Group group) async {
    return _databaseService.updateGroup(group);
  }

  @override
  Future<void> deleteGroup(String id) async {
    return _databaseService.deleteGroup(id);
  }
}
