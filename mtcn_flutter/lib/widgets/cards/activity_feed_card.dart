import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import '../../widgets/common/avatar.dart';

enum ActivityType {
  scorePosted,
  roundingJoined,
  groupCreated,
  achievement,
  friendRequest,
}

class Activity {
  final String id;
  final ActivityType type;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime timestamp;
  final int? score;
  final String? courseName;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  Activity({
    required this.id,
    required this.type,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    this.score,
    this.courseName,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });
}

class ActivityFeedCard extends StatefulWidget {
  final Activity activity;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const ActivityFeedCard({
    super.key,
    required this.activity,
    this.onLike,
    this.onComment,
  });

  @override
  State<ActivityFeedCard> createState() => _ActivityFeedCardState();
}

class _ActivityFeedCardState extends State<ActivityFeedCard> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.activity.isLiked;
  }

  IconData _getActivityIcon() {
    switch (widget.activity.type) {
      case ActivityType.scorePosted:
        return Icons.golf_course;
      case ActivityType.roundingJoined:
        return Icons.event;
      case ActivityType.groupCreated:
        return Icons.group_add;
      case ActivityType.achievement:
        return Icons.emoji_events;
      case ActivityType.friendRequest:
        return Icons.person_add;
    }
  }

  Color _getActivityColor() {
    switch (widget.activity.type) {
      case ActivityType.scorePosted:
        return DesignTokens.success;
      case ActivityType.roundingJoined:
        return DesignTokens.info;
      case ActivityType.groupCreated:
        return DesignTokens.primary600;
      case ActivityType.achievement:
        return const Color(0xFFFFD700);
      case ActivityType.friendRequest:
        return const Color(0xFF667eea);
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(widget.activity.timestamp);

    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7}주 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Avatar(
                imageUrl: widget.activity.userAvatar,
                name: widget.activity.userName,
                size: AvatarSize.medium,
              ),
              const SizedBox(width: DesignTokens.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.activity.userName,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontBase,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacing2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacing2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getActivityColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusFull,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getActivityIcon(),
                                size: 12,
                                color: _getActivityColor(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getActivityTypeText(),
                                style: TextStyle(
                                  fontSize: DesignTokens.fontXs,
                                  fontWeight: DesignTokens.fontMedium,
                                  color: _getActivityColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getTimeAgo(),
                      style: const TextStyle(
                        fontSize: DesignTokens.fontXs,
                        color: DesignTokens.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacing3),

          // Content
          Text(
            widget.activity.content,
            style: const TextStyle(
              fontSize: DesignTokens.fontBase,
              color: DesignTokens.textPrimary,
              height: 1.5,
            ),
          ),

          // Score Info (if applicable)
          if (widget.activity.score != null &&
              widget.activity.courseName != null) ...[
            const SizedBox(height: DesignTokens.spacing3),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacing3),
              decoration: BoxDecoration(
                gradient: DesignTokens.gradientEucalyptus,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.golf_course, color: Colors.white, size: 20),
                  const SizedBox(width: DesignTokens.spacing2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.activity.courseName!,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '총 ${widget.activity.score}타',
                          style: const TextStyle(
                            fontSize: DesignTokens.fontXs,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacing3,
                      vertical: DesignTokens.spacing2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusFull,
                      ),
                    ),
                    child: Text(
                      '${widget.activity.score}',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontLg,
                        fontWeight: DesignTokens.fontBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: DesignTokens.spacing3),

          // Interaction Buttons
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                  widget.onLike?.call();
                },
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing2,
                    vertical: DesignTokens.spacing1,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: _isLiked
                            ? DesignTokens.error
                            : DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.activity.likeCount + (_isLiked && !widget.activity.isLiked ? 1 : 0)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: _isLiked
                              ? DesignTokens.error
                              : DesignTokens.textSecondary,
                          fontWeight: DesignTokens.fontMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacing4),
              InkWell(
                onTap: widget.onComment,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing2,
                    vertical: DesignTokens.spacing1,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 18,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.activity.commentCount}',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                          fontWeight: DesignTokens.fontMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  // Share functionality
                },
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                child: const Padding(
                  padding: EdgeInsets.all(DesignTokens.spacing1),
                  child: Icon(
                    Icons.share,
                    size: 18,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getActivityTypeText() {
    switch (widget.activity.type) {
      case ActivityType.scorePosted:
        return '스코어 기록';
      case ActivityType.roundingJoined:
        return '라운딩 참가';
      case ActivityType.groupCreated:
        return '그룹 생성';
      case ActivityType.achievement:
        return '업적 달성';
      case ActivityType.friendRequest:
        return '친구 요청';
    }
  }
}
