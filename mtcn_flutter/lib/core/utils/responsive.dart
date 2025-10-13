import 'package:flutter/material.dart';

/// Responsive breakpoints for mobile app
class Responsive {
  // Breakpoints (mobile-first approach)
  static const double mobileSmall = 320;
  static const double mobile = 375;
  static const double mobileLarge = 425;
  static const double tablet = 768;
  static const double desktop = 1024;

  /// Check if screen is mobile (< 768px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tablet;
  }

  /// Check if screen is tablet (768px - 1024px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet && width < desktop;
  }

  /// Check if screen is desktop (>= 1024px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get screen width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get safe area padding
  static EdgeInsets safeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Calculate responsive font size
  static double fontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) {
      return baseSize * 0.9; // Smaller screens
    } else if (width > mobileLarge && width < tablet) {
      return baseSize * 1.05; // Large phones
    } else if (width >= tablet) {
      return baseSize * 1.1; // Tablets
    }
    return baseSize;
  }

  /// Calculate responsive spacing
  static double spacing(BuildContext context, double baseSpacing) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) {
      return baseSpacing * 0.85;
    } else if (width >= tablet) {
      return baseSpacing * 1.2;
    }
    return baseSpacing;
  }

  /// Get number of grid columns based on screen size
  static int gridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Calculate card width for grid layout
  static double cardWidth(BuildContext context, {double padding = 16}) {
    final screenWidth = width(context);
    final columns = gridColumns(context);
    return (screenWidth - (padding * (columns + 1))) / columns;
  }

  /// Get orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get text scale factor
  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Clamp text scale factor for accessibility
  static double clampedTextScaleFactor(
    BuildContext context, {
    double min = 0.8,
    double max = 1.3,
  }) {
    final scaleFactor = textScaleFactor(context);
    return scaleFactor.clamp(min, max);
  }
}

/// Extension for responsive padding
extension ResponsivePadding on BuildContext {
  EdgeInsets get responsivePadding {
    return EdgeInsets.symmetric(
      horizontal: Responsive.spacing(this, 16),
      vertical: Responsive.spacing(this, 12),
    );
  }

  EdgeInsets get responsiveHorizontalPadding {
    return EdgeInsets.symmetric(horizontal: Responsive.spacing(this, 16));
  }

  EdgeInsets get responsiveVerticalPadding {
    return EdgeInsets.symmetric(vertical: Responsive.spacing(this, 12));
  }
}

/// Responsive widget builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }
}

/// Responsive layout widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.desktop && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= Responsive.tablet &&
            tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}
