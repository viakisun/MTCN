import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/player.dart';
import 'avatar.dart';

class PlayerDetailSheet extends StatelessWidget {
  final Player player;

  const PlayerDetailSheet({super.key, required this.player});

  String _getTierName(PlayerTier? tier) {
    switch (tier) {
      case PlayerTier.pro:
        return '프로급';
      case PlayerTier.expert:
        return '전문가';
      case PlayerTier.intermediate:
        return '중급자';
      case PlayerTier.beginner:
        return '초보자';
      case null:
        return '미분류';
    }
  }

  PlayerTier _getTier() {
    final handicap = player.handicap;
    if (handicap <= 5) return PlayerTier.pro;
    if (handicap <= 12) return PlayerTier.expert;
    if (handicap <= 20) return PlayerTier.intermediate;
    return PlayerTier.beginner;
  }

  @override
  Widget build(BuildContext context) {
    final tier = _getTier();
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
      decoration: const BoxDecoration(
        color: DesignTokens.surfacePrimary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radius3xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: DesignTokens.spacing3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: DesignTokens.neutral300,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
          ),

          // Header with avatar and name
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacing6),
            child: Column(
              children: [
                Avatar(
                  name: player.name,
                  imageUrl: player.avatar,
                  size: AvatarSize.xxLarge,
                  player: player,
                  showBorder: true,
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: DesignTokens.font2xl,
                    fontWeight: DesignTokens.fontBold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing3,
                    vertical: DesignTokens.spacing1,
                  ),
                  decoration: BoxDecoration(
                    gradient: tier == PlayerTier.pro
                        ? const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          )
                        : tier == PlayerTier.expert
                        ? const LinearGradient(
                            colors: [Color(0xFFC0C0C0), Color(0xFFE0E0E0)],
                          )
                        : tier == PlayerTier.intermediate
                        ? const LinearGradient(
                            colors: [Color(0xFFCD7F32), Color(0xFFE6A85C)],
                          )
                        : null,
                    color: tier == PlayerTier.beginner
                        ? DesignTokens.neutral200
                        : null,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusFull,
                    ),
                  ),
                  child: Text(
                    _getTierName(tier),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontSemibold,
                      color: tier == PlayerTier.beginner
                          ? DesignTokens.textSecondary
                          : DesignTokens.neutral900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats grid
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing6,
            ),
            padding: const EdgeInsets.all(DesignTokens.spacing5),
            decoration: BoxDecoration(
              color: DesignTokens.surfaceSecondary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        '평균 스코어',
                        player.averageScore.toString(),
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing4),
                    Expanded(
                      child: _buildStatItem(
                        '베스트 스코어',
                        player.bestScore.toString(),
                        Icons.emoji_events,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        '핸디캡',
                        player.handicap.toString(),
                        Icons.golf_course,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing4),
                    Expanded(
                      child: _buildStatItem(
                        '레벨',
                        _getTierName(tier),
                        Icons.star,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Recent achievements (if any)
          if (player.bestScore < 80)
            Container(
              margin: const EdgeInsets.all(DesignTokens.spacing6),
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: BoxDecoration(
                gradient: DesignTokens.gradientAccent,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                boxShadow: DesignTokens.shadowMd,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.celebration,
                    color: DesignTokens.neutral0,
                    size: 24,
                  ),
                  const SizedBox(width: DesignTokens.spacing3),
                  Expanded(
                    child: Text(
                      '베스트 스코어 ${player.bestScore}타 달성!',
                      style: const TextStyle(
                        color: DesignTokens.neutral0,
                        fontSize: DesignTokens.fontBase,
                        fontWeight: DesignTokens.fontSemibold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: DesignTokens.spacing6),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing3),
      decoration: BoxDecoration(
        color: DesignTokens.surfacePrimary,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: DesignTokens.primary600),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            value,
            style: const TextStyle(
              fontSize: DesignTokens.fontXl,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.textPrimary,
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
      ),
    );
  }
}
