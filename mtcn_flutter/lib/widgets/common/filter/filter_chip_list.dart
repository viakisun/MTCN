import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

/// Model for filter options
class FilterOption {
  final String label;
  final String value;

  const FilterOption({required this.label, required this.value});
}

/// Reusable filter chip list component
class FilterChipList extends StatelessWidget {
  final List<FilterOption> options;
  final String activeValue;
  final ValueChanged<String> onChanged;

  const FilterChipList({
    super.key,
    required this.options,
    required this.activeValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          return Padding(
            padding: const EdgeInsets.only(right: DesignTokens.spacing2),
            child: _buildFilterChip(
              label: option.label,
              value: option.value,
              isActive: activeValue == option.value,
              onTap: () => onChanged(option.value),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing4,
          vertical: DesignTokens.spacing2,
        ),
        decoration: BoxDecoration(
          color: isActive ? DesignTokens.primary600 : DesignTokens.neutral0,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: isActive ? DesignTokens.primary600 : DesignTokens.neutral300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontMedium,
            color: isActive
                ? DesignTokens.neutral0
                : DesignTokens.textSecondary,
          ),
        ),
      ),
    );
  }
}
