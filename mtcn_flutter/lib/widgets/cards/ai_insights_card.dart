import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';

class AIInsightsCard extends StatelessWidget {
  final int totalScore;
  final int averageScore;
  final int bestScore;
  final int birdies;
  final int pars;
  final int bogeys;

  const AIInsightsCard({
    super.key,
    required this.totalScore,
    required this.averageScore,
    required this.bestScore,
    required this.birdies,
    required this.pars,
    required this.bogeys,
  });

  String _generateInsight() {
    // Simple AI-like insights based on score patterns
    if (totalScore < 75) {
      return '훌륭합니다! 프로급 실력을 보여주고 있네요. 이 페이스를 유지하세요! 🔥';
    } else if (totalScore < 85) {
      return '좋은 경기력입니다! 꾸준히 연습하면 70대 진입도 가능해요. 💪';
    } else if (totalScore < 95) {
      return '안정적인 플레이입니다. 퍼팅 연습으로 스코어를 더 줄여보세요. ⛳';
    } else {
      return '즐겁게 플레이하는 것이 중요합니다! 경험을 쌓으면 실력이 늘어요. 🎯';
    }
  }

  String _getStrengthAnalysis() {
    if (birdies > pars / 2) {
      return '공격적인 플레이가 장점입니다. 버디 찬스를 잘 살리고 있어요!';
    } else if (pars > bogeys) {
      return '안정적인 경기 운영이 강점이에요. 파 세이브 능력이 훌륭합니다.';
    } else {
      return '꾸준한 연습으로 실력을 키워나가고 있어요. 화이팅!';
    }
  }

  String _getImprovementTip() {
    final parRate = pars / (birdies + pars + bogeys);
    if (parRate < 0.5) {
      return '💡 Tip: 파 온을 목표로 안정적인 아이언 샷을 연습해보세요.';
    } else if (birdies < 2) {
      return '💡 Tip: 짧은 홀에서 버디 기회를 노려보세요. 공격적인 플레이!';
    } else {
      return '💡 Tip: 일관된 스윙 템포 유지로 더 안정적인 스코어를 만들어보세요.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 인사이트',
                      style: TextStyle(
                        fontSize: DesignTokens.fontLg,
                        fontWeight: DesignTokens.fontBold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '데이터 기반 분석',
                      style: TextStyle(
                        fontSize: DesignTokens.fontXs,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.stars, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Beta',
                      style: TextStyle(
                        fontSize: DesignTokens.fontXs,
                        fontWeight: DesignTokens.fontBold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacing4),

          // Main Insight
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
            child: Text(
              _generateInsight(),
              style: const TextStyle(
                fontSize: DesignTokens.fontBase,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: DesignTokens.spacing3),

          // Strength Analysis
          Row(
            children: [
              const Icon(Icons.thumb_up, color: Colors.white70, size: 16),
              const SizedBox(width: DesignTokens.spacing2),
              Expanded(
                child: Text(
                  _getStrengthAnalysis(),
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacing2),

          // Improvement Tip
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getImprovementTip(),
                    style: const TextStyle(
                      fontSize: DesignTokens.fontSm,
                      color: Colors.white,
                      fontWeight: DesignTokens.fontMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.spacing3),

          // Score Comparison
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('현재', totalScore.toString(), Icons.sports_golf),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildMiniStat('평균', averageScore.toString(), Icons.show_chart),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildMiniStat('베스트', bestScore.toString(), Icons.star),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: DesignTokens.fontLg,
            fontWeight: DesignTokens.fontBold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
