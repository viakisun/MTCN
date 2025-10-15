import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';
import '../../data/models/player.dart';

class LeaderboardEntry {
  final Player player;
  final int currentHole;
  final int score;
  final int scoreToPar;
  final List<int> holeScores;
  final String trend; // up, down, same

  const LeaderboardEntry({
    required this.player,
    required this.currentHole,
    required this.score,
    required this.scoreToPar,
    required this.holeScores,
    this.trend = 'same',
  });
}

class StadiumPage extends ConsumerStatefulWidget {
  final Rounding rounding;

  const StadiumPage({super.key, required this.rounding});

  @override
  ConsumerState<StadiumPage> createState() => _StadiumPageState();
}

class _StadiumPageState extends ConsumerState<StadiumPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Timer _updateTimer;

  // Mock leaderboard data (in real app, this would come from provider)
  late List<LeaderboardEntry> _leaderboard;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Initialize mock leaderboard
    _initializeLeaderboard();

    // Simulate real-time updates every 5 seconds
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _simulateScoreUpdate();
      }
    });
  }

  void _initializeLeaderboard() {
    _leaderboard = widget.rounding.players.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;

      // Generate mock scores
      final scores = List.generate(18, (i) => 3 + (index + i) % 4);
      final currentHole = 5 + index;
      final playedHoles = scores.sublist(0, currentHole);
      final totalScore = playedHoles.fold(0, (sum, s) => sum + s);
      final par = currentHole * 4; // Simplified par calculation

      return LeaderboardEntry(
        player: player,
        currentHole: currentHole,
        score: totalScore,
        scoreToPar: totalScore - par,
        holeScores: scores,
        trend: index == 0
            ? 'up'
            : (index == widget.rounding.players.length - 1 ? 'down' : 'same'),
      );
    }).toList();

    // Sort by score
    _leaderboard.sort((a, b) => a.scoreToPar.compareTo(b.scoreToPar));
  }

  void _simulateScoreUpdate() {
    setState(() {
      // Randomly update a player's score
      if (_leaderboard.isNotEmpty) {
        final randomIndex = DateTime.now().millisecond % _leaderboard.length;
        final entry = _leaderboard[randomIndex];

        // Update score
        final newScore = entry.score + (DateTime.now().second % 2 == 0 ? 0 : 1);
        final newScoreToPar =
            entry.scoreToPar + (DateTime.now().second % 2 == 0 ? 0 : 1);

        _leaderboard[randomIndex] = LeaderboardEntry(
          player: entry.player,
          currentHole: entry.currentHole,
          score: newScore,
          scoreToPar: newScoreToPar,
          holeScores: entry.holeScores,
          trend: newScoreToPar < entry.scoreToPar
              ? 'up'
              : (newScoreToPar > entry.scoreToPar ? 'down' : 'same'),
        );

        // Re-sort
        _leaderboard.sort((a, b) => a.scoreToPar.compareTo(b.scoreToPar));
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _updateTimer.cancel();
    super.dispose();
  }

  Color _getScoreColor(int scoreToPar) {
    if (scoreToPar <= -3) return DesignTokens.success;
    if (scoreToPar < 0) return const Color(0xFF34D399);
    if (scoreToPar == 0) return DesignTokens.textPrimary;
    if (scoreToPar <= 3) return DesignTokens.warning;
    return DesignTokens.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark stadium background
      body: SafeArea(
        child: Column(
          children: [
            // Header with live indicator
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: DesignTokens.error,
                                        boxShadow: [
                                          BoxShadow(
                                            color: DesignTokens.error
                                                .withValues(
                                                  alpha:
                                                      0.5 +
                                                      (_pulseController.value *
                                                          0.5),
                                                ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: DesignTokens.spacing2),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSm,
                                    fontWeight: DesignTokens.fontBold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.rounding.eventName,
                              style: const TextStyle(
                                fontSize: DesignTokens.fontXl,
                                fontWeight: DesignTokens.fontBold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.rounding.courseName,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),

            // Leaderboard
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                itemCount: _leaderboard.length,
                itemBuilder: (context, index) {
                  final entry = _leaderboard[index];
                  final rank = index + 1;

                  return _buildLeaderboardCard(rank, entry)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: (index * 100).ms)
                      .slideX(begin: 0.3, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard(int rank, LeaderboardEntry entry) {
    final scoreColor = _getScoreColor(entry.scoreToPar);
    final isLeader = rank == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        gradient: isLeader
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFD700).withValues(alpha: 0.2),
                  const Color(0xFFFFA500).withValues(alpha: 0.1),
                ],
              )
            : null,
        color: isLeader ? null : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: isLeader
            ? Border.all(color: const Color(0xFFFFD700), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: isLeader
                ? const Color(0xFFFFD700).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: isLeader ? 15 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isLeader
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    )
                  : null,
              color: isLeader ? null : const Color(0xFF334155),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: isLeader ? const Color(0xFF1E293B) : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),

          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.player.name,
                      style: TextStyle(
                        fontSize: DesignTokens.fontLg,
                        fontWeight: DesignTokens.fontBold,
                        color: isLeader
                            ? const Color(0xFFFFD700)
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    if (entry.trend == 'up')
                      const Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: DesignTokens.success,
                      )
                    else if (entry.trend == 'down')
                      const Icon(
                        Icons.arrow_downward,
                        size: 16,
                        color: DesignTokens.error,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Hole ${entry.currentHole}/18',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: Colors.white.withValues(alpha: 0.6),
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
                entry.scoreToPar >= 0
                    ? '+${entry.scoreToPar}'
                    : entry.scoreToPar.toString(),
                style: TextStyle(
                  fontSize: DesignTokens.font2xl,
                  fontWeight: DesignTokens.fontBold,
                  color: scoreColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${entry.score} strokes',
                style: TextStyle(
                  fontSize: DesignTokens.fontXs,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
