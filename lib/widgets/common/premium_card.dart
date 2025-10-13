import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';

enum PremiumCardStyle { elevated, glass, gradient, outlined }

class PremiumCard extends StatelessWidget {
  final Widget child;
  final PremiumCardStyle style;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final bool showShadow;
  final double? borderRadius;

  const PremiumCard({
    super.key,
    required this.child,
    this.style = PremiumCardStyle.elevated,
    this.padding,
    this.margin,
    this.onTap,
    this.gradient,
    this.backgroundColor,
    this.showShadow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? const EdgeInsets.all(DesignTokens.spacing4);
    final effectiveRadius = borderRadius ?? DesignTokens.radiusXl;

    Widget cardContent = Container(
      margin: margin,
      decoration: _getDecoration(effectiveRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: _buildCardContent(effectivePadding),
      ),
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }

  Widget _buildCardContent(EdgeInsetsGeometry effectivePadding) {
    switch (style) {
      case PremiumCardStyle.glass:
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.blurMd,
            sigmaY: DesignTokens.blurMd,
          ),
          child: Container(
            padding: effectivePadding,
            decoration: BoxDecoration(
              gradient: DesignTokens.gradientGlassmorphism,
              border: Border.all(
                color: DesignTokens.neutral0.withValues(
                  alpha: DesignTokens.opacity20,
                ),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        );

      case PremiumCardStyle.gradient:
        return Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            gradient: gradient ?? DesignTokens.gradientPrimary,
          ),
          child: DefaultTextStyle(
            style: const TextStyle(color: DesignTokens.textInverse),
            child: IconTheme(
              data: const IconThemeData(color: DesignTokens.textInverse),
              child: child,
            ),
          ),
        );

      case PremiumCardStyle.outlined:
        return Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? DesignTokens.surfacePrimary,
            border: Border.all(color: DesignTokens.borderDefault, width: 1),
          ),
          child: child,
        );

      case PremiumCardStyle.elevated:
        return Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? DesignTokens.surfacePrimary,
          ),
          child: child,
        );
    }
  }

  BoxDecoration _getDecoration(double effectiveRadius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(effectiveRadius),
      boxShadow: showShadow && style != PremiumCardStyle.outlined
          ? (style == PremiumCardStyle.glass
                ? DesignTokens.shadowLg
                : DesignTokens.shadowMd)
          : null,
    );
  }
}
