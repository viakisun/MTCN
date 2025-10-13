import '../../models/group.dart';
import '../mock/mock_groups.dart';

/// Repository for group data access
abstract class GroupRepository {
  Future<List<Group>> getAllGroups();
  Future<Group> getGroupById(String id);
  Future<List<Group>> getActiveGroups();
  Future<List<Group>> getNewGroups();
  Future<Group> createGroup(Group group);
  Future<Group> updateGroup(Group group);
  Future<void> deleteGroup(String id);
}

/// Mock implementation of GroupRepository
class MockGroupRepository implements GroupRepository {
  @override
  Future<List<Group>> getAllGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockGroups.all;
  }

  @override
  Future<Group> getGroupById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockGroups.findById(id);
  }

  @override
  Future<List<Group>> getActiveGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockGroups.activeGroups();
  }

  @override
  Future<List<Group>> getNewGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockGroups.newGroups();
  }

  @override
  Future<Group> createGroup(Group group) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return group;
  }

  @override
  Future<Group> updateGroup(Group group) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return group;
  }

  @override
  Future<void> deleteGroup(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
