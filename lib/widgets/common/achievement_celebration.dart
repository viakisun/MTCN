import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/achievement.dart';
import 'avatar.dart';

class AchievementCelebration extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onClose;

  const AchievementCelebration({
    super.key,
    required this.achievement,
    this.onClose,
  });

  @override
  State<AchievementCelebration> createState() => _AchievementCelebrationState();
}

class _AchievementCelebrationState extends State<AchievementCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _controller.forward();
    _confettiController.play();

    // Auto close after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _close();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onClose?.call();
      }
    });
  }

  Color _getAchievementColor() {
    switch (widget.achievement.type) {
      case AchievementType.holeInOne:
      case AchievementType.albatross:
        return const Color(0xFFFFD700); // Gold
      case AchievementType.firstPlace:
        return const Color(0xFFFFD700); // Gold
      case AchievementType.secondPlace:
        return const Color(0xFFC0C0C0); // Silver
      case AchievementType.thirdPlace:
        return const Color(0xFFCD7F32); // Bronze
      case AchievementType.eagle:
        return DesignTokens.secondary500;
      case AchievementType.bestScore:
      case AchievementType.underPar:
        return DesignTokens.accent500;
      default:
        return DesignTokens.primary600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getAchievementColor();

    return Stack(
      children: [
        // Background overlay
        GestureDetector(
          onTap: _close,
          child: Container(color: Colors.black.withOpacity(0.7)),
        ),

        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3.14 / 2, // Down
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
            colors: const [
              Color(0xFFFFD700),
              Color(0xFFFFA500),
              Color(0xFF06B6D4),
              Color(0xFF10B981),
              Color(0xFFEC4899),
            ],
          ),
        ),

        // Achievement card
        Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing6,
                ),
                padding: const EdgeInsets.all(DesignTokens.spacing8),
                decoration: BoxDecoration(
                  color: DesignTokens.surfacePrimary,
                  borderRadius: BorderRadius.circular(DesignTokens.radius3xl),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getIcon(),
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),

                    const SizedBox(height: DesignTokens.spacing6),

                    // Title
                    Text(
                      widget.achievement.title,
                      style: TextStyle(
                        fontSize: DesignTokens.font3xl,
                        fontWeight: DesignTokens.fontBold,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: DesignTokens.spacing3),

                    // Player avatar
                    Avatar(
                      name: widget.achievement.player.name,
                      imageUrl: widget.achievement.player.avatar,
                      size: AvatarSize.large,
                      player: widget.achievement.player,
                      showBorder: true,
                    ),

                    const SizedBox(height: DesignTokens.spacing3),

                    // Message
                    Text(
                      widget.achievement.message,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontLg,
                        color: DesignTokens.textPrimary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: DesignTokens.spacing6),

                    // Close button
                    TextButton(
                      onPressed: _close,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing6,
                          vertical: DesignTokens.spacing3,
                        ),
                        backgroundColor: color.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusFull,
                          ),
                        ),
                      ),
                      child: Text(
                        '축하하기',
                        style: TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontSemibold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getIcon() {
    switch (widget.achievement.type) {
      case AchievementType.holeInOne:
        return '🎯';
      case AchievementType.eagle:
        return '🦅';
      case AchievementType.albatross:
        return '🦢';
      case AchievementType.firstPlace:
        return '🏆';
      case AchievementType.secondPlace:
        return '🥈';
      case AchievementType.thirdPlace:
        return '🥉';
      case AchievementType.bestScore:
        return '⭐';
      case AchievementType.underPar:
        return '🎊';
      case AchievementType.perfectPutt:
        return '⛳';
    }
  }
}

/// Helper function to show achievement celebration
void showAchievementCelebration(BuildContext context, Achievement achievement) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) => AchievementCelebration(achievement: achievement),
  );
}
