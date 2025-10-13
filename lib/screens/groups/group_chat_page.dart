import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/group.dart';
import '../../models/chat_message.dart';
import '../../widgets/common/avatar.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  final Group group;

  const GroupChatPage({super.key, required this.group});

  @override
  ConsumerState<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends ConsumerState<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isMenuOpen = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final chatNotifier = ref.read(chatProvider(widget.group.id).notifier);
    final success = await chatNotifier.sendMessage(
      sender: currentUser,
      content: content,
    );

    if (success) {
      _messageController.clear();
    }
  }

  Future<void> _pickAndSendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final chatNotifier = ref.read(chatProvider(widget.group.id).notifier);
    await chatNotifier.sendImageMessage(
      sender: currentUser,
      imageFile: File(pickedFile.path),
    );
  }

  Future<void> _pickAndSendFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null || result.files.single.path == null) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final chatNotifier = ref.read(chatProvider(widget.group.id).notifier);
    await chatNotifier.sendFileMessage(
      sender: currentUser,
      file: File(result.files.single.path!),
    );
  }

  void _showAttachmentOptions() {
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
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.image,
                  color: DesignTokens.primary600,
                ),
                title: const Text('이미지'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndSendImage();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.insert_drive_file,
                  color: DesignTokens.primary600,
                ),
                title: const Text('파일'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndSendFile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReactionPicker(ChatMessage message) {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

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
            const Text(
              '반응 선택',
              style: TextStyle(
                fontSize: DesignTokens.fontLg,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['👍', '❤️', '😂', '😮', '😢', '🎉'].map((emoji) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final chatNotifier = ref.read(
                      chatProvider(widget.group.id).notifier,
                    );
                    await chatNotifier.toggleReaction(
                      messageId: message.id,
                      userId: currentUser.id,
                      emoji: emoji,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing3),
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral50,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusLg,
                      ),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom + DesignTokens.spacing2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.group.id));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: DesignTokens.gradientGold,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('⛳', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: DesignTokens.spacing2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.name,
                    style: const TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontSemibold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  Text(
                    '${widget.group.members.length}명',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontXs,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: DesignTokens.textPrimary),
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Pinned Event (if exists)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacing3),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                  ),
                  border: Border(
                    bottom: BorderSide(color: DesignTokens.neutral200),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.push_pin,
                      size: 16,
                      color: DesignTokens.info,
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '다가오는 라운딩',
                            style: TextStyle(
                              fontSize: DesignTokens.fontXs,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.info,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacing1 / 2),
                          Text(
                            '레이크사이드 골프클럽 · 10월 15일',
                            style: TextStyle(
                              fontSize: DesignTokens.fontXs,
                              color: DesignTokens.info.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing2,
                          vertical: DesignTokens.spacing1,
                        ),
                        backgroundColor: DesignTokens.info,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                      ),
                      child: const Text(
                        '참가',
                        style: TextStyle(
                          fontSize: DesignTokens.fontXs,
                          fontWeight: DesignTokens.fontSemibold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms),

              // Reply Preview
              if (chatState.replyingTo != null)
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing3),
                  decoration: const BoxDecoration(
                    color: DesignTokens.neutral100,
                    border: Border(
                      top: BorderSide(color: DesignTokens.neutral200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.reply,
                        size: 20,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '답장: ${chatState.replyingTo!.sender.name}',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontXs,
                                fontWeight: DesignTokens.fontSemibold,
                                color: DesignTokens.primary600,
                              ),
                            ),
                            Text(
                              chatState.replyingTo!.content,
                              style: const TextStyle(
                                fontSize: DesignTokens.fontXs,
                                color: DesignTokens.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          ref
                              .read(chatProvider(widget.group.id).notifier)
                              .cancelReply();
                        },
                      ),
                    ],
                  ),
                ),

              // Chat Messages
              Expanded(
                child: chatState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        itemCount: chatState.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatState.messages[index];
                          final isMe = currentUser?.id == message.sender.id;

                          return _buildChatMessage(
                            message: message,
                            isMe: isMe,
                            currentUserId: currentUser?.id ?? '',
                          ).animate().fadeIn(
                            duration: 300.ms,
                            delay: (index * 50).ms,
                          );
                        },
                      ),
              ),

              // Message Input
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacing3),
                decoration: const BoxDecoration(
                  color: DesignTokens.neutral0,
                  border: Border(
                    top: BorderSide(color: DesignTokens.neutral200),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: DesignTokens.textSecondary,
                        ),
                        onPressed: _showAttachmentOptions,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: chatState.replyingTo != null
                                ? '답장을 입력하세요...'
                                : '메시지를 입력하세요...',
                            hintStyle: const TextStyle(
                              fontSize: DesignTokens.fontSm,
                              color: DesignTokens.textTertiary,
                            ),
                            filled: true,
                            fillColor: DesignTokens.neutral50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusFull,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacing3,
                              vertical: DesignTokens.spacing2,
                            ),
                          ),
                          maxLines: null,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: _messageController.text.isEmpty
                              ? DesignTokens.textTertiary
                              : DesignTokens.primary600,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Side Menu Panel
          if (_isMenuOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMenuOpen = false;
                });
              },
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          if (_isMenuOpen)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 280,
                color: DesignTokens.neutral0,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '메뉴',
                              style: TextStyle(
                                fontSize: DesignTokens.fontLg,
                                fontWeight: DesignTokens.fontBold,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _isMenuOpen = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(Icons.groups, '멤버 목록', () {}),
                      _buildMenuItem(Icons.emoji_events, '라운딩 신청', () {}),
                      _buildMenuItem(Icons.assessment, '라운딩 리포트', () {}),
                      _buildMenuItem(Icons.leaderboard, '실시간 스코어', () {}),
                      const Divider(height: 1),
                      _buildMenuItem(Icons.settings, '설정', () {}),
                      _buildMenuItem(Icons.notifications, '알림', () {}),
                      _buildMenuItem(Icons.help_outline, '도움말', () {}),
                    ],
                  ),
                ),
              ).animate().slideX(begin: 1, end: 0, duration: 300.ms),
            ),
        ],
      ),
    );
  }

  Widget _buildChatMessage({
    required ChatMessage message,
    required bool isMe,
    required String currentUserId,
  }) {
    final timestamp =
        '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isMe) ...[
                Avatar(
                  imageUrl: message.sender.avatar,
                  name: message.sender.name,
                  size: AvatarSize.small,
                ),
                const SizedBox(width: DesignTokens.spacing2),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.sender.name,
                            style: const TextStyle(
                              fontSize: DesignTokens.fontXs,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacing2),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              fontSize: 10,
                              color: DesignTokens.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: DesignTokens.spacing1 / 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing3,
                        vertical: DesignTokens.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? DesignTokens.primary600
                            : DesignTokens.neutral0,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        boxShadow: isMe ? null : DesignTokens.shadowSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reply preview
                          if (message.replyToMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(
                                DesignTokens.spacing2,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: DesignTokens.spacing2,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : DesignTokens.neutral50,
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.radiusMd,
                                ),
                                border: Border(
                                  left: BorderSide(
                                    color: isMe
                                        ? DesignTokens.neutral0
                                        : DesignTokens.primary600,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.replyToMessage!.sender.name,
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontXs,
                                      fontWeight: DesignTokens.fontSemibold,
                                      color: isMe
                                          ? DesignTokens.neutral0
                                          : DesignTokens.primary600,
                                    ),
                                  ),
                                  Text(
                                    message.replyToMessage!.content,
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontXs,
                                      color: isMe
                                          ? DesignTokens.neutral0.withValues(
                                              alpha: 0.8,
                                            )
                                          : DesignTokens.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Attachments (images/files)
                          if (message.attachments.isNotEmpty) ...[
                            ...message.attachments.map((attachment) {
                              if (attachment.fileType == 'image') {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: DesignTokens.spacing2,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      DesignTokens.radiusMd,
                                    ),
                                    child: Image.network(
                                      attachment.url,
                                      width: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 200,
                                                height: 150,
                                                color: DesignTokens.neutral100,
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: DesignTokens.spacing2,
                                  ),
                                  padding: const EdgeInsets.all(
                                    DesignTokens.spacing2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : DesignTokens.neutral50,
                                    borderRadius: BorderRadius.circular(
                                      DesignTokens.radiusMd,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.insert_drive_file,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: DesignTokens.spacing2,
                                      ),
                                      Text(
                                        attachment.fileName,
                                        style: TextStyle(
                                          fontSize: DesignTokens.fontXs,
                                          color: isMe
                                              ? DesignTokens.neutral0
                                              : DesignTokens.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ],

                          // Message content
                          if (message.content.isNotEmpty)
                            Text(
                              message.content,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: isMe
                                    ? DesignTokens.neutral0
                                    : DesignTokens.textPrimary,
                                height: 1.4,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Reactions and Reply buttons
          const SizedBox(height: DesignTokens.spacing1),
          Padding(
            padding: EdgeInsets.only(left: isMe ? 0 : 52),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show existing reactions
                if (message.reactions.isNotEmpty)
                  ...message.reactions.map((reaction) {
                    final userReacted = reaction.userIds.contains(
                      currentUserId,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: DesignTokens.spacing1,
                      ),
                      child: InkWell(
                        onTap: () async {
                          final chatNotifier = ref.read(
                            chatProvider(widget.group.id).notifier,
                          );
                          await chatNotifier.toggleReaction(
                            messageId: message.id,
                            userId: currentUserId,
                            emoji: reaction.emoji,
                          );
                        },
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMd,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: userReacted
                                ? DesignTokens.primary100
                                : DesignTokens.neutral50,
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusMd,
                            ),
                            border: Border.all(
                              color: userReacted
                                  ? DesignTokens.primary600
                                  : DesignTokens.neutral200,
                            ),
                          ),
                          child: Text(
                            '${reaction.emoji} ${reaction.userIds.length}',
                            style: TextStyle(
                              fontSize: DesignTokens.fontXs,
                              color: userReacted
                                  ? DesignTokens.primary600
                                  : DesignTokens.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                // Add reaction button
                InkWell(
                  onTap: () => _showReactionPicker(message),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: const Text(
                      '+ 반응',
                      style: TextStyle(
                        fontSize: DesignTokens.fontXs,
                        color: DesignTokens.textTertiary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: DesignTokens.spacing2),

                // Reply button
                InkWell(
                  onTap: () {
                    ref
                        .read(chatProvider(widget.group.id).notifier)
                        .setReplyingTo(message);
                  },
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: const Text(
                      '답장',
                      style: TextStyle(
                        fontSize: DesignTokens.fontXs,
                        color: DesignTokens.textTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: DesignTokens.textSecondary, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: DesignTokens.fontSm,
          color: DesignTokens.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}
