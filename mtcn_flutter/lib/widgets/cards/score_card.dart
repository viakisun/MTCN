import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/score_record.dart';
import '../../screens/score/score_detail_page.dart';
import '../common/avatar.dart';
import '../common/badge.dart' as custom;

class ScoreCard extends StatelessWidget {
  final ScoreRecord score;
  final VoidCallback? onTap;

  const ScoreCard({super.key, required this.score, this.onTap});

  custom.BadgeVariant get _qualityBadgeVariant {
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

  String get _qualityText {
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

  Color get _scoreColor {
    final diff = score.scoreToPar;
    if (diff <= 0) return DesignTokens.success;
    if (diff <= 5) return DesignTokens.warning;
    return DesignTokens.error;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy.MM.dd').format(score.date);

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScoreDetailPage(score: score),
              ),
            );
          },
      child: Container(
        margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        decoration: BoxDecoration(
          color: DesignTokens.neutral0,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
          boxShadow: DesignTokens.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with player info
            Row(
              children: [
                Avatar(
                  imageUrl: score.player.avatar,
                  name: score.player.name,
                  size: AvatarSize.medium,
                ),
                const SizedBox(width: DesignTokens.spacing3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        score.player.name,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontLg,
                          fontWeight: DesignTokens.fontSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing1 / 2),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                custom.Badge(text: _qualityText, variant: _qualityBadgeVariant),
              ],
            ),

            const SizedBox(height: DesignTokens.spacing3),

            // Course name
            Row(
              children: [
                const Icon(
                  Icons.golf_course,
                  size: 16,
                  color: DesignTokens.textSecondary,
                ),
                const SizedBox(width: DesignTokens.spacing1),
                Text(
                  score.courseName,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacing3),

            // Score details
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacing3),
              decoration: BoxDecoration(
                color: DesignTokens.neutral50,
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreItem(
                    label: '총 타수',
                    value: score.totalScore.toString(),
                    color: DesignTokens.textPrimary,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: DesignTokens.neutral200,
                  ),
                  _buildScoreItem(
                    label: 'Par',
                    value: score.par.toString(),
                    color: DesignTokens.textSecondary,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: DesignTokens.neutral200,
                  ),
                  _buildScoreItem(
                    label: '대비',
                    value: score.scoreToPar >= 0
                        ? '+${score.scoreToPar}'
                        : score.scoreToPar.toString(),
                    color: _scoreColor,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: DesignTokens.neutral200,
                  ),
                  _buildScoreItem(
                    label: '핸디캡',
                    value: score.handicap.toString(),
                    color: DesignTokens.textSecondary,
                  ),
                ],
              ),
            ),

            // Notes if available
            if (score.notes != null && score.notes!.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacing3),
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacing3),
                decoration: BoxDecoration(
                  color: DesignTokens.primary50,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  border: Border.all(color: DesignTokens.primary200, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.note,
                      size: 16,
                      color: DesignTokens.primary600,
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    Expanded(
                      child: Text(
                        score.notes!,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: DesignTokens.textTertiary,
          ),
        ),
        const SizedBox(height: DesignTokens.spacing1),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontLg,
            fontWeight: DesignTokens.fontBold,
            color: color,
          ),
        ),
      ],
    );
  }
}
