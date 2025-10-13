import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';

// Models
class PlayerScorecard {
  final String id;
  final String name;
  final String initials;
  final int totalScore;
  final String scoreDisplay;
  final Color avatarColor;
  final List<int?> scores; // 18 holes, null means not played yet

  PlayerScorecard({
    required this.id,
    required this.name,
    required this.initials,
    required this.totalScore,
    required this.scoreDisplay,
    required this.avatarColor,
    required this.scores,
  });
}

class FullScorecardPage extends ConsumerStatefulWidget {
  final String roundingId;
  final String roundingName;

  const FullScorecardPage({
    super.key,
    required this.roundingId,
    required this.roundingName,
  });

  @override
  ConsumerState<FullScorecardPage> createState() => _FullScorecardPageState();
}

class _FullScorecardPageState extends ConsumerState<FullScorecardPage> {
  int _selectedPlayerIndex = 0;

  // Standard par for each hole
  final List<int> _frontNinePar = [4, 3, 5, 4, 4, 3, 4, 5, 4]; // Total: 36
  final List<int> _backNinePar = [4, 5, 3, 4, 4, 5, 3, 4, 4]; // Total: 36

  List<PlayerScorecard> _getMockPlayers() {
    return [
      PlayerScorecard(
        id: '1',
        name: '김민수',
        initials: '김',
        totalScore: 0,
        scoreDisplay: 'E',
        avatarColor: DesignTokens.primary600,
        scores: [
          4,
          3,
          5,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ],
      ),
      PlayerScorecard(
        id: '2',
        name: '박영희',
        initials: '박',
        totalScore: 2,
        scoreDisplay: '+2',
        avatarColor: const Color(0xFF28a745),
        scores: [
          5,
          3,
          6,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ],
      ),
      PlayerScorecard(
        id: '3',
        name: '이철수',
        initials: '이',
        totalScore: -1,
        scoreDisplay: '-1',
        avatarColor: const Color(0xFFfd7e14),
        scores: [
          3,
          3,
          5,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ],
      ),
      PlayerScorecard(
        id: '4',
        name: '최지원',
        initials: '최',
        totalScore: 1,
        scoreDisplay: '+1',
        avatarColor: const Color(0xFF6f42c1),
        scores: [
          4,
          4,
          5,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ],
      ),
    ];
  }

  Color _getScoreColor(int? score, int par) {
    if (score == null) return DesignTokens.neutral300;
    if (score < par) return DesignTokens.success; // Birdie or better
    if (score == par) return DesignTokens.textPrimary; // Par
    return DesignTokens.error; // Bogey or worse
  }

  int _calculateOut(List<int?> scores) {
    int total = 0;
    for (int i = 0; i < 9; i++) {
      if (scores[i] != null) total += scores[i]!;
    }
    return total;
  }

  int _calculateIn(List<int?> scores) {
    int total = 0;
    for (int i = 9; i < 18; i++) {
      if (scores[i] != null) total += scores[i]!;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final players = _getMockPlayers();
    final selectedPlayer = players[_selectedPlayerIndex];

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.table_chart, color: DesignTokens.primary600, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '전체 스코어카드',
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
      body: Column(
        children: [
          // Player Selector
          Container(
            color: DesignTokens.neutral0,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing4,
              vertical: DesignTokens.spacing3,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: players.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  final isSelected = index == _selectedPlayerIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlayerIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < players.length - 1
                            ? DesignTokens.spacing2
                            : 0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing3,
                        vertical: DesignTokens.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? DesignTokens.primary50
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMd,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? DesignTokens.primary600
                              : DesignTokens.neutral200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  player.avatarColor,
                                  player.avatarColor.withValues(alpha: 0.7),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                player.initials,
                                style: const TextStyle(
                                  fontSize: DesignTokens.fontSm,
                                  fontWeight: DesignTokens.fontBold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacing2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: TextStyle(
                                  fontSize: DesignTokens.fontXs,
                                  fontWeight: DesignTokens.fontSemibold,
                                  color: isSelected
                                      ? DesignTokens.primary600
                                      : DesignTokens.textPrimary,
                                ),
                              ),
                              Text(
                                player.scoreDisplay,
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSm,
                                  fontWeight: DesignTokens.fontBold,
                                  color: isSelected
                                      ? DesignTokens.primary600
                                      : DesignTokens.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Scorecard
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              child: Column(
                children: [
                  // Front 9
                  _buildScorecardSection(
                    'Front 9',
                    _frontNinePar,
                    selectedPlayer.scores.sublist(0, 9),
                    0,
                  ),

                  const SizedBox(height: DesignTokens.spacing4),

                  // Back 9
                  _buildScorecardSection(
                    'Back 9',
                    _backNinePar,
                    selectedPlayer.scores.sublist(9, 18),
                    9,
                  ),

                  const SizedBox(height: DesignTokens.spacing4),

                  // Total Summary
                  Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          gradient: DesignTokens.gradientEucalyptus,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusXl,
                          ),
                          boxShadow: DesignTokens.shadowMd,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTotalStat(
                              'OUT',
                              '${_calculateOut(selectedPlayer.scores)}',
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            _buildTotalStat(
                              'IN',
                              '${_calculateIn(selectedPlayer.scores)}',
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            _buildTotalStat(
                              'TOTAL',
                              selectedPlayer.scoreDisplay,
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 300.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorecardSection(
    String title,
    List<int> pars,
    List<int?> scores,
    int holeOffset,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.primary600,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing2,
            ),
            child: Column(
              children: [
                // Header Row (Hole numbers)
                Row(
                  children: [
                    _buildHeaderCell('홀', width: 50),
                    ...List.generate(
                      9,
                      (i) => _buildHeaderCell('${holeOffset + i + 1}'),
                    ),
                    _buildHeaderCell(
                      title == 'Front 9' ? 'OUT' : 'IN',
                      width: 50,
                      isTotal: true,
                    ),
                  ],
                ),
                // Par Row
                Row(
                  children: [
                    _buildDataCell('Par', width: 50, isLabel: true),
                    ...pars.map((par) => _buildDataCell('$par')),
                    _buildDataCell(
                      '${pars.reduce((a, b) => a + b)}',
                      width: 50,
                      isTotal: true,
                    ),
                  ],
                ),
                // Score Row
                Row(
                  children: [
                    _buildDataCell('타수', width: 50, isLabel: true),
                    ...scores.asMap().entries.map((entry) {
                      final index = entry.key;
                      final score = entry.value;
                      final par = pars[index];
                      return _buildScoreCell(score, par, holeOffset + index);
                    }),
                    _buildDataCell(
                      '${scores.where((s) => s != null).fold(0, (sum, s) => sum + s!)}',
                      width: 50,
                      isTotal: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildHeaderCell(
    String text, {
    double width = 45,
    bool isTotal = false,
  }) {
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        color: DesignTokens.primary600,
        border: Border.all(color: DesignTokens.primary700),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: isTotal ? DesignTokens.fontXs : DesignTokens.fontSm,
            fontWeight: DesignTokens.fontSemibold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    double width = 45,
    bool isLabel = false,
    bool isTotal = false,
  }) {
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        color: isLabel || isTotal
            ? DesignTokens.neutral100
            : Colors.transparent,
        border: Border.all(color: DesignTokens.neutral200),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: isLabel || isTotal
                ? DesignTokens.fontSemibold
                : DesignTokens.fontMedium,
            color: DesignTokens.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCell(int? score, int par, int holeIndex) {
    return GestureDetector(
      onTap: () {
        // TODO: Edit score
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${holeIndex + 1}번 홀 스코어 수정'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 45,
        height: 40,
        decoration: BoxDecoration(
          color: score == null ? DesignTokens.neutral50 : Colors.transparent,
          border: Border.all(color: DesignTokens.neutral200),
        ),
        child: Center(
          child: Text(
            score == null ? '-' : '$score',
            style: TextStyle(
              fontSize: DesignTokens.fontSm,
              fontWeight: DesignTokens.fontSemibold,
              color: _getScoreColor(score, par),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: DesignTokens.fontXl,
            fontWeight: DesignTokens.fontBold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
