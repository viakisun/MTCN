import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/enums/group_enums.dart';
import '../../data/models/group.dart';
// import '../../screens/groups/group_detail_page.dart'; // 파일이 존재하지 않음
import '../common/avatar.dart';
import '../common/badge.dart' as custom;
import '../common/player_detail_sheet.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;

  const GroupCard({super.key, required this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            // TODO: GroupDetailPage 구현 후 네비게이션 활성화
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${group.name} 상세 페이지는 준비 중입니다'),
                duration: const Duration(seconds: 2),
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: DesignTokens.gradientGold,
                          borderRadius: BorderRadius.all(
                            Radius.circular(DesignTokens.radiusLg),
                          ),
                        ),
                        child: const Icon(
                          Icons.groups,
                          color: DesignTokens.neutral0,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: DesignTokens.fontLg,
                                fontWeight: DesignTokens.fontSemibold,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacing1 / 2),
                            Row(
                              children: [
                                Text(
                                  '${group.members.length}명',
                                  style: const TextStyle(
                                    fontSize: DesignTokens.fontSm,
                                    color: DesignTokens.textSecondary,
                                  ),
                                ),
                                if (group.sizeTier == GroupSizeTier.mega ||
                                    group.sizeTier == GroupSizeTier.large) ...[
                                  const SizedBox(width: DesignTokens.spacing2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DesignTokens.spacing2,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient:
                                          group.sizeTier == GroupSizeTier.mega
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFFFD700),
                                                Color(0xFFFFA500),
                                              ],
                                            )
                                          : DesignTokens.gradientSecondary,
                                      borderRadius: BorderRadius.circular(
                                        DesignTokens.radiusFull,
                                      ),
                                    ),
                                    child: Text(
                                      group.sizeLabel,
                                      style: const TextStyle(
                                        fontSize: DesignTokens.fontXs,
                                        fontWeight: DesignTokens.fontSemibold,
                                        color: DesignTokens.neutral0,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (group.isPremium) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing3,
                          vertical: DesignTokens.spacing1,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusFull,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFD700,
                              ).withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.workspace_premium,
                              size: 14,
                              color: DesignTokens.neutral0,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'PREMIUM',
                              style: TextStyle(
                                fontSize: DesignTokens.fontXs,
                                fontWeight: DesignTokens.fontBold,
                                color: DesignTokens.neutral0,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing1),
                    ],
                    custom.Badge(
                      text: group.status == GroupStatus.active ? '활성' : '비활성',
                      variant: group.status == GroupStatus.active
                          ? custom.BadgeVariant.success
                          : custom.BadgeVariant.info,
                    ),
                    if (group.isNew) ...[
                      const SizedBox(height: DesignTokens.spacing1),
                      const custom.Badge(
                        text: 'NEW',
                        variant: custom.BadgeVariant.primary,
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacing3),

            // Description
            Text(
              group.description,
              style: const TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: DesignTokens.spacing3),

            // Members
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Text(
                    '멤버',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontMedium,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Expanded(
                    child: Stack(
                      children: [
                        for (var i = 0; i < group.members.length && i < 5; i++)
                          Positioned(
                            left: i * 28.0,
                            child: Avatar(
                              imageUrl: group.members[i].player.avatar,
                              name: group.members[i].player.name,
                              size: AvatarSize.medium,
                              showBorder: true,
                              player: group.members[i].player,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) => PlayerDetailSheet(
                                    player: group.members[i].player,
                                  ),
                                );
                              },
                            ),
                          ),
                        if (group.members.length > 5)
                          Positioned(
                            left: 5 * 28.0,
                            child: Container(
                              width: 40,
                              height: 40,
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
                                  '+${group.members.length - 5}',
                                  style: const TextStyle(
                                    fontSize: DesignTokens.fontSm,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
