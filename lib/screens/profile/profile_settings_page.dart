import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../widgets/common/avatar.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // User profile data (mock)
  String _name = '김철수';
  String _email = 'kim@example.com';
  String _phone = '010-1234-5678';
  String _handicap = '18';
  String _favoriteCourse = '제주 핑크스 골프클럽';
  String _bio = '주말마다 골프를 즐기는 아마추어 골퍼입니다.';

  // Settings
  bool _notifications = true;
  bool _emailNotifications = true;
  bool _roundReminders = true;
  bool _groupInvites = true;
  bool _scoreUpdates = false;
  bool _darkMode = false;
  bool _publicProfile = true;

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
          '프로필 설정',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: DesignTokens.neutral200),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const Avatar(
                          imageUrl: 'https://i.pravatar.cc/300?img=12',
                          name: '김철수',
                          size: AvatarSize.xxLarge,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showAvatarOptions,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: DesignTokens.gradientSky,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: DesignTokens.neutral0,
                                  width: 3,
                                ),
                                boxShadow: DesignTokens.shadowMd,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: DesignTokens.neutral0,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing3),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontXl,
                        fontWeight: DesignTokens.fontBold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),

              const SizedBox(height: DesignTokens.spacing6),

              // Basic Information Section
              _buildSection('기본 정보', [
                    _buildTextField(
                      label: '이름',
                      value: _name,
                      icon: Icons.person,
                      onChanged: (value) => setState(() => _name = value),
                    ),
                    _buildTextField(
                      label: '이메일',
                      value: _email,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(() => _email = value),
                    ),
                    _buildTextField(
                      label: '전화번호',
                      value: _phone,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => setState(() => _phone = value),
                    ),
                  ])
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing4),

              // Golf Information Section
              _buildSection('골프 정보', [
                    _buildTextField(
                      label: '핸디캡',
                      value: _handicap,
                      icon: Icons.golf_course,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() => _handicap = value),
                    ),
                    _buildTextField(
                      label: '선호 골프장',
                      value: _favoriteCourse,
                      icon: Icons.location_on,
                      onChanged: (value) =>
                          setState(() => _favoriteCourse = value),
                    ),
                    _buildTextField(
                      label: '자기소개',
                      value: _bio,
                      icon: Icons.info,
                      maxLines: 3,
                      onChanged: (value) => setState(() => _bio = value),
                    ),
                  ])
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing4),

              // Notification Settings Section
              _buildSection('알림 설정', [
                    _buildSwitch(
                      '알림 받기',
                      '푸시 알림을 받습니다',
                      _notifications,
                      (value) => setState(() => _notifications = value),
                    ),
                    if (_notifications) ...[
                      _buildSwitch(
                        '이메일 알림',
                        '중요한 소식을 이메일로 받습니다',
                        _emailNotifications,
                        (value) => setState(() => _emailNotifications = value),
                      ),
                      _buildSwitch(
                        '라운딩 알림',
                        '라운딩 전 알림을 받습니다',
                        _roundReminders,
                        (value) => setState(() => _roundReminders = value),
                      ),
                      _buildSwitch(
                        '그룹 초대',
                        '그룹 초대 알림을 받습니다',
                        _groupInvites,
                        (value) => setState(() => _groupInvites = value),
                      ),
                      _buildSwitch(
                        '스코어 업데이트',
                        '스코어 기록 알림을 받습니다',
                        _scoreUpdates,
                        (value) => setState(() => _scoreUpdates = value),
                      ),
                    ],
                  ])
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing4),

              // App Settings Section
              _buildSection('앱 설정', [
                    _buildSwitch(
                      '다크 모드',
                      '어두운 테마를 사용합니다',
                      _darkMode,
                      (value) => setState(() => _darkMode = value),
                    ),
                    _buildSwitch(
                      '프로필 공개',
                      '다른 사용자에게 프로필을 공개합니다',
                      _publicProfile,
                      (value) => setState(() => _publicProfile = value),
                    ),
                  ])
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 500.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing4),

              // Account Actions Section
              _buildSection('계정', [
                    _buildActionButton(
                      '비밀번호 변경',
                      Icons.lock,
                      DesignTokens.primary600,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('비밀번호 변경 기능은 준비중입니다')),
                        );
                      },
                    ),
                    _buildActionButton(
                      '계정 연동',
                      Icons.link,
                      DesignTokens.info,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('계정 연동 기능은 준비중입니다')),
                        );
                      },
                    ),
                    _buildActionButton(
                      '로그아웃',
                      Icons.logout,
                      DesignTokens.warning,
                      _showLogoutConfirmation,
                    ),
                    _buildActionButton(
                      '계정 탈퇴',
                      Icons.delete_forever,
                      DesignTokens.error,
                      _showDeleteAccountConfirmation,
                    ),
                  ])
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing6),

              // Save Button
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignTokens.spacing4,
                        ),
                        backgroundColor: DesignTokens.primary600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                      ),
                      child: const Text(
                        '저장',
                        style: TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 700.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing2),

              // App Version
              Center(
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: DesignTokens.fontXs,
                    color: DesignTokens.textTertiary,
                  ),
                ),
              ),

              const SizedBox(height: DesignTokens.spacing4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: DesignTokens.fontLg,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing3),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      child: TextFormField(
        initialValue: value,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: DesignTokens.primary600, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            borderSide: const BorderSide(color: DesignTokens.neutral300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            borderSide: const BorderSide(color: DesignTokens.neutral300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            borderSide: const BorderSide(
              color: DesignTokens.primary600,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: DesignTokens.neutral50,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontBase,
                    fontWeight: DesignTokens.fontSemibold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: DesignTokens.primary600,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacing3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontBase,
                    fontWeight: DesignTokens.fontSemibold,
                    color: color,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarOptions() {
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
              _buildAvatarOption(Icons.camera_alt, '사진 촬영', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('카메라 기능은 준비중입니다')));
              }),
              _buildAvatarOption(Icons.photo_library, '갤러리에서 선택', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('갤러리 기능은 준비중입니다')));
              }),
              _buildAvatarOption(Icons.delete, '프로필 사진 삭제', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('프로필 사진이 삭제되었습니다')),
                );
              }, color: DesignTokens.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarOption(
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

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필이 저장되었습니다'),
          backgroundColor: DesignTokens.success,
        ),
      );
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('로그아웃 되었습니다'),
                  backgroundColor: DesignTokens.success,
                ),
              );
            },
            child: const Text(
              '로그아웃',
              style: TextStyle(color: DesignTokens.warning),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: DesignTokens.error, size: 28),
            SizedBox(width: DesignTokens.spacing2),
            Text('계정 탈퇴'),
          ],
        ),
        content: const Text('계정을 탈퇴하면 모든 데이터가 삭제되며 복구할 수 없습니다.\n정말 탈퇴하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('계정이 탈퇴되었습니다'),
                  backgroundColor: DesignTokens.error,
                ),
              );
            },
            child: const Text(
              '탈퇴',
              style: TextStyle(color: DesignTokens.error),
            ),
          ),
        ],
      ),
    );
  }
}
