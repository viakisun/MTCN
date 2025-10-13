import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _groupType = 'alumni'; // alumni, friends, club, tournament
  String _privacy = 'public'; // public, private
  bool _autoApproval = true;
  bool _allowMemberInvite = true;
  bool _enableNotifications = true;
  bool _enableChat = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save group to provider/database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('그룹 "${_nameController.text}"이(가) 생성되었습니다!'),
          backgroundColor: DesignTokens.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '그룹 만들기',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _createGroup,
            child: const Text(
              '완료',
              style: TextStyle(
                fontSize: DesignTokens.fontSm,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.primary600,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: DesignTokens.neutral200),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Image Upload
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement image picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('이미지 업로드 기능은 준비중입니다'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: DesignTokens.gradientEucalyptus,
                      shape: BoxShape.circle,
                      boxShadow: DesignTokens.shadowMd,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: DesignTokens.neutral0,
                        ),
                        SizedBox(height: DesignTokens.spacing1),
                        Text(
                          '그룹 이미지',
                          style: TextStyle(
                            fontSize: DesignTokens.fontXs,
                            color: DesignTokens.neutral0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),

              const SizedBox(height: DesignTokens.spacing6),

              // Basic Information Section
              const Text(
                '기본 정보',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 150.ms),
              const SizedBox(height: DesignTokens.spacing3),

              // Group Name
              TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '그룹 이름',
                      hintText: '예: 명지대 골프 동호회',
                      prefixIcon: const Icon(
                        Icons.group,
                        color: DesignTokens.primary600,
                      ),
                      filled: true,
                      fillColor: DesignTokens.neutral0,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        borderSide: const BorderSide(
                          color: DesignTokens.neutral200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        borderSide: const BorderSide(
                          color: DesignTokens.neutral200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        borderSide: const BorderSide(
                          color: DesignTokens.primary600,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '그룹 이름을 입력해주세요';
                      }
                      if (value.length < 2) {
                        return '그룹 이름은 2자 이상이어야 합니다';
                      }
                      return null;
                    },
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing4),

              // Group Description
              TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: '그룹 설명',
                      hintText: '그룹에 대해 간단히 소개해주세요',
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: DesignTokens.neutral0,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        borderSide: const BorderSide(
                          color: DesignTokens.neutral200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        borderSide: const BorderSide(
                          color: DesignTokens.neutral200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        borderSide: const BorderSide(
                          color: DesignTokens.primary600,
                          width: 2,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 250.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing6),

              // Group Type Section
              const Text(
                '그룹 유형',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
              const SizedBox(height: DesignTokens.spacing3),

              Wrap(
                spacing: DesignTokens.spacing2,
                runSpacing: DesignTokens.spacing2,
                children: [
                  _buildGroupTypeChip('동문회', 'alumni', Icons.school),
                  _buildGroupTypeChip('친목회', 'friends', Icons.groups),
                  _buildGroupTypeChip('골프 클럽', 'club', Icons.flag),
                  _buildGroupTypeChip(
                    '대회/토너먼트',
                    'tournament',
                    Icons.emoji_events,
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 350.ms),

              const SizedBox(height: DesignTokens.spacing6),

              // Privacy Settings Section
              const Text(
                '공개 설정',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
              const SizedBox(height: DesignTokens.spacing3),

              Container(
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
                      border: Border.all(color: DesignTokens.neutral200),
                    ),
                    child: Column(
                      children: [
                        _buildPrivacyOption(
                          '공개',
                          '누구나 그룹을 찾고 가입 신청할 수 있습니다',
                          'public',
                          Icons.public,
                        ),
                        const Divider(
                          height: 1,
                          color: DesignTokens.neutral200,
                        ),
                        _buildPrivacyOption(
                          '비공개',
                          '초대받은 사람만 그룹에 가입할 수 있습니다',
                          'private',
                          Icons.lock,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 450.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing6),

              // Advanced Settings Section
              const Text(
                '고급 설정',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
              const SizedBox(height: DesignTokens.spacing3),

              Container(
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusXl,
                      ),
                      border: Border.all(color: DesignTokens.neutral200),
                    ),
                    child: Column(
                      children: [
                        _buildSettingSwitch(
                          '자동 승인',
                          '가입 신청을 자동으로 승인합니다',
                          _autoApproval,
                          (value) => setState(() => _autoApproval = value),
                          Icons.check_circle,
                        ),
                        const Divider(
                          height: 1,
                          color: DesignTokens.neutral200,
                        ),
                        _buildSettingSwitch(
                          '멤버 초대 허용',
                          '모든 멤버가 새로운 사람을 초대할 수 있습니다',
                          _allowMemberInvite,
                          (value) => setState(() => _allowMemberInvite = value),
                          Icons.person_add,
                        ),
                        const Divider(
                          height: 1,
                          color: DesignTokens.neutral200,
                        ),
                        _buildSettingSwitch(
                          '채팅 활성화',
                          '그룹 채팅방을 사용할 수 있습니다',
                          _enableChat,
                          (value) => setState(() => _enableChat = value),
                          Icons.chat,
                        ),
                        const Divider(
                          height: 1,
                          color: DesignTokens.neutral200,
                        ),
                        _buildSettingSwitch(
                          '알림 활성화',
                          '그룹 활동에 대한 알림을 받습니다',
                          _enableNotifications,
                          (value) =>
                              setState(() => _enableNotifications = value),
                          Icons.notifications,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 550.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing6),

              // Create Button
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createGroup,
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
                        elevation: 0,
                      ),
                      child: const Text(
                        '그룹 만들기',
                        style: TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignTokens.spacing4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupTypeChip(String label, String value, IconData icon) {
    final isSelected = _groupType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _groupType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing3,
          vertical: DesignTokens.spacing2,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? DesignTokens.gradientEucalyptus : null,
          color: isSelected ? null : DesignTokens.neutral0,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: isSelected ? Colors.transparent : DesignTokens.neutral200,
          ),
          boxShadow: isSelected ? DesignTokens.shadowSm : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? DesignTokens.neutral0
                  : DesignTokens.textSecondary,
            ),
            const SizedBox(width: DesignTokens.spacing2),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontSm,
                fontWeight: isSelected
                    ? DesignTokens.fontBold
                    : DesignTokens.fontMedium,
                color: isSelected
                    ? DesignTokens.neutral0
                    : DesignTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(
    String title,
    String description,
    String value,
    IconData icon,
  ) {
    final isSelected = _privacy == value;

    return InkWell(
      onTap: () {
        setState(() {
          _privacy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? DesignTokens.primary600.withOpacity(0.1)
                    : DesignTokens.neutral50,
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? DesignTokens.primary600
                    : DesignTokens.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: DesignTokens.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontSemibold,
                      color: isSelected
                          ? DesignTokens.primary600
                          : DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: DesignTokens.fontXs,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _privacy,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _privacy = newValue;
                  });
                }
              },
              activeColor: DesignTokens.primary600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? DesignTokens.primary600 : DesignTokens.textTertiary,
            size: 24,
          ),
          const SizedBox(width: DesignTokens.spacing3),
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
                const SizedBox(height: 4),
                Text(
                  description,
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
            activeColor: DesignTokens.primary600,
          ),
        ],
      ),
    );
  }
}
