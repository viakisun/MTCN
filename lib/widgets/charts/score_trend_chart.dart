import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/score_record.dart';

class ScoreTrendChart extends StatelessWidget {
  final List<ScoreRecord> scores;
  final String timeRange; // 'week', 'month', 'year', 'all'

  const ScoreTrendChart({
    super.key,
    required this.scores,
    this.timeRange = 'month',
  });

  List<ScoreRecord> get filteredScores {
    if (scores.isEmpty) return [];

    final now = DateTime.now();
    DateTime cutoffDate = DateTime.now();

    switch (timeRange) {
      case 'week':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case 'year':
        cutoffDate = now.subtract(const Duration(days: 365));
        break;
      case 'all':
        cutoffDate = DateTime(1900); // Very old date to include all
        break;
    }

    return scores.where((score) {
      return score.date.isAfter(cutoffDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredScores;

    if (data.isEmpty) {
      return const Center(
        child: Text(
          '데이터가 없습니다',
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
            color: DesignTokens.textSecondary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: DesignTokens.spacing2),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: DesignTokens.neutral200,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= data.length) {
                    return const Text('');
                  }

                  final score = data[value.toInt()];
                  final date = score.date;

                  // Show month/day for recent scores
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.month}/${date.day}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: DesignTokens.textTertiary,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: DesignTokens.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: DesignTokens.neutral200),
              bottom: BorderSide(color: DesignTokens.neutral200),
            ),
          ),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY:
              (data.map((s) => s.totalScore).reduce((a, b) => a < b ? a : b) -
                      10)
                  .toDouble(),
          maxY:
              (data.map((s) => s.totalScore).reduce((a, b) => a > b ? a : b) +
                      10)
                  .toDouble(),
          lineBarsData: [
            // Score line
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.totalScore.toDouble(),
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  DesignTokens.primary600.withValues(alpha: 0.8),
                  DesignTokens.primary400,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final score = data[index];
                  final color = _getScoreColor(score.totalScore, score.par);

                  return FlDotCirclePainter(
                    radius: 5,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: DesignTokens.neutral0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    DesignTokens.primary600.withValues(alpha: 0.15),
                    DesignTokens.primary400.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Par reference line
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.par.toDouble());
              }).toList(),
              isCurved: false,
              color: DesignTokens.textTertiary.withValues(alpha: 0.3),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              dashArray: [8, 4],
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  DesignTokens.neutral800.withValues(alpha: 0.9),
              tooltipRoundedRadius: DesignTokens.radiusMd,
              tooltipPadding: const EdgeInsets.all(DesignTokens.spacing2),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  if (touchedSpot.barIndex != 0) return null;

                  final score = data[touchedSpot.x.toInt()];
                  final date = score.date;
                  final scoreToPar = score.totalScore - score.par;

                  return LineTooltipItem(
                    '${date.month}/${date.day}\n',
                    const TextStyle(
                      fontSize: DesignTokens.fontXs,
                      color: DesignTokens.neutral300,
                    ),
                    children: [
                      TextSpan(
                        text: '${score.totalScore}타 ',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                      TextSpan(
                        text: '(${scoreToPar >= 0 ? '+' : ''}$scoreToPar)',
                        style: TextStyle(
                          fontSize: DesignTokens.fontXs,
                          color: _getScoreColor(score.totalScore, score.par),
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: DesignTokens.primary600.withValues(alpha: 0.5),
                        strokeWidth: 2,
                        dashArray: [5, 5],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: DesignTokens.primary600,
                            strokeWidth: 3,
                            strokeColor: DesignTokens.neutral0,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
          ),
        ),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  Color _getScoreColor(int score, int par) {
    final diff = score - par;
    if (diff <= -3) return DesignTokens.success;
    if (diff < 0) return const Color(0xFF34D399);
    if (diff == 0) return DesignTokens.textPrimary;
    if (diff <= 3) return DesignTokens.warning;
    return DesignTokens.error;
  }
}
