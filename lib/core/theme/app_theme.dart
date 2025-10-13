import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: DesignTokens.primary600,
        secondary: DesignTokens.secondary600,
        surface: DesignTokens.neutral0,
        error: DesignTokens.error,
      ),
      scaffoldBackgroundColor: DesignTokens.neutral50,

      // Typography
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: DesignTokens.font4xl,
          fontWeight: DesignTokens.fontBold,
          color: DesignTokens.textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: DesignTokens.font3xl,
          fontWeight: DesignTokens.fontBold,
          color: DesignTokens.textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: DesignTokens.font2xl,
          fontWeight: DesignTokens.fontSemibold,
          color: DesignTokens.textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontXl,
          fontWeight: DesignTokens.fontSemibold,
          color: DesignTokens.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontLg,
          fontWeight: DesignTokens.fontMedium,
          color: DesignTokens.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: DesignTokens.fontBase,
          fontWeight: DesignTokens.fontNormal,
          color: DesignTokens.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTokens.fontSm,
          fontWeight: DesignTokens.fontNormal,
          color: DesignTokens.textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: DesignTokens.fontXs,
          fontWeight: DesignTokens.fontNormal,
          color: DesignTokens.textTertiary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        ),
        color: DesignTokens.neutral0,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: DesignTokens.neutral0,
        foregroundColor: DesignTokens.textPrimary,
        titleTextStyle: GoogleFonts.inter(
          fontSize: DesignTokens.fontXl,
          fontWeight: DesignTokens.fontSemibold,
          color: DesignTokens.textPrimary,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.neutral0,
        selectedItemColor: DesignTokens.primary600,
        unselectedItemColor: DesignTokens.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
