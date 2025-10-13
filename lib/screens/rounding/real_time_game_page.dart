import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import 'full_scorecard_page.dart';

// Models
class GamePlayer {
  final String name;
  final String initials;
  final int rank;
  final int score; // Relative to par
  final String scoreDisplay;
  final int averageScore;
  final Color avatarColor;

  GamePlayer({
    required this.name,
    required this.initials,
    required this.rank,
    required this.score,
    required this.scoreDisplay,
    required this.averageScore,
    required this.avatarColor,
  });
}

class HoleInfo {
  final int holeNumber;
  final int par;
  final int distance; // in yards
  final int handicap;

  HoleInfo({
    required this.holeNumber,
    required this.par,
    required this.distance,
    required this.handicap,
  });
}

class RealTimeGamePage extends ConsumerStatefulWidget {
  final String roundingId;
  final String courseName;
  final String date;
  final String time;

  const RealTimeGamePage({
    super.key,
    required this.roundingId,
    required this.courseName,
    required this.date,
    required this.time,
  });

  @override
  ConsumerState<RealTimeGamePage> createState() => _RealTimeGamePageState();
}

class _RealTimeGamePageState extends ConsumerState<RealTimeGamePage> {
  Color _getScoreColor(int score) {
    if (score < 0) return DesignTokens.success; // Under par
    if (score == 0) return DesignTokens.info; // Even par
    return const Color(0xFFF59E0B); // Over par
  }

  String _getScoreLabel(int score) {
    if (score < 0) return '언더파';
    if (score == 0) return '이븐파';
    return '오버파';
  }

  List<GamePlayer> _getMockPlayers() {
    return [
      GamePlayer(
        name: '이철수',
        initials: '이',
        rank: 1,
        score: -1,
        scoreDisplay: '-1',
        averageScore: 85,
        avatarColor: const Color(0xFFfd7e14),
      ),
      GamePlayer(
        name: '김민수',
        initials: '김',
        rank: 2,
        score: 0,
        scoreDisplay: 'E',
        averageScore: 89,
        avatarColor: DesignTokens.primary600,
      ),
      GamePlayer(
        name: '최지원',
        initials: '최',
        rank: 3,
        score: 1,
        scoreDisplay: '+1',
        averageScore: 90,
        avatarColor: const Color(0xFF6f42c1),
      ),
      GamePlayer(
        name: '박영호',
        initials: '박',
        rank: 4,
        score: 2,
        scoreDisplay: '+2',
        averageScore: 92,
        avatarColor: const Color(0xFF28a745),
      ),
    ];
  }

  HoleInfo _getCurrentHole() {
    return HoleInfo(holeNumber: 4, par: 4, distance: 385, handicap: 7);
  }

  @override
  Widget build(BuildContext context) {
    final players = _getMockPlayers();
    final currentHole = _getCurrentHole();

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sports_golf, color: DesignTokens.primary600, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '실시간 경기',
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
            icon: const Icon(Icons.table_chart, color: DesignTokens.primary600),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScorecardPage(
                    roundingId: widget.roundingId,
                    roundingName: '${widget.courseName} - ${widget.date}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rounding Info Header
                  Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          color: DesignTokens.neutral0,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusXl,
                          ),
                          boxShadow: DesignTokens.shadowSm,
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.courseName,
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: DesignTokens.textSecondary,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacing1),
                            Text(
                              '${widget.date} ${widget.time}',
                              style: const TextStyle(
                                fontSize: DesignTokens.font2xl,
                                fontWeight: DesignTokens.fontBold,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacing3),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoStat(
                                    '참가자',
                                    '${players.length}명',
                                  ),
                                ),
                                Expanded(child: _buildInfoStat('홀', '18홀')),
                                Expanded(child: _buildInfoStat('날씨', '☀️ 22°')),
                                Expanded(
                                  child: _buildInfoStat(
                                    '경기',
                                    '진행중',
                                    valueColor: DesignTokens.success,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: DesignTokens.spacing4),

                  // Real-time Leaderboard
                  const Text(
                    '🏆 실시간 리더보드',
                    style: TextStyle(
                      fontSize: DesignTokens.fontXl,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing3),

                  Container(
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
                      boxShadow: DesignTokens.shadowSm,
                    ),
                    child: Column(
                      children: players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final player = entry.value;
                        final isFirst = player.rank == 1;

                        return Container(
                              margin: EdgeInsets.only(
                                top: index == 0 ? 0 : DesignTokens.spacing3,
                              ),
                              padding: const EdgeInsets.all(
                                DesignTokens.spacing4,
                              ),
                              decoration: BoxDecoration(
                                gradient: isFirst
                                    ? const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFEF3C7),
                                          Color(0xFFFDE68A),
                                        ],
                                      )
                                    : null,
                                color: isFirst ? null : DesignTokens.neutral50,
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.radiusXl,
                                ),
                                border: isFirst
                                    ? null
                                    : Border.all(
                                        color: DesignTokens.neutral200,
                                      ),
                              ),
                              child: Row(
                                children: [
                                  // Rank
                                  SizedBox(
                                    width: 32,
                                    child: Text(
                                      '${player.rank}',
                                      style: TextStyle(
                                        fontSize: isFirst
                                            ? DesignTokens.font2xl
                                            : DesignTokens.fontXl,
                                        fontWeight: DesignTokens.fontBold,
                                        color: isFirst
                                            ? const Color(0xFF92400E)
                                            : DesignTokens.textSecondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: DesignTokens.spacing3),

                                  // Avatar
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          player.avatarColor,
                                          player.avatarColor.withValues(
                                            alpha: 0.7,
                                          ),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        player.initials,
                                        style: const TextStyle(
                                          fontSize: DesignTokens.fontBase,
                                          fontWeight: DesignTokens.fontBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: DesignTokens.spacing3),

                                  // Player Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          player.name,
                                          style: TextStyle(
                                            fontSize: DesignTokens.fontBase,
                                            fontWeight: isFirst
                                                ? DesignTokens.fontBold
                                                : DesignTokens.fontSemibold,
                                            color: DesignTokens.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '평균 ${player.averageScore}타',
                                          style: const TextStyle(
                                            fontSize: DesignTokens.fontXs,
                                            color: DesignTokens.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Score
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        player.scoreDisplay,
                                        style: TextStyle(
                                          fontSize: isFirst
                                              ? DesignTokens.font2xl
                                              : DesignTokens.fontXl,
                                          fontWeight: DesignTokens.fontBold,
                                          color: _getScoreColor(player.score),
                                        ),
                                      ),
                                      Text(
                                        _getScoreLabel(player.score),
                                        style: const TextStyle(
                                          fontSize: DesignTokens.fontXs,
                                          color: DesignTokens.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(
                              duration: 500.ms,
                              delay: (100 + index * 100).ms,
                            )
                            .slideX(begin: 0.2, end: 0);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: DesignTokens.spacing4),

                  // Current Hole Info
                  Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          color: DesignTokens.neutral0,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusXl,
                          ),
                          boxShadow: DesignTokens.shadowSm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '현재 진행 중',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSm,
                                fontWeight: DesignTokens.fontSemibold,
                                color: DesignTokens.textSecondary,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacing2),
                            Text(
                              '${currentHole.holeNumber}번 홀 • Par ${currentHole.par}',
                              style: const TextStyle(
                                fontSize: DesignTokens.font2xl,
                                fontWeight: DesignTokens.fontBold,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacing1),
                            Text(
                              '${currentHole.distance}y • 핸디캡 ${currentHole.handicap}',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: DesignTokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),

          // Score Input Button
          Container(
            padding: EdgeInsets.fromLTRB(
              DesignTokens.spacing4,
              DesignTokens.spacing3,
              DesignTokens.spacing4,
              DesignTokens.spacing4 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: DesignTokens.neutral0,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to score input
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('스코어 입력 기능은 준비중입니다'),
                      backgroundColor: DesignTokens.info,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.success,
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignTokens.spacing4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  elevation: 2,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 20),
                    SizedBox(width: DesignTokens.spacing2),
                    Text(
                      '📊 스코어 입력하기',
                      style: TextStyle(
                        fontSize: DesignTokens.fontBase,
                        fontWeight: DesignTokens.fontSemibold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStat(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: DesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontBold,
            color: valueColor ?? DesignTokens.textPrimary,
          ),
        ),
      ],
    );
  }
}
