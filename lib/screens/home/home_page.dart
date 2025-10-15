import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../providers/mock_data_provider.dart';
import '../../widgets/cards/score_card.dart';
import '../../widgets/cards/group_card.dart';
import '../../widgets/common/avatar.dart';
import '../../widgets/common/player_detail_sheet.dart';
import '../../widgets/common/achievement_celebration.dart';
import '../../services/achievement_demo_service.dart';
import '../rounding/rounding_detail_page.dart';
import '../rounding/create_rounding_page.dart';
import '../../models/rounding.dart';
import '../../data/models/group.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();
    // Start demo timer for achievements
    _demoTimer = AchievementDemoService.startDemoTimer((achievement) {
      if (mounted) {
        showAchievementCelebration(context, achievement);
      }
    });
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    super.dispose();
  }

  int _calculateDDay(String dateString) {
    try {
      final targetDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final target = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final difference = target.difference(today);
      return difference.inDays;
    } catch (e) {
      return 0;
    }
  }

  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      return '$hour:$minute';
    } catch (e) {
      return timeString;
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    ref.invalidate(myInProgressRoundingProvider);
    ref.invalidate(othersInProgressRoundingsProvider);
    ref.invalidate(myUpcomingRoundingsProvider);
    ref.invalidate(recentScoresProvider);
    ref.invalidate(activeGroupsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final myInProgress = ref.watch(myInProgressRoundingProvider);
    final othersInProgress = ref.watch(othersInProgressRoundingsProvider);
    final myUpcoming = ref.watch(myUpcomingRoundingsProvider);
    final recentScores = ref.watch(recentScoresProvider);
    final activeGroups = ref.watch(activeGroupsProvider);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'home_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoundingPage()),
          );
        },
        backgroundColor: DesignTokens.primary600,
        icon: const Icon(Icons.add, color: DesignTokens.neutral0),
        label: const Text(
          '새 라운딩',
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.neutral0,
          ),
        ),
      ),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.home, color: DesignTokens.primary600, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '홈',
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
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: DesignTokens.primary600,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 내가 참여 중인 라운딩 (최우선 강조)
              if (myInProgress != null) ...[
                _buildMyInProgressSection(context, myInProgress),
                const SizedBox(height: DesignTokens.spacing6),
              ],

              // 2. 동문들이 참여 중인 라운딩
              if (othersInProgress.isNotEmpty) ...[
                _buildOthersInProgressSection(context, othersInProgress),
                const SizedBox(height: DesignTokens.spacing6),
              ],

              // 3. 예정된 라운딩 (내가 참가 예정)
              if (myUpcoming.isNotEmpty) ...[
                _buildMyUpcomingSection(context, myUpcoming),
                const SizedBox(height: DesignTokens.spacing6),
              ],

              // Empty state - 라운딩이 없을 때
              if (myInProgress == null && myUpcoming.isEmpty) ...[
                _buildEmptyRoundingState(context),
                const SizedBox(height: DesignTokens.spacing6),
              ],

              // 4. 활동 중인 동문회
              if (activeGroups.isNotEmpty) ...[
                _buildActiveGroupsSection(context, activeGroups),
                const SizedBox(height: DesignTokens.spacing6),
              ],

              // 5. 최근 스코어 (간단히)
              if (recentScores.isNotEmpty) ...[
                _buildRecentScoreSection(context, recentScores.first),
                const SizedBox(height: DesignTokens.spacing6),
              ],

              // Bottom padding for FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. 내가 참여 중인 라운딩 (Live - 최우선 강조)
  Widget _buildMyInProgressSection(BuildContext context, Rounding rounding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.circle, size: 8, color: DesignTokens.error),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '진행 중',
              style: TextStyle(
                fontSize: DesignTokens.fontXl,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacing3),
        GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoundingDetailPage(rounding: rounding),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacing5),
                decoration: BoxDecoration(
                  gradient: DesignTokens.gradientPrimary,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                  boxShadow: DesignTokens.shadowPrimary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacing3,
                                vertical: DesignTokens.spacing1,
                              ),
                              decoration: BoxDecoration(
                                color: DesignTokens.error,
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.radiusFull,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: DesignTokens.neutral0,
                                  ),
                                  SizedBox(width: DesignTokens.spacing1),
                                  Text(
                                    'LIVE',
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontXs,
                                      fontWeight: DesignTokens.fontBold,
                                      color: DesignTokens.neutral0,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${rounding.currentHole ?? 0}/${rounding.totalHoles ?? 18}홀',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                fontWeight: DesignTokens.fontSemibold,
                                color: DesignTokens.neutral0,
                              ),
                            ),
                          ],
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .fadeIn(duration: 1000.ms)
                        .then()
                        .fadeOut(duration: 1000.ms),
                    const SizedBox(height: DesignTokens.spacing3),
                    Text(
                      rounding.eventName,
                      style: const TextStyle(
                        fontSize: DesignTokens.font2xl,
                        fontWeight: DesignTokens.fontBold,
                        color: DesignTokens.neutral0,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: DesignTokens.neutral0,
                        ),
                        const SizedBox(width: DesignTokens.spacing1),
                        Text(
                          rounding.courseName,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontBase,
                            color: DesignTokens.neutral0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                    Row(
                      children: [
                        ...rounding.players
                            .take(4)
                            .map(
                              (player) => Padding(
                                padding: const EdgeInsets.only(
                                  right: DesignTokens.spacing2,
                                ),
                                child: Avatar(
                                  imageUrl: player.avatar,
                                  name: player.name,
                                  size: AvatarSize.small,
                                  player: player,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) =>
                                          PlayerDetailSheet(player: player),
                                    );
                                  },
                                ),
                              ),
                            ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacing4,
                            vertical: DesignTokens.spacing2,
                          ),
                          decoration: BoxDecoration(
                            color: DesignTokens.neutral0,
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusLg,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                '이어하기',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSm,
                                  fontWeight: DesignTokens.fontSemibold,
                                  color: DesignTokens.primary600,
                                ),
                              ),
                              SizedBox(width: DesignTokens.spacing1),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: DesignTokens.primary600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
      ],
    );
  }

  /// 2. 동문들이 참여 중인 라운딩
  Widget _buildOthersInProgressSection(
    BuildContext context,
    List<Rounding> roundings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...roundings.take(2).map((rounding) {
          final playerCount = rounding.players.length;
          final playerNames = rounding.players
              .take(2)
              .map((p) => p.name)
              .join(', ');
          final remaining = playerCount > 2 ? ' 외 ${playerCount - 2}명' : '';

          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoundingDetailPage(rounding: rounding),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                decoration: BoxDecoration(
                  color: DesignTokens.neutral0,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  border: Border.all(color: DesignTokens.primary200, width: 2),
                  boxShadow: DesignTokens.shadowSm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        gradient: DesignTokens.gradientPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.visibility,
                        color: DesignTokens.neutral0,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: DesignTokens.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: DesignTokens.spacing1),
                              Expanded(
                                child: Text(
                                  '$playerNames$remaining 플레이 중',
                                  style: const TextStyle(
                                    fontSize: DesignTokens.fontSm,
                                    fontWeight: DesignTokens.fontSemibold,
                                    color: DesignTokens.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacing1),
                          Text(
                            '${rounding.courseName} • ${rounding.currentHole ?? 0}/${rounding.totalHoles ?? 18}홀',
                            style: const TextStyle(
                              fontSize: DesignTokens.fontXs,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: DesignTokens.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 3. 예정된 라운딩 (내가 참가 예정)
  Widget _buildMyUpcomingSection(
    BuildContext context,
    List<Rounding> roundings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '예정됨',
          style: TextStyle(
            fontSize: DesignTokens.fontXl,
            fontWeight: DesignTokens.fontBold,
            color: DesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: DesignTokens.spacing3),
        ...roundings.take(2).map((rounding) {
          final dDay = _calculateDDay(rounding.date);
          final dDayText = dDay == 0
              ? '오늘'
              : dDay > 0
              ? 'D-$dDay'
              : 'D+${-dDay}';

          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoundingDetailPage(rounding: rounding),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                decoration: BoxDecoration(
                  color: DesignTokens.neutral0,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  boxShadow: DesignTokens.shadowMd,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.spacing3),
                      decoration: BoxDecoration(
                        color: DesignTokens.secondary50,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            dDayText,
                            style: const TextStyle(
                              fontSize: DesignTokens.fontLg,
                              fontWeight: DesignTokens.fontBold,
                              color: DesignTokens.secondary600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rounding.eventName,
                            style: const TextStyle(
                              fontSize: DesignTokens.fontBase,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacing1),
                          Text(
                            '${rounding.courseName} • ${_formatTime(rounding.time)}',
                            style: const TextStyle(
                              fontSize: DesignTokens.fontSm,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ...rounding.players
                            .take(3)
                            .map(
                              (player) => Padding(
                                padding: const EdgeInsets.only(
                                  left: DesignTokens.spacing1,
                                ),
                                child: Avatar(
                                  imageUrl: player.avatar,
                                  name: player.name,
                                  size: AvatarSize.small,
                                  player: player,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) =>
                                          PlayerDetailSheet(player: player),
                                    );
                                  },
                                ),
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Empty state - 라운딩이 없을 때
  Widget _buildEmptyRoundingState(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing6),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            border: Border.all(color: DesignTokens.neutral200, width: 2),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: DesignTokens.primary50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.golf_course,
                  size: 32,
                  color: DesignTokens.primary600,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),
              const Text(
                '동문들과 라운딩을 시작해보세요',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontSemibold,
                  color: DesignTokens.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacing2),
              const Text(
                '새로운 라운딩을 만들거나\n예정된 라운딩에 참가해보세요',
                style: TextStyle(
                  fontSize: DesignTokens.fontSm,
                  color: DesignTokens.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacing5),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateRoundingPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('라운딩 만들기'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DesignTokens.primary600,
                        side: const BorderSide(
                          color: DesignTokens.primary600,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignTokens.spacing3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  /// 4. 활동 중인 동문회
  Widget _buildActiveGroupsSection(BuildContext context, List<Group> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '활동 중인 동문회',
              style: TextStyle(
                fontSize: DesignTokens.fontXl,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to groups page
              },
              child: const Text(
                '모두 보기',
                style: TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontMedium,
                  color: DesignTokens.primary600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacing3),
        ...groups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
            child: GroupCard(group: group)
                .animate()
                .fadeIn(duration: 500.ms, delay: (index * 100).ms)
                .slideY(begin: 0.2, end: 0),
          );
        }),
      ],
    );
  }

  /// 5. 최근 스코어 (간단히)
  Widget _buildRecentScoreSection(BuildContext context, scoreRecord) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '내 최근 스코어',
              style: TextStyle(
                fontSize: DesignTokens.fontXl,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to score page
              },
              child: const Text(
                '전체 보기',
                style: TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontMedium,
                  color: DesignTokens.primary600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacing3),
        ScoreCard(
          score: scoreRecord,
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
