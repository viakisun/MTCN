import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/score_record.dart';
import '../../widgets/common/avatar.dart';
import '../../widgets/common/badge.dart' as custom;
import '../../widgets/cards/ai_insights_card.dart';

class ScoreDetailPage extends ConsumerWidget {
  final ScoreRecord score;

  const ScoreDetailPage({super.key, required this.score});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat(
      'yyyy년 M월 d일 (E)',
      'ko_KR',
    ).format(score.date);

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
          '스코어 상세',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: DesignTokens.textPrimary,
              size: 20,
            ),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Info Card
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: BoxDecoration(
                color: DesignTokens.neutral0,
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                boxShadow: DesignTokens.shadowMd,
              ),
              child: Row(
                children: [
                  Avatar(
                    imageUrl: score.player.avatar,
                    name: score.player.name,
                    size: AvatarSize.large,
                  ),
                  const SizedBox(width: DesignTokens.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          score.player.name,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontXl,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing1),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontSm,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing1),
                        Text(
                          score.courseName,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontSm,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  custom.Badge(
                    text: _getQualityText(),
                    variant: _getQualityBadgeVariant(),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing4),

            // Score Summary Card
            Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    gradient: _getGradient(),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: DesignTokens.shadowLg,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScoreStat(
                            label: '총 타수',
                            value: score.totalScore.toString(),
                            color: DesignTokens.neutral0,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildScoreStat(
                            label: 'Par',
                            value: score.par.toString(),
                            color: DesignTokens.neutral0,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildScoreStat(
                            label: '대비',
                            value: score.scoreToPar >= 0
                                ? '+${score.scoreToPar}'
                                : score.scoreToPar.toString(),
                            color: DesignTokens.neutral0,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 100.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing4),

            // Statistics Card
            if (score.holeScores != null && score.holeScores!.isNotEmpty) ...[
              Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing4),
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
                      boxShadow: DesignTokens.shadowMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '스코어 분석',
                          style: TextStyle(
                            fontSize: DesignTokens.fontLg,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing4),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                '이글',
                                '0',
                                DesignTokens.success,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                '버디',
                                '${_countBirdies()}',
                                DesignTokens.info,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                '파',
                                '${_countPars()}',
                                DesignTokens.textSecondary,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                '보기',
                                '${_countBogeys()}',
                                DesignTokens.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 150.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: DesignTokens.spacing4),

              // AI Insights Card
              AIInsightsCard(
                totalScore: score.totalScore,
                averageScore: score.player.averageScore,
                bestScore: score.player.bestScore,
                birdies: _countBirdies(),
                pars: _countPars(),
                bogeys: _countBogeys(),
              ),

              const SizedBox(height: DesignTokens.spacing4),
            ],

            // Hole by Hole Scorecard
            if (score.holeScores != null && score.holeScores!.isNotEmpty) ...[
              Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing4),
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
                      boxShadow: DesignTokens.shadowMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '홀별 스코어',
                          style: TextStyle(
                            fontSize: DesignTokens.fontLg,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing3),
                        _buildScorecardTable(),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
            ],

            // Notes if available
            if (score.notes != null && score.notes!.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacing4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                decoration: BoxDecoration(
                  color: DesignTokens.primary50,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                  border: Border.all(color: DesignTokens.primary200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.note,
                          size: 20,
                          color: DesignTokens.primary600,
                        ),
                        SizedBox(width: DesignTokens.spacing2),
                        Text(
                          '메모',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: DesignTokens.primary600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    Text(
                      score.notes!,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 250.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontXs,
            color: color.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: DesignTokens.spacing1),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.font2xl,
            fontWeight: DesignTokens.fontBold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontXl,
            fontWeight: DesignTokens.fontBold,
            color: color,
          ),
        ),
        const SizedBox(height: DesignTokens.spacing1),
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: DesignTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildScorecardTable() {
    // Standard 18-hole course par values
    final parValues = [
      4, 5, 3, 4, 4, 5, 3, 4, 4, // Front 9 (par 36)
      4, 4, 5, 3, 4, 4, 5, 3, 4, // Back 9 (par 36)
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Front 9
          DataTable(
            headingRowHeight: 40,
            dataRowHeight: 40,
            columnSpacing: 20,
            headingTextStyle: const TextStyle(
              fontSize: DesignTokens.fontXs,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textSecondary,
            ),
            dataTextStyle: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textPrimary,
            ),
            columns: [
              const DataColumn(label: Text('홀')),
              ...List.generate(9, (i) => DataColumn(label: Text('${i + 1}'))),
            ],
            rows: [
              DataRow(
                cells: [
                  const DataCell(Text('Par')),
                  ...List.generate(9, (i) => DataCell(Text('${parValues[i]}'))),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text('스코어')),
                  ...List.generate(9, (i) {
                    if (score.holeScores != null &&
                        i < score.holeScores!.length) {
                      return DataCell(
                        Text(
                          '${score.holeScores![i]}',
                          style: TextStyle(
                            fontWeight: DesignTokens.fontSemibold,
                            color: _getScoreColor(
                              score.holeScores![i],
                              parValues[i],
                            ),
                          ),
                        ),
                      );
                    }
                    return const DataCell(Text('-'));
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing3),
          // Back 9
          DataTable(
            headingRowHeight: 40,
            dataRowHeight: 40,
            columnSpacing: 20,
            headingTextStyle: const TextStyle(
              fontSize: DesignTokens.fontXs,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textSecondary,
            ),
            dataTextStyle: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textPrimary,
            ),
            columns: [
              const DataColumn(label: Text('홀')),
              ...List.generate(9, (i) => DataColumn(label: Text('${i + 10}'))),
            ],
            rows: [
              DataRow(
                cells: [
                  const DataCell(Text('Par')),
                  ...List.generate(
                    9,
                    (i) => DataCell(Text('${parValues[i + 9]}')),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text('스코어')),
                  ...List.generate(9, (i) {
                    final holeIndex = i + 9;
                    if (score.holeScores != null &&
                        holeIndex < score.holeScores!.length) {
                      return DataCell(
                        Text(
                          '${score.holeScores![holeIndex]}',
                          style: TextStyle(
                            fontWeight: DesignTokens.fontSemibold,
                            color: _getScoreColor(
                              score.holeScores![holeIndex],
                              parValues[holeIndex],
                            ),
                          ),
                        ),
                      );
                    }
                    return const DataCell(Text('-'));
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score, int par) {
    if (score < par) return DesignTokens.success;
    if (score == par) return DesignTokens.textPrimary;
    if (score == par + 1) return DesignTokens.warning;
    return DesignTokens.error;
  }

  int _countBirdies() {
    if (score.holeScores == null) return 0;
    final parValues = [4, 5, 3, 4, 4, 5, 3, 4, 4, 4, 4, 5, 3, 4, 4, 5, 3, 4];
    int count = 0;
    for (int i = 0; i < score.holeScores!.length && i < parValues.length; i++) {
      if (score.holeScores![i] == parValues[i] - 1) count++;
    }
    return count;
  }

  int _countPars() {
    if (score.holeScores == null) return 0;
    final parValues = [4, 5, 3, 4, 4, 5, 3, 4, 4, 4, 4, 5, 3, 4, 4, 5, 3, 4];
    int count = 0;
    for (int i = 0; i < score.holeScores!.length && i < parValues.length; i++) {
      if (score.holeScores![i] == parValues[i]) count++;
    }
    return count;
  }

  int _countBogeys() {
    if (score.holeScores == null) return 0;
    final parValues = [4, 5, 3, 4, 4, 5, 3, 4, 4, 4, 4, 5, 3, 4, 4, 5, 3, 4];
    int count = 0;
    for (int i = 0; i < score.holeScores!.length && i < parValues.length; i++) {
      if (score.holeScores![i] == parValues[i] + 1) count++;
    }
    return count;
  }

  LinearGradient _getGradient() {
    switch (score.quality) {
      case ScoreQuality.excellent:
        return DesignTokens.gradientEucalyptus;
      case ScoreQuality.good:
        return DesignTokens.gradientSky;
      case ScoreQuality.average:
        return DesignTokens.gradientGold;
      case ScoreQuality.poor:
        return DesignTokens.gradientTerracotta;
    }
  }

  custom.BadgeVariant _getQualityBadgeVariant() {
    switch (score.quality) {
      case ScoreQuality.excellent:
        return custom.BadgeVariant.success;
      case ScoreQuality.good:
        return custom.BadgeVariant.info;
      case ScoreQuality.average:
        return custom.BadgeVariant.warning;
      case ScoreQuality.poor:
        return custom.BadgeVariant.error;
    }
  }

  String _getQualityText() {
    switch (score.quality) {
      case ScoreQuality.excellent:
        return '우수';
      case ScoreQuality.good:
        return '양호';
      case ScoreQuality.average:
        return '보통';
      case ScoreQuality.poor:
        return '아쉬움';
    }
  }
}
