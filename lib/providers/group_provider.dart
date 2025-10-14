import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/service_locator.dart';
import '../domain/repositories/group_repository.dart';
import '../../data/models/group.dart';
import '../core/enums/group_enums.dart';
import '../domain/utils/result.dart';

/// 그룹 Repository Provider
final groupRepositoryProvider = Provider<IGroupRepository>((ref) {
  return ref.watch(serviceLocatorProvider).groupRepository;
});

/// 그룹 목록 상태
class GroupListState {
  final List<Group> groups;
  final bool isLoading;
  final String? error;
  final String? statusFilter;
  final String? searchKeyword;

  const GroupListState({
    this.groups = const [],
    this.isLoading = false,
    this.error,
    this.statusFilter,
    this.searchKeyword,
  });

  GroupListState copyWith({
    List<Group>? groups,
    bool? isLoading,
    String? error,
    String? statusFilter,
    String? searchKeyword,
    bool clearError = false,
  }) {
    return GroupListState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      statusFilter: statusFilter ?? this.statusFilter,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

/// 그룹 목록 Notifier
class GroupListNotifier extends StateNotifier<GroupListState> {
  final IGroupRepository _repository;

  GroupListNotifier(this._repository) : super(const GroupListState()) {
    loadGroups();
  }

  /// 그룹 목록 로드
  Future<void> loadGroups({String? statusFilter, String? searchKeyword}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      statusFilter: statusFilter,
      searchKeyword: searchKeyword,
    );

    try {
      final groups = await _repository.getGroups(
        statusFilter: statusFilter,
        searchKeyword: searchKeyword,
      );

      state = state.copyWith(groups: groups, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 그룹 생성
  Future<Result<Group>> createGroup({
    required String name,
    required String description,
    required bool isPublic,
    String? avatarUrl,
    List<String>? memberIds,
  }) async {
    try {
      final newGroup = Group(
        id: '',
        name: name,
        description: description,
        avatarUrl: avatarUrl,
        isPublic: isPublic,
        status: GroupStatus.active,
        roundCount: 0, // 새 그룹은 0부터 시작
        members: [], // 멤버는 별도로 추가
        createdAt: DateTime.now(),
      );

      final createdGroup = await _repository.createGroup(newGroup);

      // 목록 새로고침
      await loadGroups(
        statusFilter: state.statusFilter,
        searchKeyword: state.searchKeyword,
      );

      return Result.success(createdGroup);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// 그룹 업데이트
  Future<void> updateGroup(Group group) async {
    try {
      await _repository.updateGroup(group);

      // 목록 새로고침
      await loadGroups(
        statusFilter: state.statusFilter,
        searchKeyword: state.searchKeyword,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 그룹 삭제
  Future<void> deleteGroup(String id) async {
    try {
      await _repository.deleteGroup(id);

      // 목록에서 제거
      final updatedGroups = state.groups.where((g) => g.id != id).toList();

      state = state.copyWith(groups: updatedGroups);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 필터 적용
  void applyFilter(String? statusFilter) {
    loadGroups(statusFilter: statusFilter, searchKeyword: state.searchKeyword);
  }

  /// 검색
  void search(String? keyword) {
    loadGroups(statusFilter: state.statusFilter, searchKeyword: keyword);
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadGroups(
      statusFilter: state.statusFilter,
      searchKeyword: state.searchKeyword,
    );
  }
}

/// 그룹 목록 Provider
final groupListProvider =
    StateNotifierProvider<GroupListNotifier, GroupListState>((ref) {
      final repository = ref.watch(groupRepositoryProvider);
      return GroupListNotifier(repository);
    });

/// 활성 그룹 Provider
final activeGroupsProvider = Provider<List<Group>>((ref) {
  final groups = ref.watch(groupListProvider).groups;

  return groups.where((g) {
    return g.status == GroupStatus.active;
  }).toList();
});

/// 내가 참여한 그룹 Provider
final myGroupsProvider = Provider<List<Group>>((ref) {
  final groups = ref.watch(groupListProvider).groups;
  final currentUserId = 'current_user'; // TODO: 실제 사용자 ID로 교체

  return groups.where((g) {
    return g.members.any((m) => m.playerId == currentUserId);
  }).toList();
});

/// 공개 그룹 Provider
final publicGroupsProvider = Provider<List<Group>>((ref) {
  final groups = ref.watch(groupListProvider).groups;

  return groups.where((g) {
    return g.isPublic && g.status == GroupStatus.active;
  }).toList();
});

/// 특정 그룹 Provider
final groupProvider = FutureProvider.family<Group?, String>((ref, id) async {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.getGroupById(id);
});
