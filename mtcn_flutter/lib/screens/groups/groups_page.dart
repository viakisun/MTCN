import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/cards/group_card.dart';
import 'create_group_page.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  Future<void> _handleRefresh(WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 1));
    ref.invalidate(filteredGroupsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(filteredGroupsProvider);
    final activeFilter = ref.watch(groupFilterProvider);
    final searchQuery = ref.watch(groupSearchProvider);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.groups, color: DesignTokens.primary600, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '모임',
              style: TextStyle(
                fontSize: DesignTokens.fontXl,
                fontWeight: DesignTokens.fontSemibold,
                color: DesignTokens.textPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
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
                    onChanged: (value) {
                      ref.read(groupSearchProvider.notifier).state = value;
                    },
                    decoration: const InputDecoration(
                      hintText: '그룹 검색...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: DesignTokens.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing3,
                        vertical: DesignTokens.spacing3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing3),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        context,
                        ref,
                        label: '전체',
                        value: 'all',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '활성',
                        value: 'active',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '비활성',
                        value: 'inactive',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '신규',
                        value: 'new',
                        activeFilter: activeFilter,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing4,
              vertical: DesignTokens.spacing3,
            ),
            child: Row(
              children: [
                Text(
                  '${groups.length}개의 그룹',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Groups List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              color: DesignTokens.primary600,
              child: groups.isEmpty
                  ? _buildEmptyState(searchQuery.isNotEmpty)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing4,
                      ),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return GroupCard(group: groups[index])
                            .animate()
                            .fadeIn(duration: 500.ms, delay: (index * 50).ms)
                            .slideY(begin: 0.1, end: 0);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'groups_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupPage()),
          );
        },
        backgroundColor: DesignTokens.primary600,
        icon: const Icon(Icons.add, color: DesignTokens.neutral0),
        label: const Text(
          '그룹 만들기',
          style: TextStyle(
            color: DesignTokens.neutral0,
            fontWeight: DesignTokens.fontSemibold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String value,
    required String activeFilter,
  }) {
    final isActive = activeFilter == value;

    return GestureDetector(
      onTap: () {
        ref.read(groupFilterProvider.notifier).state = value;
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

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: DesignTokens.gradientGold,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.groups_outlined,
              size: 60,
              color: DesignTokens.neutral0,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            isSearching ? '검색 결과가 없습니다' : '그룹이 없습니다',
            style: const TextStyle(
              fontSize: DesignTokens.fontLg,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            isSearching ? '다른 검색어를 입력해보세요' : '새로운 그룹을 만들어보세요',
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
