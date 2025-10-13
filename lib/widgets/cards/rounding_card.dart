import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';
import '../../screens/rounding/rounding_detail_page.dart';
import '../common/avatar.dart';

class RoundingCard extends StatelessWidget {
  final Rounding rounding;
  final VoidCallback? onTap;

  const RoundingCard({super.key, required this.rounding, this.onTap});

  String get _statusText {
    switch (rounding.status) {
      case RoundingStatus.upcoming:
        return '예정';
      case RoundingStatus.inProgress:
        return '진행중';
      case RoundingStatus.completed:
        return '완료';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoundingDetailPage(rounding: rounding),
              ),
            );
          },
      child: Container(
        margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
        decoration: BoxDecoration(
          color: DesignTokens.neutral0,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
          boxShadow: DesignTokens.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: const BoxDecoration(
                gradient: DesignTokens.gradientTerracotta,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(DesignTokens.radiusXl),
                  topRight: Radius.circular(DesignTokens.radiusXl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          rounding.groupName,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontXl,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.neutral0,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing2,
                          vertical: DesignTokens.spacing1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusFull,
                          ),
                        ),
                        child: Text(
                          _statusText,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontXs,
                            fontWeight: DesignTokens.fontMedium,
                            color: DesignTokens.neutral0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    rounding.eventName,
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontMedium,
                      color: DesignTokens.neutral0.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing1 / 2),
                  Text(
                    rounding.courseName,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      color: DesignTokens.neutral0.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and Time
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacing1),
                      Text(
                        '${rounding.date} ${rounding.time}',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      const Icon(
                        Icons.flag,
                        size: 16,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacing1),
                      Text(
                        '${rounding.holes} 홀',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignTokens.spacing3),

                  // Weather and Green Fee
                  Row(
                    children: [
                      Icon(
                        _getWeatherIcon(rounding.weather),
                        size: 16,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacing1),
                      Text(
                        '${rounding.weather} ${rounding.temperature}°C',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      const Icon(
                        Icons.attach_money,
                        size: 16,
                        color: DesignTokens.textSecondary,
                      ),
                      Text(
                        '${_formatNumber(rounding.greenFee)}원',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignTokens.spacing3),

                  // Players
                  Row(
                    children: [
                      const Text(
                        '참가자',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontMedium,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: Stack(
                            children: [
                              for (
                                var i = 0;
                                i < rounding.players.length && i < 4;
                                i++
                              )
                                Positioned(
                                  left: i * 24.0,
                                  child: Avatar(
                                    imageUrl: rounding.players[i].avatar,
                                    name: rounding.players[i].name,
                                    size: AvatarSize.small,
                                    showBorder: true,
                                  ),
                                ),
                              if (rounding.players.length > 4)
                                Positioned(
                                  left: 4 * 24.0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: DesignTokens.neutral200,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: DesignTokens.neutral0,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+${rounding.players.length - 4}',
                                        style: const TextStyle(
                                          fontSize: DesignTokens.fontXs,
                                          fontWeight: DesignTokens.fontMedium,
                                          color: DesignTokens.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather) {
      case '맑음':
        return Icons.wb_sunny;
      case '구름':
        return Icons.cloud;
      case '흐림':
        return Icons.cloud_queue;
      case '비':
        return Icons.water_drop;
      case '눈':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
