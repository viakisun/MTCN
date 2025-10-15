import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/enums/group_enums.dart';
import '../../core/enums/rounding_enums.dart';
import '../../data/models/group.dart';
import '../../data/models/rounding.dart';
import '../../data/services/mock_database_service.dart';
import '../../widgets/common/avatar.dart';
import '../../providers/group_provider.dart';
import 'member_list_page.dart';
import 'member_management_page.dart';
import 'group_chat_page.dart';

class GroupDetailPage extends ConsumerStatefulWidget {
  final Group group;

  const GroupDetailPage({super.key, required this.group});

  @override
  ConsumerState<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends ConsumerState<GroupDetailPage> {
  final MockDatabaseService _dbService = MockDatabaseService();
  final String _currentUserId =
      'player_1'; // TODO: Get from actual auth service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '그룹 상세',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: DesignTokens.textPrimary,
              size: 20,
            ),
            onPressed: () {
              // TODO: Implement share
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('공유 기능은 준비 중입니다')));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: DesignTokens.textPrimary,
              size: 20,
            ),
            onPressed: () {
              _showGroupOptions(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header
            _buildGroupHeader(),
            const SizedBox(height: DesignTokens.spacing4),

            // Live Score Button (if active rounding exists)
            _buildLiveScoreButton(),
            const SizedBox(height: DesignTokens.spacing4),

            // Group Description (if exists)
            if (widget.group.description.isNotEmpty) ...[
              _buildGroupDescription(),
              const SizedBox(height: DesignTokens.spacing4),
            ],

            // Members Section
            _buildMembersSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Recent Roundings Section
            _buildRecentRoundingsSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Group Settings (for admin/owner only)
            if (_isAdmin()) _buildGroupSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowMd,
      ),
      child: Column(
        children: [
          // Group Image/Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: widget.group.isPremium
                  ? DesignTokens.gradientGold
                  : DesignTokens.gradientEucalyptus,
              shape: BoxShape.circle,
              boxShadow: DesignTokens.shadowMd,
            ),
            child: const Icon(
              Icons.groups,
              size: 50,
              color: DesignTokens.neutral0,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing3),

          // Group Name
          Text(
            widget.group.name,
            style: const TextStyle(
              fontSize: DesignTokens.font2xl,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing2),

          // Group Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people,
                size: 16,
                color: DesignTokens.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.group.members.length}명',
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  color: DesignTokens.textSecondary,
                ),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              const Icon(
                Icons.golf_course,
                size: 16,
                color: DesignTokens.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.group.roundCount}회',
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing3),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupChatPage(group: widget.group),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignTokens.primary600,
                    foregroundColor: DesignTokens.neutral0,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacing3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusLg,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text(
                    '채팅',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontSemibold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showInviteDialog(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacing3,
                    ),
                    side: const BorderSide(color: DesignTokens.neutral300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusLg,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.person_add,
                    color: DesignTokens.textPrimary,
                    size: 18,
                  ),
                  label: const Text(
                    '초대',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontSemibold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildLiveScoreButton() {
    return FutureBuilder<List<Rounding>>(
      future: _getActiveRoundings(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final activeRounding = snapshot.data!.first;
          return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacing4),
                decoration: BoxDecoration(
                  gradient: DesignTokens.gradientEucalyptus,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                  boxShadow: DesignTokens.shadowMd,
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('라이브 스코어 기능은 준비 중입니다')),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .fadeOut(duration: 1000.ms)
                          .then()
                          .fadeIn(duration: 1000.ms),
                      const SizedBox(width: DesignTokens.spacing2),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontBold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '진행 중인 라운딩',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${activeRounding.title} • 실시간 스코어 확인',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontBase,
                                fontWeight: DesignTokens.fontSemibold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGroupDescription() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            border: Border.all(color: DesignTokens.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '소개',
                style: TextStyle(
                  fontSize: DesignTokens.fontBase,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing2),
              Text(
                widget.group.description,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  color: DesignTokens.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMembersSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            border: Border.all(color: DesignTokens.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '멤버 (${widget.group.members.length})',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MemberListPage(group: widget.group),
                        ),
                      );
                    },
                    child: const Text(
                      '전체보기',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.primary600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing3),

              // Member Avatars (show first 5)
              Row(
                children: [
                  ...widget.group.members.take(5).map((member) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: DesignTokens.spacing2,
                      ),
                      child: Avatar(
                        imageUrl: member.player.avatar,
                        name: member.player.name,
                        size: AvatarSize.medium,
                      ),
                    );
                  }),
                  if (widget.group.members.length > 5)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: DesignTokens.neutral100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '+${widget.group.members.length - 5}',
                          style: const TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildRecentRoundingsSection() {
    return FutureBuilder<List<Rounding>>(
      future: _getRecentRoundings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final roundings = snapshot.data ?? [];

        if (roundings.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: BoxDecoration(
                color: DesignTokens.neutral0,
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                border: Border.all(color: DesignTokens.neutral200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '최근 라운딩',
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing3),
                  ...roundings.map((rounding) => _buildRoundingCard(rounding)),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildRoundingCard(Rounding rounding) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      padding: const EdgeInsets.all(DesignTokens.spacing3),
      decoration: BoxDecoration(
        color: DesignTokens.neutral50,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(color: DesignTokens.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: DesignTokens.primary100,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            ),
            child: const Icon(
              Icons.golf_course,
              color: DesignTokens.primary600,
              size: 20,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rounding.title,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    fontWeight: DesignTokens.fontSemibold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rounding.courseName} • ${_formatDate(rounding.date)}',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontXs,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: DesignTokens.neutral400,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSettings() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            border: Border.all(color: DesignTokens.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '그룹 설정',
                style: TextStyle(
                  fontSize: DesignTokens.fontBase,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              ListTile(
                leading: const Icon(Icons.edit, color: DesignTokens.primary600),
                title: const Text('그룹 정보 수정'),
                subtitle: const Text('이름, 설명, 공개 설정 변경'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showEditGroupDialog(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: DesignTokens.primary600,
                ),
                title: const Text('멤버 관리'),
                subtitle: const Text('멤버 초대, 역할 변경, 제거'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MemberManagementPage(group: widget.group),
                    ),
                  );
                },
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Future<List<Rounding>> _getActiveRoundings() async {
    final allRoundings = await _dbService.getRoundings();
    return allRoundings.where((rounding) {
      return rounding.status == RoundingStatus.inProgress &&
          _hasGroupMember(rounding);
    }).toList();
  }

  Future<List<Rounding>> _getRecentRoundings() async {
    final allRoundings = await _dbService.getRoundings();
    final groupRoundings = allRoundings.where((rounding) {
      return rounding.status == RoundingStatus.completed &&
          _hasGroupMember(rounding);
    }).toList();

    // Sort by date, take last 3
    groupRoundings.sort((a, b) => b.date.compareTo(a.date));
    return groupRoundings.take(3).toList();
  }

  bool _hasGroupMember(Rounding rounding) {
    return rounding.players.any(
      (player) =>
          widget.group.members.any((member) => member.playerId == player.id),
    );
  }

  bool _isAdmin() {
    try {
      final member = widget.group.members.firstWhere(
        (m) => m.playerId == _currentUserId,
      );
      return member.role == MemberRole.admin || member.role == MemberRole.owner;
    } catch (e) {
      // Current user is not a member of this group
      return false;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}';
    } catch (e) {
      return dateString;
    }
  }

  void _showGroupOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        decoration: const BoxDecoration(
          color: DesignTokens.neutral0,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusXl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: DesignTokens.primary600),
              title: const Text('그룹 공유'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('공유 기능은 준비 중입니다')));
              },
            ),
            if (_isAdmin()) ...[
              ListTile(
                leading: const Icon(Icons.edit, color: DesignTokens.primary600),
                title: const Text('그룹 정보 수정'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditGroupDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: DesignTokens.primary600,
                ),
                title: const Text('멤버 관리'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MemberManagementPage(group: widget.group),
                    ),
                  );
                },
              ),
            ],
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: DesignTokens.primary600,
              ),
              title: const Text('그룹 정보'),
              onTap: () {
                Navigator.pop(context);
                _showGroupInfoDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context) {
    final nameController = TextEditingController(text: widget.group.name);
    final descriptionController = TextEditingController(
      text: widget.group.description,
    );
    bool isPublic = widget.group.isPublic;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('그룹 정보 수정'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '그룹 이름',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing3),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '그룹 설명',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: DesignTokens.spacing3),
                SwitchListTile(
                  title: const Text('공개 그룹'),
                  subtitle: const Text('다른 사용자가 찾을 수 있습니다'),
                  value: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value;
                    });
                  },
                  activeThumbColor: DesignTokens.primary600,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedGroup = widget.group.copyWith(
                  name: nameController.text,
                  description: descriptionController.text,
                  isPublic: isPublic,
                );

                try {
                  await ref
                      .read(groupListProvider.notifier)
                      .updateGroup(updatedGroup);
                  if (context.mounted) {
                    Navigator.pop(context);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('그룹 정보가 수정되었습니다')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('오류: $e')));
                  }
                }
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.group.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('설명', widget.group.description),
            _buildInfoRow('멤버 수', '${widget.group.members.length}명'),
            _buildInfoRow('라운딩 횟수', '${widget.group.roundCount}회'),
            _buildInfoRow('공개 여부', widget.group.isPublic ? '공개' : '비공개'),
            _buildInfoRow('생성일', _formatFullDate(widget.group.createdAt)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: DesignTokens.fontMedium,
                color: DesignTokens.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: DesignTokens.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  void _showInviteDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('멤버 초대'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '이메일 주소',
                hintText: '초대할 사용자의 이메일을 입력하세요',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual invitation logic
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('초대 기능은 준비 중입니다')));
            },
            child: const Text('초대'),
          ),
        ],
      ),
    );
  }
}
