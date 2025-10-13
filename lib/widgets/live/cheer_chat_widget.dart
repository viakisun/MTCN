import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/player.dart';
import '../../services/cheer_service.dart';

/// 실시간 응원 채팅 위젯
///
/// 라이브 라운딩 중 다른 플레이어에게 응원 메시지를 보낼 수 있습니다.
class CheerChatWidget extends ConsumerStatefulWidget {
  final String roundingId;
  final Player currentUser;
  final List<Player> players;
  final int? currentHole;

  const CheerChatWidget({
    super.key,
    required this.roundingId,
    required this.currentUser,
    required this.players,
    this.currentHole,
  });

  @override
  ConsumerState<CheerChatWidget> createState() => _CheerChatWidgetState();
}

class _CheerChatWidgetState extends ConsumerState<CheerChatWidget> {
  final ScrollController _scrollController = ScrollController();
  final CheerService _cheerService = CheerService.instance;

  List<CheerMessage> _cheerMessages = [];
  Player? _selectedPlayer;

  @override
  void initState() {
    super.initState();
    _loadCheers();
    _listenToCheerStream();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCheers() async {
    final cheers = await _cheerService.getRoundingCheers(
      roundingId: widget.roundingId,
    );
    if (mounted) {
      setState(() {
        _cheerMessages = cheers;
      });
    }
  }

  void _listenToCheerStream() {
    _cheerService.cheerStream.listen((cheer) {
      if (cheer.roundingId == widget.roundingId) {
        setState(() {
          _cheerMessages.insert(0, cheer);
        });
        _scrollToTop();
      }
    });
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendCheer(CheerType type) async {
    if (_selectedPlayer == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('응원할 플레이어를 선택하세요')));
      return;
    }

    final cheer = await _cheerService.sendCheer(
      senderId: widget.currentUser.id,
      senderName: widget.currentUser.name,
      targetPlayerId: _selectedPlayer!.id,
      targetPlayerName: _selectedPlayer!.name,
      type: type,
      roundingId: widget.roundingId,
      holeNumber: widget.currentHole,
    );

    if (cheer != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_selectedPlayer!.name}님에게 ${cheer.emoji} ${cheer.defaultMessage}',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: DesignTokens.success,
        ),
      );
    }
  }

  void _showCheerPicker() {
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
              const Text(
                '응원 보내기',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),

              // Player selection
              const Text(
                '플레이어 선택',
                style: TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontSemibold,
                  color: DesignTokens.textSecondary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing2),
              Wrap(
                spacing: DesignTokens.spacing2,
                children: widget.players
                    .where((p) => p.id != widget.currentUser.id)
                    .map((player) {
                      final isSelected = _selectedPlayer?.id == player.id;
                      return ChoiceChip(
                        label: Text(player.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedPlayer = selected ? player : null;
                          });
                          Navigator.pop(context);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _showCheerTypePicker();
                          });
                        },
                      );
                    })
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheerTypePicker() {
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
              Text(
                '${_selectedPlayer?.name}님에게',
                style: const TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: DesignTokens.spacing2,
                crossAxisSpacing: DesignTokens.spacing2,
                childAspectRatio: 1.2,
                children: CheerType.values.map((type) {
                  final emoji = _getCheerEmoji(type);
                  final label = _getCheerLabel(type);
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _sendCheer(type);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: DesignTokens.neutral50,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                        border: Border.all(color: DesignTokens.neutral200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: DesignTokens.spacing1),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: DesignTokens.fontXs,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCheerEmoji(CheerType type) {
    switch (type) {
      case CheerType.applause:
        return '👏';
      case CheerType.fighting:
        return '💪';
      case CheerType.goodShot:
        return '⛳';
      case CheerType.amazing:
        return '🎉';
      case CheerType.heart:
        return '❤️';
      case CheerType.fire:
        return '🔥';
    }
  }

  String _getCheerLabel(CheerType type) {
    switch (type) {
      case CheerType.applause:
        return '박수!';
      case CheerType.fighting:
        return '파이팅!';
      case CheerType.goodShot:
        return '굿샷!';
      case CheerType.amazing:
        return '대단해요!';
      case CheerType.heart:
        return '좋아요!';
      case CheerType.fire:
        return '불타요!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: DesignTokens.neutral50,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: const BoxDecoration(
              color: DesignTokens.neutral0,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(DesignTokens.radiusXl),
              ),
              border: Border(
                bottom: BorderSide(color: DesignTokens.neutral200),
              ),
            ),
            child: Row(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 20)),
                const SizedBox(width: DesignTokens.spacing2),
                const Expanded(
                  child: Text(
                    '실시간 응원',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _loadCheers,
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Cheer messages list
          Expanded(
            child: _cheerMessages.isEmpty
                ? const Center(
                    child: Text(
                      '아직 응원이 없습니다\n첫 응원을 보내보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(DesignTokens.spacing4),
                    itemCount: _cheerMessages.length,
                    itemBuilder: (context, index) {
                      final cheer = _cheerMessages[index];
                      return _buildCheerMessage(cheer)
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: 0.2, end: 0);
                    },
                  ),
          ),

          // Send cheer button
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: const BoxDecoration(
              color: DesignTokens.neutral0,
              border: Border(top: BorderSide(color: DesignTokens.neutral200)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showCheerPicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignTokens.primary600,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacing3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusLg,
                      ),
                    ),
                  ),
                  icon: const Text('🎉', style: TextStyle(fontSize: 20)),
                  label: const Text(
                    '응원 보내기',
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontSemibold,
                      color: DesignTokens.neutral0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheerMessage(CheerMessage cheer) {
    final isMe = cheer.senderId == widget.currentUser.id;
    final timeStr =
        '${cheer.timestamp.hour}:${cheer.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      padding: const EdgeInsets.all(DesignTokens.spacing3),
      decoration: BoxDecoration(
        color: isMe ? DesignTokens.primary100 : DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: isMe ? DesignTokens.primary600 : DesignTokens.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(cheer.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: DesignTokens.spacing2),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: DesignTokens.fontSm,
                      color: DesignTokens.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: cheer.senderName,
                        style: const TextStyle(
                          fontWeight: DesignTokens.fontBold,
                        ),
                      ),
                      const TextSpan(text: '님이 '),
                      TextSpan(
                        text: cheer.targetPlayerName,
                        style: const TextStyle(
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.primary600,
                        ),
                      ),
                      const TextSpan(text: '님에게'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing1),
          Row(
            children: [
              Expanded(
                child: Text(
                  cheer.defaultMessage,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontBase,
                    fontWeight: DesignTokens.fontSemibold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
              ),
              if (cheer.holeNumber != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  ),
                  child: Text(
                    '${cheer.holeNumber}H',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontXs,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.success,
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacing2),
              ],
              Text(
                timeStr,
                style: const TextStyle(
                  fontSize: DesignTokens.fontXs,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
