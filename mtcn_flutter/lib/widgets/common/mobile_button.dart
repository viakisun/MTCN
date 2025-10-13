import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/design_tokens.dart';

/// Mobile-optimized button with minimum touch target of 48x48
class MobileButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final MobileButtonStyle style;
  final MobileButtonSize size;
  final bool isLoading;
  final bool fullWidth;

  const MobileButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.style = MobileButtonStyle.primary,
    this.size = MobileButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          disabledBackgroundColor: DesignTokens.neutral200,
          disabledForegroundColor: DesignTokens.textDisabled,
          elevation: style == MobileButtonStyle.primary ? 2 : 0,
          shadowColor: style == MobileButtonStyle.primary
              ? DesignTokens.primary600.withOpacity(0.3)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            side: style == MobileButtonStyle.outlined
                ? const BorderSide(color: DesignTokens.primary600, width: 1.5)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: _getVerticalPadding(),
          ),
          minimumSize: const Size(48, 48), // Accessibility touch target
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _getIconSize()),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: _getFontSize(),
                      fontWeight: DesignTokens.fontSemibold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case MobileButtonSize.small:
        return 40;
      case MobileButtonSize.medium:
        return 48;
      case MobileButtonSize.large:
        return 56;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case MobileButtonSize.small:
        return DesignTokens.radiusMd;
      case MobileButtonSize.medium:
        return DesignTokens.radiusLg;
      case MobileButtonSize.large:
        return DesignTokens.radiusXl;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case MobileButtonSize.small:
        return 16;
      case MobileButtonSize.medium:
        return 24;
      case MobileButtonSize.large:
        return 32;
    }
  }

  double _getVerticalPadding() {
    return 0; // Height is controlled by button height
  }

  double _getFontSize() {
    switch (size) {
      case MobileButtonSize.small:
        return DesignTokens.fontSm;
      case MobileButtonSize.medium:
        return DesignTokens.fontBase;
      case MobileButtonSize.large:
        return DesignTokens.fontLg;
    }
  }

  double _getIconSize() {
    switch (size) {
      case MobileButtonSize.small:
        return 18;
      case MobileButtonSize.medium:
        return 20;
      case MobileButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor() {
    switch (style) {
      case MobileButtonStyle.primary:
        return DesignTokens.primary600;
      case MobileButtonStyle.secondary:
        return DesignTokens.secondary600;
      case MobileButtonStyle.outlined:
        return Colors.transparent;
      case MobileButtonStyle.ghost:
        return Colors.transparent;
      case MobileButtonStyle.danger:
        return DesignTokens.error;
    }
  }

  Color _getForegroundColor() {
    switch (style) {
      case MobileButtonStyle.primary:
      case MobileButtonStyle.secondary:
      case MobileButtonStyle.danger:
        return DesignTokens.neutral0;
      case MobileButtonStyle.outlined:
      case MobileButtonStyle.ghost:
        return DesignTokens.primary600;
    }
  }
}

enum MobileButtonStyle { primary, secondary, outlined, ghost, danger }

enum MobileButtonSize { small, medium, large }

/// Mobile-optimized icon button with minimum touch target
class MobileIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  const MobileIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: 48, // Minimum touch target
      height: 48,
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            )
          : null,
      child: IconButton(
        onPressed: onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        icon: Icon(icon, size: size),
        color: color ?? DesignTokens.textPrimary,
        splashRadius: 24,
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Mobile-optimized FAB (Floating Action Button)
class MobileFAB extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isExtended;
  final String? heroTag;

  const MobileFAB({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isExtended = true,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (isExtended) {
      return FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: () {
          HapticFeedback.mediumImpact();
          onPressed();
        },
        backgroundColor: DesignTokens.primary600,
        foregroundColor: DesignTokens.neutral0,
        elevation: 4,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            letterSpacing: 0.2,
          ),
        ),
      );
    }

    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      backgroundColor: DesignTokens.primary600,
      foregroundColor: DesignTokens.neutral0,
      elevation: 4,
      child: Icon(icon, size: 28),
    );
  }
}
