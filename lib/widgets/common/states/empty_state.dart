import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

/// Reusable empty state component
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  /// Empty state for search results
  factory EmptyState.search({String query = ''}) {
    return EmptyState(
      icon: Icons.search_off,
      title: '검색 결과가 없습니다',
      message: query.isNotEmpty ? '"$query"에 대한 결과를 찾을 수 없습니다' : null,
    );
  }

  /// Empty state for no items
  factory EmptyState.noItems({
    required String itemName,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: '$itemName이(가) 없습니다',
      message: '$itemName을(를) 추가해보세요',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: DesignTokens.neutral300),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              title,
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
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DesignTokens.spacing4),
              ElevatedButton(
                onPressed: onAction,
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
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
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
