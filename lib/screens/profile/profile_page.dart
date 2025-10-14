import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/utils/app_version.dart';
import '../../widgets/common/avatar.dart';
import 'profile_settings_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.person, color: DesignTokens.primary600, size: 24),
            SizedBox(width: DesignTokens.spacing2),
            Text(
              '프로필',
              style: TextStyle(
                fontSize: DesignTokens.fontXl,
                fontWeight: DesignTokens.fontSemibold,
                color: DesignTokens.textPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: DesignTokens.neutral200),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: DesignTokens.gradientTerracotta,
              ),
              child: Column(
                children: [
                  const SizedBox(height: DesignTokens.spacing6),
                  const Avatar(
                        imageUrl: 'https://i.pravatar.cc/150?img=1',
                        name: '김민수',
                        size: AvatarSize.large,
                        showBorder: true,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                      ),
                  const SizedBox(height: DesignTokens.spacing3),
                  const Text(
                    '김민수',
                    style: TextStyle(
                      fontSize: DesignTokens.font2xl,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.neutral0,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                  const SizedBox(height: DesignTokens.spacing1),
                  const Text(
                    'member@mtcn.golf',
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      color: DesignTokens.neutral0,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  const SizedBox(height: DesignTokens.spacing6),
                ],
              ),
            ),

            // Statistics Cards
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child:
                            _buildStatCard(
                                  icon: Icons.golf_course,
                                  label: '평균 타수',
                                  value: '82',
                                  gradient: DesignTokens.gradientTerracotta,
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 300.ms)
                                .slideY(begin: 0.2, end: 0),
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      Expanded(
                        child:
                            _buildStatCard(
                                  icon: Icons.star,
                                  label: '베스트 타수',
                                  value: '75',
                                  gradient: DesignTokens.gradientGold,
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 400.ms)
                                .slideY(begin: 0.2, end: 0),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacing3),
                  Row(
                    children: [
                      Expanded(
                        child:
                            _buildStatCard(
                                  icon: Icons.trending_down,
                                  label: '핸디캡',
                                  value: '12',
                                  gradient: DesignTokens.gradientEucalyptus,
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 500.ms)
                                .slideY(begin: 0.2, end: 0),
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      Expanded(
                        child:
                            _buildStatCard(
                                  icon: Icons.calendar_today,
                                  label: '참가 라운딩',
                                  value: '24',
                                  gradient: DesignTokens.gradientSky,
                                )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 600.ms)
                                .slideY(begin: 0.2, end: 0),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing4,
              ),
              child:
                  Container(
                        decoration: BoxDecoration(
                          color: DesignTokens.neutral0,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusXl,
                          ),
                          boxShadow: DesignTokens.shadowMd,
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              context,
                              icon: Icons.settings,
                              title: '설정',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSettingsPage(),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 1,
                              color: DesignTokens.neutral200,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.person_outline,
                              title: '개인정보 수정',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSettingsPage(),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 1,
                              color: DesignTokens.neutral200,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.notifications_none,
                              title: '알림 설정',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSettingsPage(),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 1,
                              color: DesignTokens.neutral200,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.help_outline,
                              title: '도움말',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('도움말 기능은 준비중입니다'),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 1,
                              color: DesignTokens.neutral200,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.info_outline,
                              title: '앱 정보',
                              onTap: () => _showAppInfoDialog(context),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 700.ms)
                      .slideY(begin: 0.2, end: 0),
            ),

            const SizedBox(height: DesignTokens.spacing4),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing4,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignTokens.error,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacing4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusLg,
                      ),
                    ),
                  ),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontSemibold,
                      color: DesignTokens.neutral0,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 800.ms),
            ),

            const SizedBox(height: DesignTokens.spacing6),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowMd,
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
            child: Icon(icon, color: DesignTokens.neutral0, size: 24),
          ),
          const SizedBox(height: DesignTokens.spacing3),
          Text(
            value,
            style: const TextStyle(
              fontSize: DesignTokens.font2xl,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing1),
          Text(
            label,
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Row(
          children: [
            Icon(icon, color: DesignTokens.textSecondary, size: 24),
            const SizedBox(width: DesignTokens.spacing3),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: DesignTokens.fontBase,
                  color: DesignTokens.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: DesignTokens.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// 앱 정보 다이얼로그 표시
  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: DesignTokens.primary600,
                size: 24,
              ),
              const SizedBox(width: DesignTokens.spacing2),
              const Text(
                '앱 정보',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontSemibold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '몇타치니 (MTCN)',
                style: TextStyle(
                  fontSize: DesignTokens.fontXl,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              const Text(
                '골프 라운딩을 더 즐겁게 만드는\n스마트 골프 앱입니다.',
                style: TextStyle(
                  fontSize: DesignTokens.fontBase,
                  color: DesignTokens.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacing3),
                decoration: BoxDecoration(
                  color: DesignTokens.neutral50,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  border: Border.all(color: DesignTokens.neutral200, width: 1),
                ),
                child: FutureBuilder<String>(
                  future: AppVersion.getVersionString(),
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.code,
                          color: DesignTokens.textTertiary,
                          size: 16,
                        ),
                        const SizedBox(width: DesignTokens.spacing2),
                        Text(
                          snapshot.data ?? 'v0.1.0+1',
                          style: const TextStyle(
                            fontSize: DesignTokens.fontSm,
                            color: DesignTokens.textSecondary,
                            fontWeight: DesignTokens.fontMedium,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '확인',
                style: TextStyle(
                  color: DesignTokens.primary600,
                  fontWeight: DesignTokens.fontSemibold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
