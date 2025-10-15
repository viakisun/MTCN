import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../data/models/player.dart';

class FullScorecardPage extends ConsumerStatefulWidget {
  final Player? player;
  final String? courseName;

  const FullScorecardPage({super.key, this.player, this.courseName});

  @override
  ConsumerState<FullScorecardPage> createState() => _FullScorecardPageState();
}

class _FullScorecardPageState extends ConsumerState<FullScorecardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Standard 18-hole course par values
  final List<int> parValues = [
    4, 5, 3, 4, 4, 5, 3, 4, 4, // Front 9 (par 36)
    4, 4, 5, 3, 4, 4, 5, 3, 4, // Back 9 (par 36)
  ];

  // Score values for each hole (initialized with par)
  late List<int> scores;

  // Text controllers for each hole
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize scores with par values
    scores = List<int>.from(parValues);

    // Initialize controllers
    controllers = List.generate(
      18,
      (i) => TextEditingController(text: parValues[i].toString()),
    );
    focusNodes = List.generate(18, (i) => FocusNode());
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  int get totalScore => scores.fold(0, (sum, score) => sum + score);
  int get totalPar => parValues.fold(0, (sum, par) => sum + par);
  int get scoreToPar => totalScore - totalPar;

  int get front9Score =>
      scores.sublist(0, 9).fold(0, (sum, score) => sum + score);
  int get back9Score =>
      scores.sublist(9, 18).fold(0, (sum, score) => sum + score);
  int get front9Par => parValues.sublist(0, 9).fold(0, (sum, par) => sum + par);
  int get back9Par => parValues.sublist(9, 18).fold(0, (sum, par) => sum + par);

  void _saveScorecard() {
    // TODO: Save to provider/database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('스코어가 저장되었습니다! 총 타수: $totalScore'),
        backgroundColor: DesignTokens.success,
      ),
    );
    Navigator.pop(context);
  }

  Color _getScoreColor(int score, int par) {
    if (score < par) return DesignTokens.success;
    if (score == par) return DesignTokens.textPrimary;
    if (score == par + 1) return DesignTokens.warning;
    return DesignTokens.error;
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
          '스코어카드',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: DesignTokens.primary600,
          unselectedLabelColor: DesignTokens.textSecondary,
          indicatorColor: DesignTokens.primary600,
          tabs: const [
            Tab(text: 'Front 9'),
            Tab(text: 'Back 9'),
          ],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                  'Par',
                  totalPar.toString(),
                  DesignTokens.neutral0,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildSummaryItem(
                  '대비',
                  scoreToPar >= 0 ? '+$scoreToPar' : scoreToPar.toString(),
                  DesignTokens.neutral0,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms),

          // Scorecard Table
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScorecardGrid(0, 9), // Front 9
                _buildScorecardGrid(9, 18), // Back 9
              ],
            ),
          ),

          // Bottom Summary
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: const BoxDecoration(
              color: DesignTokens.neutral0,
              border: Border(top: BorderSide(color: DesignTokens.neutral200)),
              boxShadow: DesignTokens.shadowMd,
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomStat('Front 9', '$front9Score / $front9Par'),
                  Container(
                    width: 1,
                    height: 30,
                    color: DesignTokens.neutral200,
                  ),
                  _buildBottomStat('Back 9', '$back9Score / $back9Par'),
                  Container(
                    width: 1,
                    height: 30,
                    color: DesignTokens.neutral200,
                  ),
                  _buildBottomStat('Total', '$totalScore / $totalPar'),
                ],
              ),
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

  Widget _buildBottomStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: DesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildScorecardGrid(int startHole, int endHole) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      child: Column(
        children: [
          // Grid of holes
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: DesignTokens.spacing3,
              mainAxisSpacing: DesignTokens.spacing3,
            ),
            itemCount: endHole - startHole,
            itemBuilder: (context, index) {
              final holeIndex = startHole + index;
              final holeNumber = holeIndex + 1;
              final par = parValues[holeIndex];
              final score = scores[holeIndex];

              return _buildHoleCard(holeNumber, par, score, holeIndex);
            },
          ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
        ],
      ),
    );
  }

  Widget _buildHoleCard(int holeNumber, int par, int score, int holeIndex) {
    final scoreColor = _getScoreColor(score, par);

    return GestureDetector(
      onTap: () => _showScoreDialog(holeNumber, par, holeIndex),
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.neutral0,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: scoreColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hole number
            Text(
              'Hole $holeNumber',
              style: const TextStyle(
                fontSize: DesignTokens.fontXs,
                color: DesignTokens.textSecondary,
                fontWeight: DesignTokens.fontMedium,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing1),

            // Par
            Text(
              'Par $par',
              style: const TextStyle(
                fontSize: DesignTokens.fontXs,
                color: DesignTokens.textTertiary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing1),

            // Score
            Text(
              score.toString(),
              style: TextStyle(
                fontSize: DesignTokens.font3xl,
                fontWeight: DesignTokens.fontBold,
                color: scoreColor,
              ),
            ),

            // Score label (Birdie, Par, Bogey, etc.)
            const SizedBox(height: DesignTokens.spacing1),
            Text(
              _getScoreLabel(score, par),
              style: TextStyle(
                fontSize: 10,
                color: scoreColor,
                fontWeight: DesignTokens.fontSemibold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScoreLabel(int score, int par) {
    final diff = score - par;
    if (diff <= -2) return 'Eagle';
    if (diff == -1) return 'Birdie';
    if (diff == 0) return 'Par';
    if (diff == 1) return 'Bogey';
    if (diff == 2) return 'Double';
    return 'Triple+';
  }

  void _showScoreDialog(int holeNumber, int par, int holeIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hole $holeNumber (Par $par)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '타수를 선택하세요',
              style: TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing3),
            Wrap(
              spacing: DesignTokens.spacing2,
              runSpacing: DesignTokens.spacing2,
              children: List.generate(10, (index) {
                final score = index + 1; // 1-10
                final isSelected = scores[holeIndex] == score;
                final color = _getScoreColor(score, par);

                return InkWell(
                  onTap: () {
                    setState(() {
                      scores[holeIndex] = score;
                      controllers[holeIndex].text = score.toString();
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? color : DesignTokens.neutral50,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMd,
                      ),
                      border: Border.all(
                        color: isSelected ? color : DesignTokens.neutral200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        score.toString(),
                        style: TextStyle(
                          fontSize: DesignTokens.fontLg,
                          fontWeight: DesignTokens.fontBold,
                          color: isSelected ? DesignTokens.neutral0 : color,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }
}
