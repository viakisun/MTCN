import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

/// Reusable error state component
class ErrorState extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const ErrorState({super.key, this.title, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: DesignTokens.error,
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              title ?? '오류가 발생했습니다',
              style: const TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontSemibold,
                color: DesignTokens.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: DesignTokens.spacing2),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  color: DesignTokens.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: DesignTokens.spacing4),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing6,
                    vertical: DesignTokens.spacing3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: DesignTokens.neutral0,
                  size: 20,
                ),
                label: const Text(
                  '다시 시도',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSm,
                    fontWeight: DesignTokens.fontSemibold,
                    color: DesignTokens.neutral0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
