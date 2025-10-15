import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../data/models/group.dart';
import '../../data/models/group_member.dart';
import '../../widgets/common/avatar.dart';
import '../../widgets/common/badge.dart' as custom;

// Provider for search query
final memberSearchProvider = StateProvider<String>((ref) => '');

// Provider for role filter
final memberRoleFilterProvider = StateProvider<String>((ref) => 'all');

// Provider for filtered members
final filteredMembersProvider = Provider<List<GroupMember>>((ref) {
  // TODO: Replace with actual group members from provider
  final searchQuery = ref.watch(memberSearchProvider).toLowerCase();
  final roleFilter = ref.watch(memberRoleFilterProvider);

  // Mock data - replace with actual data
  final List<GroupMember> allMembers = [];

  var filtered = allMembers;

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((member) {
      return member.player.name.toLowerCase().contains(searchQuery);
    }).toList();
  }

  // Apply role filter
  if (roleFilter != 'all') {
    // TODO: Filter by role when Player model has role field
  }

  return filtered;
});

class MemberListPage extends ConsumerStatefulWidget {
  final Group group;

  const MemberListPage({super.key, required this.group});

  @override
  ConsumerState<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends ConsumerState<MemberListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(memberSearchProvider);
    final roleFilter = ref.watch(memberRoleFilterProvider);

    // Use group members directly instead of filtered provider for now
    final members = widget.group.members;

    // Apply search filter locally
    final filteredMembers = searchQuery.isEmpty
        ? members
        : members.where((member) {
            return member.player.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
          }).toList();

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '멤버',
              style: TextStyle(
                fontSize: DesignTokens.fontBase,
                fontWeight: DesignTokens.fontSemibold,
                color: DesignTokens.textPrimary,
              ),
            ),
            Text(
              '${widget.group.members.length}명',
              style: const TextStyle(
                fontSize: DesignTokens.fontXs,
                color: DesignTokens.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: DesignTokens.primary600),
            onPressed: () {
              // TODO: Navigate to invite members page
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('멤버 초대 기능은 준비중입니다')));
            },
            tooltip: '멤버 초대',
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: DesignTokens.neutral200),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: DesignTokens.neutral0,
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral50,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      ref.read(memberSearchProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: '멤버 검색...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: DesignTokens.textSecondary,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: DesignTokens.textSecondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(memberSearchProvider.notifier).state =
                                    '';
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing3,
                        vertical: DesignTokens.spacing3,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: DesignTokens.spacing3),

                // Role Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildRoleChip('전체', 'all', roleFilter),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildRoleChip('관리자', 'admin', roleFilter),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildRoleChip('멤버', 'member', roleFilter),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildRoleChip('대기중', 'pending', roleFilter),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 50.ms),
              ],
            ),
          ),

          // Member Count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing4,
              vertical: DesignTokens.spacing3,
            ),
            child: Row(
              children: [
                Text(
                  '${filteredMembers.length}명의 멤버',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

          // Members List
          Expanded(
            child: filteredMembers.isEmpty
                ? _buildEmptyState(searchQuery.isNotEmpty)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacing4,
                    ),
                    itemCount: filteredMembers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: DesignTokens.spacing3),
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      final isAdmin =
                          index == 0; // First member is admin for demo

                      return _buildMemberCard(member, isAdmin)
                          .animate()
                          .fadeIn(
                            duration: 500.ms,
                            delay: (150 + index * 50).ms,
                          )
                          .slideX(begin: 0.2, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, String value, String activeFilter) {
    final isActive = activeFilter == value;

    return GestureDetector(
      onTap: () {
        ref.read(memberRoleFilterProvider.notifier).state = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing3,
          vertical: DesignTokens.spacing2,
        ),
        decoration: BoxDecoration(
          color: isActive ? DesignTokens.primary600 : DesignTokens.neutral100,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontMedium,
            color: isActive
                ? DesignTokens.neutral0
                : DesignTokens.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(GroupMember member, bool isAdmin) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          // Avatar
          Avatar(
            imageUrl: member.player.avatar,
            name: member.player.name,
            size: AvatarSize.medium,
          ),
          const SizedBox(width: DesignTokens.spacing3),

          // Member Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.player.name,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontBase,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: DesignTokens.spacing2),
                      custom.Badge(
                        text: '관리자',
                        variant: custom.BadgeVariant.info,
                        size: custom.BadgeSize.small,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.golf_course,
                      size: 14,
                      color: DesignTokens.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '평균 ${member.player.averageScore}타',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontXs,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    const Icon(
                      Icons.emoji_events,
                      size: 14,
                      color: DesignTokens.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${member.player.bestScore}타',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontXs,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: DesignTokens.textSecondary,
            ),
            onPressed: () {
              _showMemberOptions(context, member, isAdmin);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: DesignTokens.gradientEucalyptus,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.people_outline,
              size: 60,
              color: DesignTokens.neutral0,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            isSearching ? '검색 결과가 없습니다' : '멤버가 없습니다',
            style: const TextStyle(
              fontSize: DesignTokens.fontLg,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            isSearching ? '다른 검색어를 입력해보세요' : '새로운 멤버를 초대해보세요',
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberOptions(
    BuildContext context,
    GroupMember member,
    bool isAdmin,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        decoration: const BoxDecoration(
          color: DesignTokens.neutral0,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(DesignTokens.radiusXl),
            topRight: Radius.circular(DesignTokens.radiusXl),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DesignTokens.neutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),

              // Member info
              Row(
                children: [
                  Avatar(
                    imageUrl: member.player.avatar,
                    name: member.player.name,
                    size: AvatarSize.medium,
                  ),
                  const SizedBox(width: DesignTokens.spacing3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.player.name,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontLg,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      Text(
                        '평균 ${member.player.averageScore}타',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing4),
              const Divider(color: DesignTokens.neutral200),
              const SizedBox(height: DesignTokens.spacing2),

              // Options
              _buildOption(
                icon: Icons.person,
                label: '프로필 보기',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('프로필 보기 기능은 준비중입니다')),
                  );
                },
              ),
              _buildOption(
                icon: Icons.chat,
                label: '메시지 보내기',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('메시지 기능은 준비중입니다')),
                  );
                },
              ),
              if (isAdmin)
                _buildOption(
                  icon: Icons.admin_panel_settings,
                  label: '관리자로 설정',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('권한 변경 기능은 준비중입니다')),
                    );
                  },
                ),
              _buildOption(
                icon: Icons.remove_circle_outline,
                label: '멤버 제거',
                color: DesignTokens.error,
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveConfirmation(context, member);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spacing3,
          horizontal: DesignTokens.spacing2,
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? DesignTokens.textPrimary, size: 24),
            const SizedBox(width: DesignTokens.spacing3),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontBase,
                color: color ?? DesignTokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context, GroupMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('멤버 제거'),
        content: Text('${member.player.name}님을 그룹에서 제거하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member.player.name}님이 제거되었습니다'),
                  backgroundColor: DesignTokens.success,
                ),
              );
            },
            child: const Text(
              '제거',
              style: TextStyle(color: DesignTokens.error),
            ),
          ),
        ],
      ),
    );
  }
}
