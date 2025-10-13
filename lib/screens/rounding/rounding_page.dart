import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/cards/rounding_card.dart';
import 'create_rounding_page.dart';

class RoundingPage extends ConsumerWidget {
  const RoundingPage({super.key});

  Future<void> _handleRefresh(WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 1));
    ref.invalidate(filteredRoundingsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundings = ref.watch(filteredRoundingsProvider);
    final activeFilter = ref.watch(roundingFilterProvider);
    final searchQuery = ref.watch(roundingSearchProvider);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: DesignTokens.primary600,
              size: 24,
            ),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '라운딩',
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
                      ref.read(roundingSearchProvider.notifier).state = value;
                    },
                    decoration: const InputDecoration(
                      hintText: '라운딩 검색...',
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
                        label: '예정',
                        value: 'upcoming',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '진행중',
                        value: 'in-progress',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '완료',
                        value: 'completed',
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
                  '${roundings.length}개의 라운딩',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Roundings List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              color: DesignTokens.primary600,
              child: roundings.isEmpty
                  ? _buildEmptyState(searchQuery.isNotEmpty)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing4,
                      ),
                      itemCount: roundings.length,
                      itemBuilder: (context, index) {
                        return RoundingCard(rounding: roundings[index])
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
        heroTag: 'rounding_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoundingPage()),
          );
        },
        backgroundColor: DesignTokens.primary600,
        icon: const Icon(Icons.add, color: DesignTokens.neutral0),
        label: const Text(
          '라운딩 추가',
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
        ref.read(roundingFilterProvider.notifier).state = value;
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
              gradient: DesignTokens.gradientTerracotta,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.search_off,
              size: 60,
              color: DesignTokens.neutral0,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            isSearching ? '검색 결과가 없습니다' : '라운딩이 없습니다',
            style: const TextStyle(
              fontSize: DesignTokens.fontLg,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            isSearching ? '다른 검색어를 입력해보세요' : '새로운 라운딩을 추가해보세요',
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
