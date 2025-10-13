import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/player.dart';
import '../../widgets/live/cheer_chat_widget.dart';
import '../../widgets/live/gps_tracking_map_widget.dart';
import '../../providers/auth_provider.dart';

// Models
class LiveGroup {
  final String name;
  final int currentHole;
  final int rank;
  final List<LivePlayer> players;

  LiveGroup({
    required this.name,
    required this.currentHole,
    required this.rank,
    required this.players,
  });
}

class LivePlayer {
  final String name;
  final int score; // Relative to par: -1 (birdie), 0 (par), +1 (bogey)
  final String scoreDisplay;

  LivePlayer({
    required this.name,
    required this.score,
    required this.scoreDisplay,
  });
}

class PersonalBest {
  final String category;
  final String playerName;
  final String value;
  final IconData icon;

  PersonalBest({
    required this.category,
    required this.playerName,
    required this.value,
    required this.icon,
  });
}

class LiveNotification {
  final String type; // eagle, longest, nearest
  final String message;
  final String timeAgo;
  final String emoji;
  final Color backgroundColor;

  LiveNotification({
    required this.type,
    required this.message,
    required this.timeAgo,
    required this.emoji,
    required this.backgroundColor,
  });
}

class LiveScorePage extends ConsumerStatefulWidget {
  final String roundingId;
  final String roundingName;
  final String courseName;
  final String date;

  const LiveScorePage({
    super.key,
    required this.roundingId,
    required this.roundingName,
    required this.courseName,
    required this.date,
  });

  @override
  ConsumerState<LiveScorePage> createState() => _LiveScorePageState();
}

class _LiveScorePageState extends ConsumerState<LiveScorePage> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📊 라이브 스코어를 업데이트했습니다!'),
          duration: Duration(seconds: 2),
          backgroundColor: DesignTokens.success,
        ),
      );
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return DesignTokens.neutral300;
    }
  }

  Color _getRankBorderColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return DesignTokens.neutral200;
    }
  }

  Color _getScoreColor(int score) {
    if (score < 0) return DesignTokens.success; // Birdie or better
    if (score == 0) return DesignTokens.neutral600; // Par
    return DesignTokens.error; // Bogey or worse
  }

  List<LiveGroup> _getMockGroups() {
    return [
      LiveGroup(
        name: '1조',
        currentHole: 12,
        rank: 1,
        players: [
          LivePlayer(name: '김회장', score: 3, scoreDisplay: '+3'),
          LivePlayer(name: '박부장', score: -1, scoreDisplay: '-1'),
          LivePlayer(name: '이과장', score: 0, scoreDisplay: 'E'),
          LivePlayer(name: '정대리', score: 2, scoreDisplay: '+2'),
        ],
      ),
      LiveGroup(
        name: '2조',
        currentHole: 11,
        rank: 2,
        players: [
          LivePlayer(name: '최차장', score: 1, scoreDisplay: '+1'),
          LivePlayer(name: '한부장', score: 4, scoreDisplay: '+4'),
          LivePlayer(name: '윤과장', score: 0, scoreDisplay: 'E'),
          LivePlayer(name: '송대리', score: 3, scoreDisplay: '+3'),
        ],
      ),
      LiveGroup(
        name: '3조',
        currentHole: 10,
        rank: 3,
        players: [
          LivePlayer(name: '신차장', score: -2, scoreDisplay: '-2'),
          LivePlayer(name: '구부장', score: 5, scoreDisplay: '+5'),
          LivePlayer(name: '임과장', score: 2, scoreDisplay: '+2'),
          LivePlayer(name: '조대리', score: 0, scoreDisplay: 'E'),
        ],
      ),
    ];
  }

  List<PersonalBest> _getMockPersonalBests() {
    return [
      PersonalBest(
        category: '베스트 스코어',
        playerName: '박부장',
        value: '(-1)',
        icon: Icons.emoji_events,
      ),
      PersonalBest(
        category: '이글 달성',
        playerName: '신차장',
        value: '(7번홀)',
        icon: Icons.golf_course,
      ),
      PersonalBest(
        category: '롱기스트',
        playerName: '김회장',
        value: '(285y)',
        icon: Icons.trending_up,
      ),
      PersonalBest(
        category: '니어리스트',
        playerName: '이과장',
        value: '(1.2m)',
        icon: Icons.my_location,
      ),
    ];
  }

  List<LiveNotification> _getMockNotifications() {
    return [
      LiveNotification(
        type: 'eagle',
        message: '신차장님이 7번홀에서 이글을 달성했습니다!',
        timeAgo: '3분 전',
        emoji: '🦅',
        backgroundColor: const Color(0xFFD4F4DD),
      ),
      LiveNotification(
        type: 'longest',
        message: '김회장님이 롱기스트 기록을 갱신했습니다! (285야드)',
        timeAgo: '7분 전',
        emoji: '🏌️‍♂️',
        backgroundColor: const Color(0xFFE8F5E9),
      ),
      LiveNotification(
        type: 'nearest',
        message: '이과장님이 니어리스트 1위를 차지했습니다! (1.2m)',
        timeAgo: '12분 전',
        emoji: '⛳',
        backgroundColor: const Color(0xFFE8F5E9),
      ),
    ];
  }

  void _showCheerChat(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인이 필요합니다')));
      return;
    }

    // Get all players from groups
    final groups = _getMockGroups();
    final allPlayers = groups
        .expand(
          (group) => group.players.map(
            (livePlayer) => Player(
              id: 'player_${livePlayer.name}',
              name: livePlayer.name,
              firstName: livePlayer.name.substring(0, 1),
              lastName: livePlayer.name.substring(1),
              avatar: '',
              handicap: 0,
              averageScore: 90,
              bestScore: 85,
            ),
          ),
        )
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheerChatWidget(
        roundingId: widget.roundingId,
        currentUser: currentUser,
        players: allPlayers,
        currentHole: groups.isNotEmpty ? groups.first.currentHole : null,
      ),
    );
  }

  void _showGpsTracking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GpsTrackingMapWidget(
        roundingId: widget.roundingId,
        playerName: widget.roundingName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _getMockGroups();
    final personalBests = _getMockPersonalBests();
    final notifications = _getMockNotifications();
    final currentTime = TimeOfDay.now().format(context);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.live_tv, color: DesignTokens.success, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '라이브 스코어',
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
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        DesignTokens.primary600,
                      ),
                    ),
                  )
                : const Icon(Icons.refresh, color: DesignTokens.primary600),
            onPressed: _isRefreshing ? null : _handleRefresh,
          ),
        ],
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
              // Live Round Info Header
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacing5),
                decoration: BoxDecoration(
                  gradient: DesignTokens.gradientEucalyptus,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                  boxShadow: DesignTokens.shadowMd,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .fadeOut(duration: 1000.ms)
                            .then()
                            .fadeIn(duration: 1000.ms),
                        const SizedBox(width: DesignTokens.spacing2),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    Text(
                      widget.roundingName,
                      style: const TextStyle(
                        fontSize: DesignTokens.font2xl,
                        fontWeight: DesignTokens.fontBold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing1),
                    Text(
                      '${widget.courseName} • ${widget.date} • 현재 $currentTime',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing3),
                    ElevatedButton.icon(
                      onPressed: () => _showGpsTracking(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: DesignTokens.primary600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing4,
                          vertical: DesignTokens.spacing2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusFull,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.my_location, size: 18),
                      label: const Text(
                        'GPS 트래킹 보기',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontSemibold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing6),

              // Real-time Leaderboard
              const Text(
                '🏆 실시간 순위',
                style: TextStyle(
                  fontSize: DesignTokens.fontXl,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),

              ...groups.asMap().entries.map((entry) {
                final index = entry.key;
                final group = entry.value;

                return Container(
                      margin: const EdgeInsets.only(
                        bottom: DesignTokens.spacing3,
                      ),
                      padding: const EdgeInsets.all(DesignTokens.spacing4),
                      decoration: BoxDecoration(
                        color: DesignTokens.neutral0,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusXl,
                        ),
                        border: Border(
                          left: BorderSide(
                            color: _getRankBorderColor(group.rank),
                            width: 4,
                          ),
                        ),
                        boxShadow: DesignTokens.shadowSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${group.name} (${group.currentHole}홀 진행 중)',
                                      style: const TextStyle(
                                        fontSize: DesignTokens.fontLg,
                                        fontWeight: DesignTokens.fontBold,
                                        color: DesignTokens.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: DesignTokens.spacing1,
                                    ),
                                    Text(
                                      group.players
                                          .map((p) => p.name)
                                          .join(', '),
                                      style: const TextStyle(
                                        fontSize: DesignTokens.fontSm,
                                        color: DesignTokens.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacing3,
                                  vertical: DesignTokens.spacing2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRankColor(group.rank),
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  '${group.rank}위',
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSm,
                                    fontWeight: DesignTokens.fontBold,
                                    color: group.rank <= 3
                                        ? DesignTokens.textPrimary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacing3),
                          Row(
                            children: group.players.map((player) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        player.name,
                                        style: const TextStyle(
                                          fontSize: DesignTokens.fontXs,
                                          color: DesignTokens.textSecondary,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        player.scoreDisplay,
                                        style: TextStyle(
                                          fontSize: DesignTokens.fontBase,
                                          fontWeight: DesignTokens.fontSemibold,
                                          color: _getScoreColor(player.score),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: (index * 100).ms)
                    .slideY(begin: 0.2, end: 0);
              }),

              const SizedBox(height: DesignTokens.spacing6),

              // Personal Best
              const Text(
                '🏌️‍♂️ 개인 베스트',
                style: TextStyle(
                  fontSize: DesignTokens.fontXl,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),

              Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing3),
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
                      boxShadow: DesignTokens.shadowSm,
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: DesignTokens.spacing2,
                      crossAxisSpacing: DesignTokens.spacing2,
                      childAspectRatio: 2.5,
                      children: personalBests.map((best) {
                        return Container(
                          padding: const EdgeInsets.all(DesignTokens.spacing2),
                          decoration: BoxDecoration(
                            color: DesignTokens.neutral50,
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusMd,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                best.category,
                                style: const TextStyle(
                                  fontSize: DesignTokens.fontXs,
                                  color: DesignTokens.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${best.playerName} ${best.value}',
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
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing6),

              // Real-time Notifications
              const Text(
                '📢 실시간 알림',
                style: TextStyle(
                  fontSize: DesignTokens.fontXl,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),

              Container(
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                decoration: BoxDecoration(
                  color: DesignTokens.neutral0,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                  boxShadow: DesignTokens.shadowSm,
                ),
                child: Column(
                  children: notifications.asMap().entries.map((entry) {
                    final index = entry.key;
                    final notification = entry.value;

                    return Container(
                          margin: EdgeInsets.only(
                            bottom: index < notifications.length - 1
                                ? DesignTokens.spacing2
                                : 0,
                          ),
                          padding: const EdgeInsets.all(DesignTokens.spacing3),
                          decoration: BoxDecoration(
                            color: notification.backgroundColor,
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusMd,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                notification.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: DesignTokens.spacing3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.message,
                                      style: const TextStyle(
                                        fontSize: DesignTokens.fontSm,
                                        color: DesignTokens.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      notification.timeAgo,
                                      style: const TextStyle(
                                        fontSize: DesignTokens.fontXs,
                                        color: DesignTokens.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: (400 + index * 100).ms)
                        .slideX(begin: 0.2, end: 0);
                  }).toList(),
                ),
              ),

              const SizedBox(height: DesignTokens.spacing4),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) => FloatingActionButton.extended(
          heroTag: 'live_score_fab',
          onPressed: () => _showCheerChat(context, ref),
          backgroundColor: DesignTokens.primary600,
          icon: const Text('🎉', style: TextStyle(fontSize: 20)),
          label: const Text(
            '응원하기',
            style: TextStyle(
              fontSize: DesignTokens.fontBase,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.neutral0,
            ),
          ),
        ),
      ),
    );
  }
}
