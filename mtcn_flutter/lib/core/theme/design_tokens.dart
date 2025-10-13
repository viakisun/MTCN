import 'package:flutter/material.dart';

/// Design Tokens - Global Premium Golf App
/// Professional design system for worldwide golf platform
class DesignTokens {
  DesignTokens._();

  // ============================================================================
  // COLORS - 2025 Ultra-Modern Palette
  // ============================================================================

  // Primary - Slate (Dark Sophisticated)
  static const Color primary50 = Color(0xFFF8FAFC);
  static const Color primary100 = Color(0xFFF1F5F9);
  static const Color primary200 = Color(0xFFE2E8F0);
  static const Color primary300 = Color(0xFFCBD5E1);
  static const Color primary400 = Color(0xFF94A3B8);
  static const Color primary500 = Color(0xFF64748B);
  static const Color primary600 = Color(0xFF475569);
  static const Color primary700 = Color(0xFF334155);
  static const Color primary800 = Color(0xFF1E293B);
  static const Color primary900 = Color(0xFF0F172A);

  // Secondary - Electric Cyan (Bold & Vibrant)
  static const Color secondary50 = Color(0xFFECFEFF);
  static const Color secondary100 = Color(0xFFCFFAFE);
  static const Color secondary200 = Color(0xFFA5F3FC);
  static const Color secondary300 = Color(0xFF67E8F9);
  static const Color secondary400 = Color(0xFF22D3EE);
  static const Color secondary500 = Color(0xFF06B6D4);
  static const Color secondary600 = Color(0xFF0891B2);
  static const Color secondary700 = Color(0xFF0E7490);
  static const Color secondary800 = Color(0xFF155E75);
  static const Color secondary900 = Color(0xFF164E63);

  // Accent - Vibrant Emerald (Fresh & Energetic)
  static const Color accent50 = Color(0xFFECFDF5);
  static const Color accent100 = Color(0xFFD1FAE5);
  static const Color accent200 = Color(0xFFA7F3D0);
  static const Color accent300 = Color(0xFF6EE7B7);
  static const Color accent400 = Color(0xFF34D399);
  static const Color accent500 = Color(0xFF10B981);
  static const Color accent600 = Color(0xFF059669);
  static const Color accent700 = Color(0xFF047857);
  static const Color accent800 = Color(0xFF065F46);
  static const Color accent900 = Color(0xFF064E3B);

  // Neutral - Modern Gray Scale
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral25 = Color(0xFFFCFCFD);
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral950 = Color(0xFF030712);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF047857);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF92400E);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF06B6D4);
  static const Color infoLight = Color(0xFFCFFAFE);
  static const Color infoDark = Color(0xFF0E7490);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF9FAFB);
  static const Color surfaceTertiary = Color(0xFFF3F4F6);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceOverlay = Color(0x80000000); // 50% opacity

  // Border Colors
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDefault = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD1D5DB);

  // Status Colors
  static const Color statusScheduled = Color(0xFF06B6D4); // Cyan
  static const Color statusInProgress = Color(0xFF10B981); // Emerald
  static const Color statusCompleted = Color(0xFF64748B); // Slate
  static const Color statusCancelled = Color(0xFFEF4444); // Red

  // ============================================================================
  // SPACING - 4px based system (更精細)
  // ============================================================================
  static const double spacing0 = 0;
  static const double spacing1 = 4;
  static const double spacing2 = 8;
  static const double spacing3 = 12;
  static const double spacing4 = 16;
  static const double spacing5 = 20;
  static const double spacing6 = 24;
  static const double spacing7 = 28;
  static const double spacing8 = 32;
  static const double spacing9 = 36;
  static const double spacing10 = 40;
  static const double spacing11 = 44;
  static const double spacing12 = 48;
  static const double spacing14 = 56;
  static const double spacing16 = 64;
  static const double spacing20 = 80;
  static const double spacing24 = 96;
  static const double spacing32 = 128;

  // ============================================================================
  // BORDER RADIUS - Refined curves
  // ============================================================================
  static const double radiusNone = 0;
  static const double radiusSm = 4;
  static const double radiusBase = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radius2xl = 20;
  static const double radius3xl = 24;
  static const double radiusFull = 9999;

  // ============================================================================
  // TYPOGRAPHY - Professional Scale
  // ============================================================================

  // Font Sizes
  static const double fontXs = 12;
  static const double fontSm = 14;
  static const double fontBase = 16;
  static const double fontLg = 18;
  static const double fontXl = 20;
  static const double font2xl = 24;
  static const double font3xl = 30;
  static const double font4xl = 36;
  static const double font5xl = 48;
  static const double font6xl = 60;

  // Font Weights
  static const FontWeight fontThin = FontWeight.w100;
  static const FontWeight fontExtraLight = FontWeight.w200;
  static const FontWeight fontLight = FontWeight.w300;
  static const FontWeight fontNormal = FontWeight.w400;
  static const FontWeight fontMedium = FontWeight.w500;
  static const FontWeight fontSemibold = FontWeight.w600;
  static const FontWeight fontBold = FontWeight.w700;
  static const FontWeight fontExtraBold = FontWeight.w800;
  static const FontWeight fontBlack = FontWeight.w900;

  // Line Heights
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  static const double lineHeightLoose = 2.0;

  // Letter Spacing
  static const double letterSpacingTight = -0.05;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.05;
  static const double letterSpacingWider = 0.1;

  // ============================================================================
  // SHADOWS - Premium depth system
  // ============================================================================

  static const List<BoxShadow> shadowXs = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(color: Color(0x19000000), blurRadius: 24, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> shadow2xl = [
    BoxShadow(color: Color(0x26000000), blurRadius: 48, offset: Offset(0, 24)),
  ];

  // Colored Shadows
  static const List<BoxShadow> shadowPrimary = [
    BoxShadow(color: Color(0x264A9025), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> shadowSecondary = [
    BoxShadow(color: Color(0x26946B3D), blurRadius: 24, offset: Offset(0, 8)),
  ];

  // ============================================================================
  // GRADIENTS - Modern 2025 gradients
  // ============================================================================

  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF64748B), Color(0xFF334155)],
  );

  static const LinearGradient gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF0891B2)],
  );

  static const LinearGradient gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF059669)],
  );

  static const LinearGradient gradientSuccess = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF10B981)],
  );

  static const LinearGradient gradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  static const LinearGradient gradientGlassmorphism = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFAFFFFFF), Color(0xF5F9FAFB)],
  );

  // Mesh Gradients (for premium backgrounds)
  static const LinearGradient gradientMeshLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAFC), Color(0xFFECFEFF), Color(0xFFECFDF5)],
  );

  // Legacy gradient names (for backward compatibility)
  static const LinearGradient gradientTerracotta = gradientSecondary;
  static const LinearGradient gradientGold = gradientSecondary;
  static const LinearGradient gradientEucalyptus = gradientPrimary;
  static const LinearGradient gradientSky = gradientAccent;

  // ============================================================================
  // ANIMATION - Professional timing
  // ============================================================================

  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationSlower = Duration(milliseconds: 500);
  static const Duration durationSlowest = Duration(milliseconds: 700);

  // ============================================================================
  // CURVES - Natural motion
  // ============================================================================

  static const Curve curveInOut = Curves.easeInOut;
  static const Curve curveOut = Curves.easeOut;
  static const Curve curveIn = Curves.easeIn;
  static const Curve curveSnappy = Curves.easeOutCubic;
  static const Curve curveSmooth = Curves.easeInOutCubic;
  static const Curve curveSpring = Curves.elasticOut;

  // ============================================================================
  // ELEVATIONS - Material Design inspired
  // ============================================================================

  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation3 = 4;
  static const double elevation4 = 8;
  static const double elevation5 = 16;

  // ============================================================================
  // OPACITY - Consistent transparency levels
  // ============================================================================

  static const double opacity0 = 0;
  static const double opacity5 = 0.05;
  static const double opacity10 = 0.10;
  static const double opacity20 = 0.20;
  static const double opacity30 = 0.30;
  static const double opacity40 = 0.40;
  static const double opacity50 = 0.50;
  static const double opacity60 = 0.60;
  static const double opacity70 = 0.70;
  static const double opacity80 = 0.80;
  static const double opacity90 = 0.90;
  static const double opacity100 = 1.0;

  // ============================================================================
  // BLUR - Glassmorphism effects
  // ============================================================================

  static const double blurNone = 0;
  static const double blurSm = 4;
  static const double blurBase = 8;
  static const double blurMd = 12;
  static const double blurLg = 16;
  static const double blurXl = 24;
  static const double blur2xl = 40;
  static const double blur3xl = 64;
}
