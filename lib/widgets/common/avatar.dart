import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/player.dart';

enum AvatarSize { small, medium, large, xLarge, xxLarge }

enum PlayerTier {
  pro, // Handicap 0-5
  expert, // Handicap 6-12
  intermediate, // Handicap 13-20
  beginner, // Handicap 21+
}

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final AvatarSize size;
  final bool showBorder;
  final Player? player; // Optional player for tier display
  final VoidCallback? onTap; // Optional tap handler

  const Avatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = AvatarSize.medium,
    this.showBorder = false,
    this.player,
    this.onTap,
  });

  double get _diameter {
    switch (size) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 40;
      case AvatarSize.large:
        return 56;
      case AvatarSize.xLarge:
        return 80;
      case AvatarSize.xxLarge:
        return 120;
    }
  }

  double get _fontSize {
    switch (size) {
      case AvatarSize.small:
        return DesignTokens.fontSm;
      case AvatarSize.medium:
        return DesignTokens.fontBase;
      case AvatarSize.large:
        return DesignTokens.fontLg;
      case AvatarSize.xLarge:
        return DesignTokens.font2xl;
      case AvatarSize.xxLarge:
        return DesignTokens.font3xl;
    }
  }

  PlayerTier? get _tier {
    if (player == null) return null;

    final handicap = player!.handicap;
    if (handicap <= 5) return PlayerTier.pro;
    if (handicap <= 12) return PlayerTier.expert;
    if (handicap <= 20) return PlayerTier.intermediate;
    return PlayerTier.beginner;
  }

  Color get _tierBorderColor {
    switch (_tier) {
      case PlayerTier.pro:
        return const Color(0xFFFFD700); // Gold
      case PlayerTier.expert:
        return const Color(0xFFC0C0C0); // Silver
      case PlayerTier.intermediate:
        return const Color(0xFFCD7F32); // Bronze
      case PlayerTier.beginner:
        return const Color(0xFF8B4513); // Brown
      case null:
        return DesignTokens.neutral300;
    }
  }

  List<BoxShadow>? get _tierGlow {
    switch (_tier) {
      case PlayerTier.pro:
        return [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ];
      case PlayerTier.expert:
        return [
          BoxShadow(
            color: const Color(0xFFC0C0C0).withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ];
      case PlayerTier.intermediate:
        return [
          BoxShadow(
            color: const Color(0xFFCD7F32).withValues(alpha: 0.3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ];
      case PlayerTier.beginner:
        return null; // No glow for beginners
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final gradient = _getGradientForName(name);
    final hasTier = _tier != null && _tier != PlayerTier.beginner;

    Widget avatarWidget = Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: (showBorder || hasTier)
            ? Border.all(
                color: hasTier ? _tierBorderColor : DesignTokens.neutral0,
                width: hasTier ? 3 : 2,
              )
            : null,
        boxShadow: hasTier
            ? _tierGlow
            : (showBorder ? DesignTokens.shadowMd : null),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitialAvatar(initials, gradient),
              )
            : _buildInitialAvatar(initials, gradient),
      ),
    );

    // Add tier badge if applicable
    if (hasTier) {
      avatarWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned(right: -2, bottom: -2, child: _buildTierBadge()),
        ],
      );
    }

    // Make tappable if onTap is provided
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatarWidget);
    }

    return avatarWidget;
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    if (name.length == 1) return name[0].toUpperCase();

    // 한글 이름인 경우 성을 제외한 이름 2글자
    if (name.length == 3) {
      return name.substring(1, 3); // 예: 김민수 → 민수
    } else if (name.length == 2) {
      return name; // 예: 민수 → 민수
    } else {
      // 영어 이름이나 긴 이름의 경우 첫 2글자
      return name.substring(0, 2).toUpperCase();
    }
  }

  LinearGradient _getGradientForName(String name) {
    // 이름을 기반으로 고유한 그라디언트 선택
    final hash = name.hashCode.abs();
    final gradients = [
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo to Purple
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)], // Cyan to Blue
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF10B981), Color(0xFF059669)], // Emerald
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF59E0B), Color(0xFFEF4444)], // Amber to Red
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)], // Pink to Purple
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)], // Teal to Cyan
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)], // Purple to Pink
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)], // Blue to Cyan
      ),
    ];

    return gradients[hash % gradients.length];
  }

  Widget _buildTierBadge() {
    final badgeSize = _diameter * 0.28; // Badge size relative to avatar
    IconData icon;

    switch (_tier) {
      case PlayerTier.pro:
        icon = Icons.emoji_events; // Trophy
        break;
      case PlayerTier.expert:
        icon = Icons.star;
        break;
      case PlayerTier.intermediate:
        icon = Icons.trending_up;
        break;
      case PlayerTier.beginner:
        icon = Icons.sports_golf;
        break;
      case null:
        icon = Icons.person;
        break;
    }

    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: _tierBorderColor,
        shape: BoxShape.circle,
        border: Border.all(color: DesignTokens.neutral0, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: badgeSize * 0.55, color: DesignTokens.neutral900),
    );
  }

  Widget _buildInitialAvatar(String initials, LinearGradient gradient) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: DesignTokens.neutral0,
            fontSize: _fontSize,
            fontWeight: DesignTokens.fontBold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
