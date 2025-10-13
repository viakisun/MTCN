import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/group.dart';
import '../../models/player.dart';
import '../../models/group_member.dart';
import '../../widgets/common/avatar.dart';
import '../../widgets/common/badge.dart' as custom;
import '../../services/group_member_service.dart';
import '../../providers/auth_provider.dart';

class MemberManagementPage extends ConsumerStatefulWidget {
  final Group group;

  const MemberManagementPage({super.key, required this.group});

  @override
  ConsumerState<MemberManagementPage> createState() =>
      _MemberManagementPageState();
}

class _MemberManagementPageState extends ConsumerState<MemberManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GroupMemberService _memberService = GroupMemberService.instance;

  List<GroupMember> _pendingMembers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPendingMembers();
  }

  Future<void> _loadPendingMembers() async {
    setState(() {
      _isLoading = true;
    });

    final pending = await _memberService.getPendingMembers(widget.group.id);

    if (mounted) {
      setState(() {
        _pendingMembers = pending;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          '멤버 관리',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: DesignTokens.primary600,
          unselectedLabelColor: DesignTokens.textSecondary,
          indicatorColor: DesignTokens.primary600,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('현재 멤버'),
                  const SizedBox(width: DesignTokens.spacing1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: DesignTokens.primary600.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusFull,
                      ),
                    ),
                    child: Text(
                      '${widget.group.members.length}',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontXs,
                        fontWeight: DesignTokens.fontBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('가입 승인'),
                  if (_pendingMembers.isNotEmpty) ...[
                    const SizedBox(width: DesignTokens.spacing1),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: DesignTokens.error,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusFull,
                        ),
                      ),
                      child: Text(
                        '${_pendingMembers.length}',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontXs,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMembersTab(), _buildPendingRequestsTab()],
      ),
    );
  }

  Widget _buildMembersTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      itemCount: widget.group.members.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: DesignTokens.spacing3),
      itemBuilder: (context, index) {
        final member = widget.group.members[index];
        final isAdmin = index == 0; // First member is admin for demo

        return _buildMemberManagementCard(member, isAdmin)
            .animate()
            .fadeIn(duration: 500.ms, delay: (index * 50).ms)
            .slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildPendingRequestsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pendingMembers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: DesignTokens.gradientEucalyptus,
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: DesignTokens.neutral0,
              ),
            ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),
            const SizedBox(height: DesignTokens.spacing4),
            const Text(
              '모든 요청을 처리했습니다',
              style: TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontSemibold,
                color: DesignTokens.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: DesignTokens.spacing2),
            const Text(
              '새로운 가입 요청이 없습니다',
              style: TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      itemCount: _pendingMembers.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: DesignTokens.spacing3),
      itemBuilder: (context, index) {
        final member = _pendingMembers[index];
        return _buildPendingRequestCard(member, index);
      },
    );
  }

  Widget _buildMemberManagementCard(Player member, bool isAdmin) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          // Avatar
          Avatar(
            imageUrl: member.avatar,
            name: member.name,
            size: AvatarSize.large,
          ),
          const SizedBox(width: DesignTokens.spacing3),

          // Member Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontLg,
                        fontWeight: DesignTokens.fontBold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: DesignTokens.spacing2),
                      custom.Badge(
                        text: '관리자',
                        variant: custom.BadgeVariant.info,
                        size: custom.BadgeSize.small,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: DesignTokens.spacing1),
                Row(
                  children: [
                    const Icon(
                      Icons.golf_course,
                      size: 14,
                      color: DesignTokens.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '평균 ${member.averageScore}타',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    const Icon(
                      Icons.emoji_events,
                      size: 14,
                      color: DesignTokens.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '최고 ${member.bestScore}타',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Role Dropdown
          PopupMenuButton<MemberRole>(
            icon: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing3,
                vertical: DesignTokens.spacing2,
              ),
              decoration: BoxDecoration(
                color: isAdmin
                    ? DesignTokens.info.withValues(alpha: 0.1)
                    : DesignTokens.neutral100,
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                border: Border.all(
                  color: isAdmin ? DesignTokens.info : DesignTokens.neutral200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAdmin ? '관리자' : '멤버',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontMedium,
                      color: isAdmin
                          ? DesignTokens.info
                          : DesignTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: isAdmin
                        ? DesignTokens.info
                        : DesignTokens.textSecondary,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MemberRole.admin,
                child: Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 20,
                      color: isAdmin
                          ? DesignTokens.info
                          : DesignTokens.textPrimary,
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    Text(
                      '관리자',
                      style: TextStyle(
                        color: isAdmin
                            ? DesignTokens.info
                            : DesignTokens.textPrimary,
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: DesignTokens.spacing2),
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: DesignTokens.info,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: MemberRole.member,
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: !isAdmin
                          ? DesignTokens.primary600
                          : DesignTokens.textPrimary,
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    Text(
                      '멤버',
                      style: TextStyle(
                        color: !isAdmin
                            ? DesignTokens.primary600
                            : DesignTokens.textPrimary,
                      ),
                    ),
                    if (!isAdmin) ...[
                      const SizedBox(width: DesignTokens.spacing2),
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: DesignTokens.primary600,
                      ),
                    ],
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: null,
                child: Row(
                  children: const [
                    Icon(
                      Icons.remove_circle_outline,
                      size: 20,
                      color: DesignTokens.error,
                    ),
                    SizedBox(width: DesignTokens.spacing2),
                    Text('멤버 제거', style: TextStyle(color: DesignTokens.error)),
                  ],
                ),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    _showRemoveConfirmation(member);
                  });
                },
              ),
            ],
            onSelected: (role) {
              _changeRole(member, role, isAdmin);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestCard(GroupMember member, int index) {
    final player = member.player;
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            border: Border.all(
              color: DesignTokens.warning.withValues(alpha: 0.3),
            ),
            boxShadow: DesignTokens.shadowSm,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Avatar(
                    imageUrl: player.avatar,
                    name: player.name,
                    size: AvatarSize.large,
                  ),
                  const SizedBox(width: DesignTokens.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontLg,
                            fontWeight: DesignTokens.fontBold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing1),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: DesignTokens.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '5분 전',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: DesignTokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing3),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectRequest(member, index),
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
                      child: const Text(
                        '거절',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _approveRequest(member, index),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignTokens.spacing3,
                        ),
                        backgroundColor: DesignTokens.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                      ),
                      child: const Text(
                        '승인',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          fontWeight: DesignTokens.fontSemibold,
                          color: DesignTokens.neutral0,
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
        .fadeIn(duration: 500.ms, delay: (index * 50).ms)
        .slideX(begin: 0.2, end: 0);
  }

  Future<void> _changeRole(
    Player member,
    MemberRole newRole,
    bool currentlyAdmin,
  ) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    if ((newRole == MemberRole.admin && currentlyAdmin) ||
        (newRole == MemberRole.member && !currentlyAdmin)) {
      return; // No change
    }

    final serviceMemberRole = newRole == MemberRole.admin
        ? MemberRole.admin
        : MemberRole.member;
    final success = await _memberService.changeMemberRole(
      groupId: widget.group.id,
      memberId: member.id,
      newRole: serviceMemberRole,
      changedBy: currentUser.id,
    );

    if (success && mounted) {
      final roleText = newRole == MemberRole.admin ? '관리자' : '멤버';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${member.name}님의 역할이 $roleText(으)로 변경되었습니다'),
          backgroundColor: DesignTokens.success,
        ),
      );
    }
  }

  Future<void> _showRemoveConfirmation(Player member) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('멤버 제거'),
        content: Text('${member.name}님을 그룹에서 제거하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '제거',
              style: TextStyle(color: DesignTokens.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _memberService.kickMember(
        groupId: widget.group.id,
        memberId: member.id,
        kickedBy: currentUser.id,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.name}님이 제거되었습니다'),
            backgroundColor: DesignTokens.success,
          ),
        );
      }
    }
  }

  Future<void> _approveRequest(GroupMember member, int index) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final success = await _memberService.approveMember(
      groupId: widget.group.id,
      memberId: member.id,
      approverId: currentUser.id,
    );

    if (success && mounted) {
      await _loadPendingMembers(); // Reload the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.player.name}님의 가입을 승인했습니다'),
            backgroundColor: DesignTokens.success,
          ),
        );
      }
    }
  }

  Future<void> _rejectRequest(GroupMember member, int index) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final success = await _memberService.rejectMember(
      groupId: widget.group.id,
      memberId: member.id,
      rejecterId: currentUser.id,
    );

    if (success && mounted) {
      await _loadPendingMembers(); // Reload the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.player.name}님의 가입을 거절했습니다'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }
}
