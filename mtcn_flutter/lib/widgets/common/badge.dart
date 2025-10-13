import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';

enum BadgeVariant { primary, secondary, success, warning, error, info }

enum BadgeSize { small, medium, large }

class Badge extends StatelessWidget {
  final String? text;
  final String? label; // Alias for text
  final BadgeVariant variant;
  final BadgeSize size;

  const Badge({
    super.key,
    this.text,
    this.label,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.medium,
  }) : assert(
         text != null || label != null,
         'Either text or label must be provided',
       );

  Color get _backgroundColor {
    switch (variant) {
      case BadgeVariant.primary:
        return DesignTokens.primary100;
      case BadgeVariant.secondary:
        return DesignTokens.secondary100;
      case BadgeVariant.success:
        return DesignTokens.successLight;
      case BadgeVariant.warning:
        return DesignTokens.warningLight;
      case BadgeVariant.error:
        return DesignTokens.errorLight;
      case BadgeVariant.info:
        return DesignTokens.infoLight;
    }
  }

  Color get _textColor {
    switch (variant) {
      case BadgeVariant.primary:
        return DesignTokens.primary700;
      case BadgeVariant.secondary:
        return DesignTokens.secondary700;
      case BadgeVariant.success:
        return DesignTokens.success;
      case BadgeVariant.warning:
        return DesignTokens.warning;
      case BadgeVariant.error:
        return DesignTokens.error;
      case BadgeVariant.info:
        return DesignTokens.info;
    }
  }

  EdgeInsets get _padding {
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

  double get _fontSize {
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

  @override
  Widget build(BuildContext context) {
    final displayText = text ?? label!;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: DesignTokens.fontMedium,
          color: _textColor,
        ),
      ),
    );
  }
}
