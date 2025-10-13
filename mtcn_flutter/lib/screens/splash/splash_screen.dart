import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/utils/prefs.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../onboarding/onboarding_page.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize preferences
    await Prefs.init();

    // Initialize services
    await AuthService().initialize();
    await NotificationService().initialize();

    // Wait for splash animation
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Always show onboarding for promotional videos
    // Remove this comment and restore logic below if you want to skip onboarding after first launch
    // final hasCompletedOnboarding = Prefs.hasCompletedOnboarding;
    // Widget destination = !hasCompletedOnboarding ? const OnboardingPage() : const MainNavigator();

    const Widget destination = OnboardingPage();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DesignTokens.primary600,
              DesignTokens.primary700,
              DesignTokens.primary800,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radius3xl,
                      ),
                      boxShadow: DesignTokens.shadow2xl,
                    ),
                    child: const Icon(
                      Icons.golf_course,
                      size: 64,
                      color: DesignTokens.primary600,
                    ),
                  )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.easeOutBack)
                  .then(delay: 200.ms)
                  .shimmer(duration: 1000.ms),

              const SizedBox(height: DesignTokens.spacing8),

              // App Name
              const Text(
                    'MTCN Golf',
                    style: TextStyle(
                      fontSize: DesignTokens.font4xl,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.neutral0,
                      letterSpacing: 1.2,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignTokens.spacing2),

              // Tagline
              const Text(
                    '프리미엄 골프 라운딩 플랫폼',
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      color: DesignTokens.primary50,
                      letterSpacing: 0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignTokens.spacing12),

              // Loading Indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    DesignTokens.neutral0,
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
