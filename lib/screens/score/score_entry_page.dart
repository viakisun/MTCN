import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/player.dart';

class ScoreEntryPage extends ConsumerStatefulWidget {
  final Player? player;
  final String? courseName;

  const ScoreEntryPage({super.key, this.player, this.courseName});

  @override
  ConsumerState<ScoreEntryPage> createState() => _ScoreEntryPageState();
}

class _ScoreEntryPageState extends ConsumerState<ScoreEntryPage> {
  late PageController _pageController;
  int _currentHole = 0;

  // Standard 18-hole course par values
  final List<int> parValues = [
    4, 5, 3, 4, 4, 5, 3, 4, 4, // Front 9 (par 36)
    4, 4, 5, 3, 4, 4, 5, 3, 4, // Back 9 (par 36)
  ];

  // Score values for each hole (0 means not entered yet)
  late List<int> scores;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    scores = List<int>.filled(18, 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get totalScore =>
      scores.where((s) => s > 0).fold(0, (sum, score) => sum + score);
  int get holesCompleted => scores.where((s) => s > 0).length;
  int get totalPar {
    int par = 0;
    for (int i = 0; i < 18; i++) {
      if (scores[i] > 0) {
        par += parValues[i];
      }
    }
    return par;
  }

  int get scoreToPar => totalScore - totalPar;

  void _setScore(int holeIndex, int score) {
    setState(() {
      scores[holeIndex] = score;
    });

    // Auto-advance to next hole if not the last hole
    if (holeIndex < 17) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _pageController.animateToPage(
            holeIndex + 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _clearScore(int holeIndex) {
    setState(() {
      scores[holeIndex] = 0;
    });
  }

  void _saveScorecard() {
    if (holesCompleted == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1개 홀의 스코어를 입력해주세요'),
          backgroundColor: DesignTokens.error,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$holesCompleted홀 스코어가 저장되었습니다! 총 타수: $totalScore'),
        backgroundColor: DesignTokens.success,
      ),
    );
    Navigator.pop(context);
  }

  Color _getScoreColor(int score, int par) {
    if (score == 0) return DesignTokens.neutral200;
    if (score < par) return DesignTokens.success;
    if (score == par) return DesignTokens.textPrimary;
    if (score == par + 1) return DesignTokens.warning;
    return DesignTokens.error;
  }

  String _getScoreLabel(int score, int par) {
    if (score == 0) return '미입력';
    final diff = score - par;
    if (diff <= -3) return 'Albatross';
    if (diff == -2) return 'Eagle';
    if (diff == -1) return 'Birdie';
    if (diff == 0) return 'Par';
    if (diff == 1) return 'Bogey';
    if (diff == 2) return 'Double';
    return 'Triple+';
  }

  @override
  Widget build(BuildContext context) {
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
          '스코어 입력',
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
              Icons.check,
              color: DesignTokens.primary600,
              size: 24,
            ),
            onPressed: _saveScorecard,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: DesignTokens.neutral200),
        ),
      ),
      body: Column(
        children: [
          // Score Summary Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: BoxDecoration(
              gradient: scoreToPar <= 0
                  ? DesignTokens.gradientEucalyptus
                  : DesignTokens.gradientTerracotta,
              boxShadow: DesignTokens.shadowMd,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      '완료',
                      '$holesCompleted/18',
                      DesignTokens.neutral0,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _buildSummaryItem(
                      '총 타수',
                      totalScore.toString(),
                      DesignTokens.neutral0,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _buildSummaryItem(
                      '대비',
                      holesCompleted > 0
                          ? (scoreToPar >= 0
                                ? '+$scoreToPar'
                                : scoreToPar.toString())
                          : '-',
                      DesignTokens.neutral0,
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms),

          // Hole Progress Indicator
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              vertical: DesignTokens.spacing3,
            ),
            color: DesignTokens.neutral0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing4,
              ),
              itemCount: 18,
              itemBuilder: (context, index) {
                final isActive = _currentHole == index;
                final hasScore = scores[index] > 0;
                final par = parValues[index];
                final score = scores[index];

                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 36,
                    margin: const EdgeInsets.only(right: DesignTokens.spacing2),
                    decoration: BoxDecoration(
                      color: hasScore
                          ? _getScoreColor(score, par)
                          : (isActive
                                ? DesignTokens.primary600
                                : DesignTokens.neutral100),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMd,
                      ),
                      border: isActive
                          ? Border.all(color: DesignTokens.primary600, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontBold,
                          color: hasScore || isActive
                              ? DesignTokens.neutral0
                              : DesignTokens.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Hole Entry Area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentHole = index;
                });
              },
              itemCount: 18,
              itemBuilder: (context, index) {
                return _buildHoleEntryPage(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontXs,
            color: color.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: DesignTokens.spacing1),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.font2xl,
            fontWeight: DesignTokens.fontBold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildHoleEntryPage(int holeIndex) {
    final holeNumber = holeIndex + 1;
    final par = parValues[holeIndex];
    final currentScore = scores[holeIndex];
    final scoreColor = _getScoreColor(currentScore, par);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      child: Column(
        children: [
          // Hole Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: BoxDecoration(
              color: DesignTokens.neutral0,
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
              boxShadow: DesignTokens.shadowSm,
            ),
            child: Column(
              children: [
                Text(
                  'Hole $holeNumber',
                  style: const TextStyle(
                    fontSize: DesignTokens.font3xl,
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
                    color: DesignTokens.neutral100,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusFull,
                    ),
                  ),
                  child: Text(
                    'Par $par',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontSemibold,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ),
                if (currentScore > 0) ...[
                  const SizedBox(height: DesignTokens.spacing3),
                  Text(
                    currentScore.toString(),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: DesignTokens.fontBold,
                      color: scoreColor,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    _getScoreLabel(currentScore, par),
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontSemibold,
                      color: scoreColor,
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: DesignTokens.spacing4),

          // Score Input - Tile Mode
          Container(
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                decoration: BoxDecoration(
                  color: DesignTokens.neutral0,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                  boxShadow: DesignTokens.shadowSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '타수 선택',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSm,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing3),

                    // Quick score buttons (par-2 to par+3)
                    Wrap(
                      spacing: DesignTokens.spacing2,
                      runSpacing: DesignTokens.spacing2,
                      children: List.generate(6, (index) {
                        final score = (par - 2) + index;
                        if (score < 1) return const SizedBox.shrink();

                        final isSelected = currentScore == score;
                        final color = _getScoreColor(score, par);

                        return InkWell(
                          onTap: () => _setScore(holeIndex, score),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color
                                  : DesignTokens.neutral50,
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : DesignTokens.neutral200,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                score.toString(),
                                style: TextStyle(
                                  fontSize: DesignTokens.font2xl,
                                  fontWeight: DesignTokens.fontBold,
                                  color: isSelected
                                      ? DesignTokens.neutral0
                                      : color,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: DesignTokens.spacing3),
                    const Divider(color: DesignTokens.neutral200),
                    const SizedBox(height: DesignTokens.spacing3),

                    // Numpad for any score
                    const Text(
                      '직접 입력',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSm,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing3),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: DesignTokens.spacing2,
                            mainAxisSpacing: DesignTokens.spacing2,
                          ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final score = index + 1;
                        final isSelected = currentScore == score;
                        final color = _getScoreColor(score, par);

                        return InkWell(
                          onTap: () => _setScore(holeIndex, score),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color
                                  : DesignTokens.neutral50,
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusMd,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : DesignTokens.neutral200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                score.toString(),
                                style: TextStyle(
                                  fontSize: DesignTokens.fontLg,
                                  fontWeight: DesignTokens.fontBold,
                                  color: isSelected
                                      ? DesignTokens.neutral0
                                      : color,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: DesignTokens.spacing3),

                    // Clear button
                    if (currentScore > 0)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _clearScore(holeIndex),
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
                            Icons.clear,
                            color: DesignTokens.textSecondary,
                            size: 20,
                          ),
                          label: const Text(
                            '스코어 지우기',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSm,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: DesignTokens.spacing4),

          // Navigation Buttons
          Row(
            children: [
              if (holeIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: DesignTokens.spacing3,
                      ),
                      side: const BorderSide(color: DesignTokens.neutral300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: DesignTokens.textPrimary,
                      size: 20,
                    ),
                    label: Text(
                      'Hole ${holeNumber - 1}',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                  ),
                ),
              if (holeIndex > 0 && holeIndex < 17)
                const SizedBox(width: DesignTokens.spacing2),
              if (holeIndex < 17)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
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
                      Icons.arrow_forward,
                      color: DesignTokens.neutral0,
                      size: 20,
                    ),
                    label: Text(
                      'Hole ${holeNumber + 1}',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.neutral0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
