import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';

enum PremiumButtonStyle { primary, secondary, outline, ghost, gradient }

enum PremiumButtonSize { small, medium, large }

class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonStyle style;
  final PremiumButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Gradient? gradient;

  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = PremiumButtonStyle.primary,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.gradient,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
          onTapDown: isEnabled
              ? (_) => setState(() => _isPressed = true)
              : null,
          onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: isEnabled
              ? () => setState(() => _isPressed = false)
              : null,
          onTap: isEnabled ? widget.onPressed : null,
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : 1.0,
            duration: DesignTokens.durationFast,
            curve: DesignTokens.curveSnappy,
            child: Container(
              width: widget.fullWidth ? double.infinity : null,
              padding: _getPadding(),
              decoration: _getDecoration(isEnabled),
              child: Row(
                mainAxisSize: widget.fullWidth
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(isEnabled),
                        ),
                      ),
                    )
                  else if (widget.icon != null)
                    Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getTextColor(isEnabled),
                    ),
                  if ((widget.icon != null || widget.isLoading) &&
                      widget.label.isNotEmpty)
                    SizedBox(width: _getSpacing()),
                  if (widget.label.isNotEmpty)
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: _getFontSize(),
                        fontWeight: DesignTokens.fontSemibold,
                        color: _getTextColor(isEnabled),
                        letterSpacing: DesignTokens.letterSpacingWide,
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
        .animate(target: _isPressed ? 1 : 0)
        .shimmer(
          duration: DesignTokens.durationNormal,
          color: Colors.white.withOpacity(0.3),
        );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing3,
          vertical: DesignTokens.spacing2,
        );
      case PremiumButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing6,
          vertical: DesignTokens.spacing4,
        );
      case PremiumButtonSize.medium:
      default:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing5,
          vertical: DesignTokens.spacing3,
        );
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return DesignTokens.fontSm;
      case PremiumButtonSize.large:
        return DesignTokens.fontLg;
      case PremiumButtonSize.medium:
      default:
        return DesignTokens.fontBase;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return 16;
      case PremiumButtonSize.large:
        return 24;
      case PremiumButtonSize.medium:
      default:
        return 20;
    }
  }

  double _getSpacing() {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return DesignTokens.spacing1;
      case PremiumButtonSize.large:
        return DesignTokens.spacing3;
      case PremiumButtonSize.medium:
      default:
        return DesignTokens.spacing2;
    }
  }

  BoxDecoration _getDecoration(bool isEnabled) {
    final radius = BorderRadius.circular(
      widget.size == PremiumButtonSize.large
          ? DesignTokens.radiusLg
          : DesignTokens.radiusMd,
    );

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return BoxDecoration(
          color: isEnabled ? DesignTokens.primary600 : DesignTokens.neutral300,
          borderRadius: radius,
          boxShadow: isEnabled ? DesignTokens.shadowPrimary : null,
        );

      case PremiumButtonStyle.secondary:
        return BoxDecoration(
          color: isEnabled
              ? DesignTokens.secondary600
              : DesignTokens.neutral300,
          borderRadius: radius,
          boxShadow: isEnabled ? DesignTokens.shadowSecondary : null,
        );

      case PremiumButtonStyle.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: isEnabled
                ? DesignTokens.primary600
                : DesignTokens.neutral300,
            width: 2,
          ),
        );

      case PremiumButtonStyle.ghost:
        return BoxDecoration(
          color: isEnabled
              ? DesignTokens.primary600.withOpacity(DesignTokens.opacity10)
              : DesignTokens.neutral200,
          borderRadius: radius,
        );

      case PremiumButtonStyle.gradient:
        return BoxDecoration(
          gradient: isEnabled
              ? (widget.gradient ?? DesignTokens.gradientPrimary)
              : null,
          color: isEnabled ? null : DesignTokens.neutral300,
          borderRadius: radius,
          boxShadow: isEnabled ? DesignTokens.shadowLg : null,
        );
    }
  }

  Color _getTextColor(bool isEnabled) {
    if (!isEnabled) {
      return DesignTokens.textDisabled;
    }

    switch (widget.style) {
      case PremiumButtonStyle.primary:
      case PremiumButtonStyle.secondary:
      case PremiumButtonStyle.gradient:
        return DesignTokens.textInverse;

      case PremiumButtonStyle.outline:
      case PremiumButtonStyle.ghost:
        return DesignTokens.primary600;
    }
  }
}
