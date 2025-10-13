import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/group.dart';
import '../../models/player.dart';
import '../../widgets/common/avatar.dart';
import '../../services/group_member_service.dart';
import '../../services/chat_service.dart';
import '../../data/mock/mock_players.dart';
import '../../providers/auth_provider.dart';
import 'member_list_page.dart';
import 'member_management_page.dart';
import 'live_score_page.dart';
import 'group_chat_page.dart';

class GroupDetailPage extends ConsumerWidget {
  final Group group;

  const GroupDetailPage({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            Container(
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
                      gradient: DesignTokens.gradientEucalyptus,
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
                    group.name,
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
                        '${group.members.length}명',
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
                        '${group.roundCount}회',
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
                            // 그룹 채팅 초기화
                            ChatService.instance.initializeGroupChat(
                              group.id,
                              group.name,
                              [
                                MockPlayers.currentUser,
                                MockPlayers.findById('2'), // 이영희
                                MockPlayers.findById('3'), // 박철수
                                MockPlayers.findById('4'), // 정수진
                                MockPlayers.findById('5'), // 최동현
                              ],
                            );

                            // 그룹 채팅 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GroupChatPage(group: group),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacing3,
                            ),
                            backgroundColor: DesignTokens.primary600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.chat,
                            color: DesignTokens.neutral0,
                            size: 18,
                          ),
                          label: const Text(
                            '채팅',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSm,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.neutral0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showInviteDialog(context, ref),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacing3,
                            ),
                            side: const BorderSide(
                              color: DesignTokens.neutral300,
                            ),
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
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing4),

            // Live Score Button (if active rounding exists)
            Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    gradient: DesignTokens.gradientEucalyptus,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: DesignTokens.shadowMd,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LiveScorePage(
                            roundingId: '1',
                            roundingName: '2월 정기 라운딩',
                            courseName: '레이크사이드 CC',
                            date: '2024.02.15',
                          ),
                        ),
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
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
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
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '진행 중인 라운딩',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSm,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '2월 정기 라운딩 • 실시간 스코어 확인',
                                style: TextStyle(
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
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing4),

            // Group Description (if exists)
            if (group.description.isNotEmpty)
              Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing4),
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
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
                          group.description,
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
                  .slideY(begin: 0.2, end: 0),

            if (group.description.isNotEmpty)
              const SizedBox(height: DesignTokens.spacing4),

            // Members Section
            Container(
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
                            '멤버 (${group.members.length})',
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
                                      MemberListPage(group: group),
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
                          ...group.members.take(5).map((member) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: DesignTokens.spacing2,
                              ),
                              child: Avatar(
                                imageUrl: member.avatar,
                                name: member.name,
                                size: AvatarSize.medium,
                              ),
                            );
                          }),
                          if (group.members.length > 5)
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: DesignTokens.neutral100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '+${group.members.length - 5}',
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
                .fadeIn(duration: 500.ms, delay: 150.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing4),

            // Recent Activity Section
            Container(
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
                        '최근 활동',
                        style: TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing3),
                      _buildActivityItem(
                        Icons.golf_course,
                        '그룹 라운딩',
                        '${group.roundCount}회 진행',
                        DesignTokens.success,
                      ),
                      const SizedBox(height: DesignTokens.spacing2),
                      _buildActivityItem(
                        Icons.people,
                        '멤버',
                        '${group.members.length}명 활동중',
                        DesignTokens.info,
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: DesignTokens.spacing3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontSemibold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: DesignTokens.fontXs,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showGroupOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        decoration: const BoxDecoration(
          color: DesignTokens.neutral0,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(DesignTokens.radiusXl),
            topRight: Radius.circular(DesignTokens.radiusXl),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DesignTokens.neutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),
              _buildOption(Icons.manage_accounts, '멤버 관리', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberManagementPage(group: group),
                  ),
                );
              }),
              _buildOption(Icons.edit, '그룹 정보 수정', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('그룹 수정 기능은 준비중입니다')),
                );
              }),
              _buildOption(Icons.notifications, '알림 설정', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 설정 기능은 준비중입니다')),
                );
              }),
              _buildOption(Icons.exit_to_app, '그룹 나가기', () {
                Navigator.pop(context);
                _showLeaveConfirmation(context);
              }, color: DesignTokens.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spacing3,
          horizontal: DesignTokens.spacing2,
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? DesignTokens.textPrimary, size: 24),
            const SizedBox(width: DesignTokens.spacing3),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontBase,
                color: color ?? DesignTokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인이 필요합니다')));
      return;
    }

    final TextEditingController nameController = TextEditingController();
    final memberService = GroupMemberService.instance;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('멤버 초대'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '초대할 플레이어 이름',
                hintText: '이름을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacing3),
            const Text(
              '입력한 이름으로 플레이어를 검색하여 초대합니다.',
              style: TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('이름을 입력하세요')));
                return;
              }

              Navigator.pop(context);

              // Create mock invited player
              final invitee = Player(
                id: 'player_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                firstName: name.substring(0, 1),
                lastName: name.substring(1),
                avatar: '',
                handicap: 0,
                averageScore: 90,
                bestScore: 85,
              );

              final invitation = await memberService.inviteMember(
                groupId: group.id,
                groupName: group.name,
                inviter: currentUser,
                invitee: invitee,
                message: '${group.name} 그룹에 초대합니다.',
              );

              if (invitation != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name님에게 초대를 보냈습니다'),
                    backgroundColor: DesignTokens.success,
                  ),
                );
              }
            },
            child: const Text('초대'),
          ),
        ],
      ),
    );
  }

  void _showLeaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 나가기'),
        content: Text('${group.name} 그룹에서 나가시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to groups page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('그룹에서 나갔습니다'),
                  backgroundColor: DesignTokens.success,
                ),
              );
            },
            child: const Text(
              '나가기',
              style: TextStyle(color: DesignTokens.error),
            ),
          ),
        ],
      ),
    );
  }
}
