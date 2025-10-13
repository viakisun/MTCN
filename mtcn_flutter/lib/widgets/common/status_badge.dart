import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';

enum BadgeStyle { success, warning, error, info, neutral, live }

enum BadgeSize { small, medium, large }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeStyle style;
  final BadgeSize size;
  final IconData? icon;
  final bool showPulse;
  final bool outlined;

  const StatusBadge({
    super.key,
    required this.label,
    this.style = BadgeStyle.neutral,
    this.size = BadgeSize.medium,
    this.icon,
    this.showPulse = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : _getBackgroundColor(),
        border: outlined
            ? Border.all(color: _getBorderColor(), width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPulse || icon != null) ...[
            if (showPulse)
              Container(
                    width: _getDotSize(),
                    height: _getDotSize(),
                    decoration: BoxDecoration(
                      color: _getForegroundColor(),
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeOut(duration: 1000.ms)
                  .then()
                  .fadeIn(duration: 1000.ms)
            else if (icon != null)
              Icon(icon, size: _getIconSize(), color: _getForegroundColor()),
            SizedBox(width: _getSpacing()),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: size == BadgeSize.small
                  ? DesignTokens.fontMedium
                  : DesignTokens.fontSemibold,
              color: _getForegroundColor(),
              letterSpacing: size == BadgeSize.small
                  ? 0
                  : DesignTokens.letterSpacingWide,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing2,
          vertical: 2,
        );
      case BadgeSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing4,
          vertical: DesignTokens.spacing2,
        );
      case BadgeSize.medium:
      default:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing3,
          vertical: DesignTokens.spacing1,
        );
    }
  }

  double _getFontSize() {
    switch (size) {
      case BadgeSize.small:
        return DesignTokens.fontXs;
      case BadgeSize.large:
        return DesignTokens.fontBase;
      case BadgeSize.medium:
      default:
        return DesignTokens.fontSm;
    }
  }

  double _getIconSize() {
    switch (size) {
      case BadgeSize.small:
        return 12;
      case BadgeSize.large:
        return 18;
      case BadgeSize.medium:
      default:
        return 14;
    }
  }

  double _getDotSize() {
    switch (size) {
      case BadgeSize.small:
        return 6;
      case BadgeSize.large:
        return 10;
      case BadgeSize.medium:
      default:
        return 8;
    }
  }

  double _getSpacing() {
    return size == BadgeSize.small ? 4 : DesignTokens.spacing2;
  }

  Color _getBackgroundColor() {
    switch (style) {
      case BadgeStyle.success:
        return DesignTokens.successLight;
      case BadgeStyle.warning:
        return DesignTokens.warningLight;
      case BadgeStyle.error:
        return DesignTokens.errorLight;
      case BadgeStyle.info:
        return DesignTokens.infoLight;
      case BadgeStyle.live:
        return DesignTokens.primary100;
      case BadgeStyle.neutral:
      default:
        return DesignTokens.neutral100;
    }
  }

  Color _getBorderColor() {
    switch (style) {
      case BadgeStyle.success:
        return DesignTokens.success;
      case BadgeStyle.warning:
        return DesignTokens.warning;
      case BadgeStyle.error:
        return DesignTokens.error;
      case BadgeStyle.info:
        return DesignTokens.info;
      case BadgeStyle.live:
        return DesignTokens.primary600;
      case BadgeStyle.neutral:
      default:
        return DesignTokens.neutral400;
    }
  }

  Color _getForegroundColor() {
    if (outlined) {
      return _getBorderColor();
    }

    switch (style) {
      case BadgeStyle.success:
        return DesignTokens.successDark;
      case BadgeStyle.warning:
        return DesignTokens.warningDark;
      case BadgeStyle.error:
        return DesignTokens.errorDark;
      case BadgeStyle.info:
        return DesignTokens.infoDark;
      case BadgeStyle.live:
        return DesignTokens.primary700;
      case BadgeStyle.neutral:
      default:
        return DesignTokens.neutral700;
    }
  }
}

// Preset status badges for common use cases
class LiveBadge extends StatelessWidget {
  final BadgeSize size;

  const LiveBadge({super.key, this.size = BadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return const StatusBadge(
      label: 'LIVE',
      style: BadgeStyle.live,
      showPulse: true,
    );
  }
}

class ScheduledBadge extends StatelessWidget {
  final BadgeSize size;

  const ScheduledBadge({super.key, this.size = BadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: 'Scheduled',
      style: BadgeStyle.info,
      size: size,
      icon: Icons.schedule,
    );
  }
}

class CompletedBadge extends StatelessWidget {
  final BadgeSize size;

  const CompletedBadge({super.key, this.size = BadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: 'Completed',
      style: BadgeStyle.success,
      size: size,
      icon: Icons.check_circle,
    );
  }
}
