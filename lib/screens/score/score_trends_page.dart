import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/charts/score_trend_chart.dart';

class ScoreTrendsPage extends ConsumerStatefulWidget {
  const ScoreTrendsPage({super.key});

  @override
  ConsumerState<ScoreTrendsPage> createState() => _ScoreTrendsPageState();
}

class _ScoreTrendsPageState extends ConsumerState<ScoreTrendsPage> {
  String _selectedTimeRange = 'month';

  @override
  Widget build(BuildContext context) {
    final scores = ref.watch(filteredScoresProvider);

    // Calculate statistics
    final totalRounds = scores.length;
    final avgScore = totalRounds > 0
        ? scores.map((s) => s.totalScore).reduce((a, b) => a + b) / totalRounds
        : 0.0;
    final bestScore = totalRounds > 0
        ? scores.map((s) => s.totalScore).reduce((a, b) => a < b ? a : b)
        : 0;

    // Calculate improvement
    double improvement = 0;
    if (totalRounds >= 2) {
      final recent5 = scores.take(5).toList();
      final older5 = scores.skip(5).take(5).toList();

      if (recent5.isNotEmpty && older5.isNotEmpty) {
        final recentAvg =
            recent5.map((s) => s.totalScore).reduce((a, b) => a + b) /
            recent5.length;
        final olderAvg =
            older5.map((s) => s.totalScore).reduce((a, b) => a + b) /
            older5.length;
        improvement = olderAvg - recentAvg;
      }
    }

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '스코어 추이',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: DesignTokens.neutral200),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child:
                      _buildStatCard(
                            '총 라운드',
                            totalRounds.toString(),
                            Icons.golf_course,
                            DesignTokens.gradientEucalyptus,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
                const SizedBox(width: DesignTokens.spacing3),
                Expanded(
                  child:
                      _buildStatCard(
                            '평균 스코어',
                            avgScore > 0 ? avgScore.toStringAsFixed(1) : '-',
                            Icons.insights,
                            DesignTokens.gradientSky,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 100.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacing3),
            Row(
              children: [
                Expanded(
                  child:
                      _buildStatCard(
                            '최고 기록',
                            bestScore > 0 ? bestScore.toString() : '-',
                            Icons.emoji_events,
                            DesignTokens.gradientGold,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 200.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
                const SizedBox(width: DesignTokens.spacing3),
                Expanded(
                  child:
                      _buildStatCard(
                            '향상도',
                            improvement != 0
                                ? '${improvement > 0 ? '-' : '+'}${improvement.abs().toStringAsFixed(1)}'
                                : '-',
                            improvement >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            improvement >= 0
                                ? DesignTokens.gradientEucalyptus
                                : DesignTokens.gradientTerracotta,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 300.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacing6),

            // Time Range Selector
            const Text(
              '기간 선택',
              style: TextStyle(
                fontSize: DesignTokens.fontBase,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
            const SizedBox(height: DesignTokens.spacing3),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTimeRangeChip('주간', 'week'),
                  const SizedBox(width: DesignTokens.spacing2),
                  _buildTimeRangeChip('월간', 'month'),
                  const SizedBox(width: DesignTokens.spacing2),
                  _buildTimeRangeChip('연간', 'year'),
                  const SizedBox(width: DesignTokens.spacing2),
                  _buildTimeRangeChip('전체', 'all'),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 450.ms),

            const SizedBox(height: DesignTokens.spacing6),

            // Chart Section
            const Text(
              '스코어 그래프',
              style: TextStyle(
                fontSize: DesignTokens.fontBase,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
            const SizedBox(height: DesignTokens.spacing3),

            Container(
                  height: 300,
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral0,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: DesignTokens.shadowMd,
                  ),
                  child: scores.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.show_chart,
                                size: 60,
                                color: DesignTokens.neutral300,
                              ),
                              SizedBox(height: DesignTokens.spacing3),
                              Text(
                                '스코어 데이터가 없습니다',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSm,
                                  color: DesignTokens.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ScoreTrendChart(
                          scores: scores,
                          timeRange: _selectedTimeRange,
                        ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 550.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing6),

            // Score Distribution
            const Text(
              '스코어 분포',
              style: TextStyle(
                fontSize: DesignTokens.fontBase,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
            const SizedBox(height: DesignTokens.spacing3),

            Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral0,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: DesignTokens.shadowMd,
                  ),
                  child: Column(
                    children: [
                      _buildDistributionBar(
                        '우수 (70대)',
                        _countByRange(scores, 70, 79),
                        totalRounds,
                        DesignTokens.success,
                      ),
                      const SizedBox(height: DesignTokens.spacing3),
                      _buildDistributionBar(
                        '양호 (80대)',
                        _countByRange(scores, 80, 89),
                        totalRounds,
                        const Color(0xFF34D399),
                      ),
                      const SizedBox(height: DesignTokens.spacing3),
                      _buildDistributionBar(
                        '보통 (90대)',
                        _countByRange(scores, 90, 99),
                        totalRounds,
                        DesignTokens.warning,
                      ),
                      const SizedBox(height: DesignTokens.spacing3),
                      _buildDistributionBar(
                        '아쉬움 (100+)',
                        _countByRange(scores, 100, 200),
                        totalRounds,
                        DesignTokens.error,
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 650.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Gradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DesignTokens.neutral0.withOpacity(0.8), size: 24),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            value,
            style: const TextStyle(
              fontSize: DesignTokens.font2xl,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.neutral0,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing1),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontXs,
              color: DesignTokens.neutral0.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeChip(String label, String value) {
    final isActive = _selectedTimeRange == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeRange = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing4,
          vertical: DesignTokens.spacing2,
        ),
        decoration: BoxDecoration(
          color: isActive ? DesignTokens.primary600 : DesignTokens.neutral0,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: isActive ? DesignTokens.primary600 : DesignTokens.neutral200,
          ),
          boxShadow: isActive ? DesignTokens.shadowSm : null,
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

  Widget _buildDistributionBar(
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
              ),
            ),
            Text(
              '$count회 (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: DesignTokens.fontSm,
                fontWeight: DesignTokens.fontSemibold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacing2),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: DesignTokens.neutral100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  int _countByRange(List scores, int min, int max) {
    return scores
        .where((s) => s.totalScore >= min && s.totalScore <= max)
        .length;
  }
}
