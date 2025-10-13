import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/cards/score_card.dart';
import 'score_entry_page.dart';
import 'score_trends_page.dart';

class ScorePage extends ConsumerWidget {
  const ScorePage({super.key});

  Future<void> _handleRefresh(WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 1));
    ref.invalidate(filteredScoresProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(filteredScoresProvider);
    final activeFilter = ref.watch(scoreFilterProvider);
    final searchQuery = ref.watch(scoreSearchProvider);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: DesignTokens.primary600, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '스코어',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart, color: DesignTokens.primary600),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScoreTrendsPage(),
                ),
              );
            },
            tooltip: '스코어 추이',
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
                    onChanged: (value) {
                      ref.read(scoreSearchProvider.notifier).state = value;
                    },
                    decoration: const InputDecoration(
                      hintText: '스코어 검색...',
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
                        label: '우수',
                        value: 'excellent',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '양호',
                        value: 'good',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '보통',
                        value: 'average',
                        activeFilter: activeFilter,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      _buildFilterChip(
                        context,
                        ref,
                        label: '아쉬움',
                        value: 'poor',
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
                  '${scores.length}개의 스코어',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Scores List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              color: DesignTokens.primary600,
              child: scores.isEmpty
                  ? _buildEmptyState(searchQuery.isNotEmpty)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing4,
                      ),
                      itemCount: scores.length,
                      itemBuilder: (context, index) {
                        return ScoreCard(score: scores[index])
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
        heroTag: 'score_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScoreEntryPage()),
          );
        },
        backgroundColor: DesignTokens.primary600,
        icon: const Icon(Icons.add, color: DesignTokens.neutral0),
        label: const Text(
          '스코어 입력',
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
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
        ref.read(scoreFilterProvider.notifier).state = value;
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
              gradient: DesignTokens.gradientEucalyptus,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.bar_chart,
              size: 60,
              color: DesignTokens.neutral0,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            isSearching ? '검색 결과가 없습니다' : '스코어 기록이 없습니다',
            style: const TextStyle(
              fontSize: DesignTokens.fontLg,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            isSearching ? '다른 검색어를 입력해보세요' : '라운딩 후 스코어를 기록해보세요',
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
