import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

/// Reusable loading state component
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.primary600),
          ),
          if (message != null) ...[
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              message!,
              style: const TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
