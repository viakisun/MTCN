import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';
import '../../models/player.dart';
import '../../widgets/common/avatar.dart';

class RoundReportPage extends ConsumerWidget {
  final Rounding rounding;

  const RoundReportPage({super.key, required this.rounding});

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - calculate statistics
    final players = rounding.players;
    final totalStrokes = players.fold<int>(0, (sum, p) => sum + p.bestScore);
    final avgScore = totalStrokes / players.length;

    // Find winner (lowest score)
    final winner = players.reduce((a, b) => a.bestScore < b.bestScore ? a : b);

    // Mock additional stats
    final totalBirdies = players.length * 2; // Mock
    final totalPars = players.length * 10; // Mock

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
          '라운드 리포트',
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('공유 기능은 준비중입니다')));
            },
          ),
        ],
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
            // Round Info Header
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: BoxDecoration(
                gradient: DesignTokens.gradientEucalyptus,
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                boxShadow: DesignTokens.shadowMd,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: DesignTokens.neutral0,
                  ),
                  const SizedBox(height: DesignTokens.spacing2),
                  const Text(
                    '라운드 완료',
                    style: TextStyle(
                      fontSize: DesignTokens.font2xl,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.neutral0,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing2),
                  Text(
                    rounding.courseName,
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      color: DesignTokens.neutral0.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    _formatDate(rounding.date),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      color: DesignTokens.neutral0.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing6),

            // Winner Card
            const Text(
              '🏆 우승자',
              style: TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
            const SizedBox(height: DesignTokens.spacing3),

            Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Avatar(
                        imageUrl: winner.avatar,
                        name: winner.name,
                        size: AvatarSize.large,
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              winner.name,
                              style: const TextStyle(
                                fontSize: DesignTokens.fontXl,
                                fontWeight: DesignTokens.fontBold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${winner.bestScore}타',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontLg,
                                fontWeight: DesignTokens.fontSemibold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.emoji_events,
                        size: 48,
                        color: Color(0xFF1E293B),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 150.ms)
                .scale(delay: 200.ms),

            const SizedBox(height: DesignTokens.spacing6),

            // Statistics Cards
            const Text(
              '📊 라운드 통계',
              style: TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: DesignTokens.spacing3),

            Row(
              children: [
                Expanded(
                  child:
                      _buildStatCard(
                            '평균 스코어',
                            avgScore.toStringAsFixed(1),
                            Icons.insights,
                            DesignTokens.gradientSky,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 250.ms)
                          .slideX(begin: -0.2, end: 0),
                ),
                const SizedBox(width: DesignTokens.spacing3),
                Expanded(
                  child:
                      _buildStatCard(
                            '참가자',
                            '${players.length}명',
                            Icons.people,
                            DesignTokens.gradientEucalyptus,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 300.ms)
                          .slideX(begin: 0.2, end: 0),
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacing3),

            Row(
              children: [
                Expanded(
                  child:
                      _buildStatCard(
                            '버디',
                            totalBirdies.toString(),
                            Icons.star,
                            DesignTokens.gradientGold,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 350.ms)
                          .slideX(begin: -0.2, end: 0),
                ),
                const SizedBox(width: DesignTokens.spacing3),
                Expanded(
                  child:
                      _buildStatCard(
                            '파',
                            totalPars.toString(),
                            Icons.check_circle,
                            DesignTokens.gradientTerracotta,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 400.ms)
                          .slideX(begin: 0.2, end: 0),
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacing6),

            // Leaderboard
            const Text(
              '🏁 최종 순위',
              style: TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 450.ms),
            const SizedBox(height: DesignTokens.spacing3),

            // Sort players by score
            ...List.generate(players.length, (index) {
              final sortedPlayers = List<Player>.from(players)
                ..sort((a, b) => a.bestScore.compareTo(b.bestScore));
              final player = sortedPlayers[index];
              final rank = index + 1;

              return _buildLeaderboardCard(player, rank)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: (500 + index * 50).ms)
                  .slideX(begin: 0.2, end: 0);
            }),

            const SizedBox(height: DesignTokens.spacing6),

            // Course Info
            Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral0,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    border: Border.all(color: DesignTokens.neutral200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⛳ 코스 정보',
                        style: TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing3),
                      _buildInfoRow('코스', rounding.courseName),
                      const Divider(),
                      _buildInfoRow('날짜', _formatDate(rounding.date)),
                      const Divider(),
                      _buildInfoRow('홀', '${rounding.holes}홀'),
                      const Divider(),
                      _buildInfoRow(
                        '날씨',
                        '${rounding.weather} ${rounding.temperature}°C',
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 600.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing6),

            // Action Buttons
            Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PDF 다운로드 기능은 준비중입니다'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.spacing3,
                          ),
                          side: const BorderSide(
                            color: DesignTokens.neutral300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusLg,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.download,
                          color: DesignTokens.textPrimary,
                        ),
                        label: const Text(
                          'PDF 저장',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final shareText =
                              '''
🏌️ ${rounding.eventName} 리포트

🏆 우승: ${winner.name} (${winner.bestScore}타)

📊 통계:
• 평균 스코어: ${avgScore.toStringAsFixed(1)}타
• 참가자: ${players.length}명
• 버디: $totalBirdies개

📍 ${rounding.courseName}
📅 ${_formatDate(rounding.date)}

MTCN Golf App으로 기록된 결과입니다.
''';
                          Share.share(shareText);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.spacing3,
                          ),
                          backgroundColor: DesignTokens.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusLg,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.share,
                          color: DesignTokens.neutral0,
                        ),
                        label: const Text(
                          '공유하기',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: DesignTokens.neutral0,
                          ),
                        ),
                      ),
                    ),
                  ],
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
        children: [
          Icon(
            icon,
            color: DesignTokens.neutral0.withValues(alpha: 0.8),
            size: 32,
          ),
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
              color: DesignTokens.neutral0.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(Player player, int rank) {
    final isWinner = rank == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: isWinner
            ? Border.all(color: const Color(0xFFFFD700), width: 2)
            : null,
        boxShadow: isWinner
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isWinner
                  ? const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    )
                  : null,
              color: isWinner ? null : DesignTokens.neutral100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: isWinner
                      ? const Color(0xFF1E293B)
                      : DesignTokens.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),

          // Avatar
          Avatar(
            imageUrl: player.avatar,
            name: player.name,
            size: AvatarSize.medium,
          ),
          const SizedBox(width: DesignTokens.spacing3),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    fontSize: DesignTokens.fontBase,
                    fontWeight: DesignTokens.fontBold,
                    color: isWinner
                        ? const Color(0xFFFFD700)
                        : DesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '평균 ${player.averageScore}타',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
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
                '${player.bestScore}타',
                style: TextStyle(
                  fontSize: DesignTokens.fontXl,
                  fontWeight: DesignTokens.fontBold,
                  color: isWinner
                      ? const Color(0xFFFFD700)
                      : DesignTokens.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
      child: Row(
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
            value,
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
