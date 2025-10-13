import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';
import '../../models/player.dart';
import '../../widgets/common/avatar.dart';

class QRCheckinPage extends ConsumerStatefulWidget {
  final Rounding rounding;

  const QRCheckinPage({super.key, required this.rounding});

  @override
  ConsumerState<QRCheckinPage> createState() => _QRCheckinPageState();
}

class _QRCheckinPageState extends ConsumerState<QRCheckinPage> {
  late Timer _refreshTimer;
  DateTime _lastRefresh = DateTime.now();

  // Mock checked-in players
  final Set<String> _checkedInPlayers = {};

  @override
  void initState() {
    super.initState();
    // Refresh QR code every 30 seconds for security
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {
          _lastRefresh = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  String get _qrData {
    // Generate QR data with timestamp for security
    return 'MTCN_CHECKIN:${widget.rounding.id}:${_lastRefresh.millisecondsSinceEpoch}';
  }

  int get _checkedInCount => _checkedInPlayers.length;
  int get _totalPlayers => widget.rounding.players.length;

  void _simulateCheckin(Player player) {
    setState(() {
      if (_checkedInPlayers.contains(player.id)) {
        _checkedInPlayers.remove(player.id);
      } else {
        _checkedInPlayers.add(player.id);
      }
    });
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
          'QR 체크인',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Check-in Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: BoxDecoration(
                gradient: _checkedInCount == _totalPlayers
                    ? DesignTokens.gradientEucalyptus
                    : DesignTokens.gradientSky,
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                boxShadow: DesignTokens.shadowMd,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 48,
                    color: DesignTokens.neutral0,
                  ),
                  const SizedBox(height: DesignTokens.spacing2),
                  Text(
                    '$_checkedInCount / $_totalPlayers명 체크인 완료',
                    style: const TextStyle(
                      fontSize: DesignTokens.font2xl,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.neutral0,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    widget.rounding.courseName,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      color: DesignTokens.neutral0.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    '${widget.rounding.date} ${widget.rounding.time}',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      color: DesignTokens.neutral0.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing6),

            // QR Code Card
            Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing5),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral0,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: DesignTokens.shadowLg,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'QR 코드를 스캔하세요',
                        style: TextStyle(
                          fontSize: DesignTokens.fontLg,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing2),
                      const Text(
                        '아래 QR 코드를 스캔하여 체크인하세요',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing4),

                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          color: DesignTokens.neutral0,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                          border: Border.all(
                            color: DesignTokens.neutral200,
                            width: 2,
                          ),
                        ),
                        child: QrImageView(
                          data: _qrData,
                          version: QrVersions.auto,
                          size: 250.0,
                          backgroundColor: DesignTokens.neutral0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: DesignTokens.primary600,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: DesignTokens.primary600,
                          ),
                        ),
                      ),

                      const SizedBox(height: DesignTokens.spacing4),

                      // QR Code Info
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing3),
                        decoration: BoxDecoration(
                          color: DesignTokens.primary600.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: DesignTokens.primary600,
                            ),
                            const SizedBox(width: DesignTokens.spacing2),
                            Text(
                              'QR 코드는 30초마다 자동 갱신됩니다',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontXs,
                                color: DesignTokens.primary600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 100.ms)
                .scale(delay: 200.ms),

            const SizedBox(height: DesignTokens.spacing6),

            // Manual Check-in Section
            Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.spacing4),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral0,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                    boxShadow: DesignTokens.shadowMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '수동 체크인',
                            style: TextStyle(
                              fontSize: DesignTokens.fontLg,
                              fontWeight: DesignTokens.fontBold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacing2,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: DesignTokens.primary600.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusFull,
                              ),
                            ),
                            child: Text(
                              '$_checkedInCount/$_totalPlayers',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                fontWeight: DesignTokens.fontBold,
                                color: DesignTokens.primary600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacing1),
                      const Text(
                        '참가자를 탭하여 체크인하세요',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing4),

                      // Player List
                      ...widget.rounding.players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final player = entry.value;
                        final isCheckedIn = _checkedInPlayers.contains(
                          player.id,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: DesignTokens.spacing3,
                          ),
                          child: _buildPlayerCheckInCard(player, isCheckedIn)
                              .animate()
                              .fadeIn(
                                duration: 500.ms,
                                delay: (300 + index * 50).ms,
                              )
                              .slideX(begin: 0.2, end: 0),
                        );
                      }),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: DesignTokens.spacing6),

            // Complete Check-in Button
            if (_checkedInCount == _totalPlayers)
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showCompleteDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignTokens.spacing4,
                        ),
                        backgroundColor: DesignTokens.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.check_circle,
                        color: DesignTokens.neutral0,
                      ),
                      label: const Text(
                        '체크인 완료',
                        style: TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0)
                  .shake(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCheckInCard(Player player, bool isCheckedIn) {
    return GestureDetector(
      onTap: () => _simulateCheckin(player),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacing3),
        decoration: BoxDecoration(
          color: isCheckedIn
              ? DesignTokens.success.withOpacity(0.05)
              : DesignTokens.neutral50,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: isCheckedIn ? DesignTokens.success : DesignTokens.neutral200,
            width: isCheckedIn ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Avatar(
              imageUrl: player.avatar,
              name: player.name,
              size: AvatarSize.medium,
            ),
            const SizedBox(width: DesignTokens.spacing3),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontSemibold,
                      color: isCheckedIn
                          ? DesignTokens.success
                          : DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isCheckedIn) ...[
                        const Icon(
                          Icons.check_circle,
                          size: 14,
                          color: DesignTokens.success,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '체크인 완료',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            color: DesignTokens.success,
                          ),
                        ),
                      ] else ...[
                        const Icon(
                          Icons.radio_button_unchecked,
                          size: 14,
                          color: DesignTokens.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '대기중',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Check Icon
            if (isCheckedIn)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: DesignTokens.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: DesignTokens.neutral0,
                  size: 20,
                ),
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: DesignTokens.neutral300, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: DesignTokens.success, size: 28),
            SizedBox(width: DesignTokens.spacing2),
            Text('체크인 완료!'),
          ],
        ),
        content: const Text('모든 참가자가 체크인을 완료했습니다.\n라운딩을 시작하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('라운딩을 시작합니다!'),
                  backgroundColor: DesignTokens.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.success,
            ),
            child: const Text(
              '라운딩 시작',
              style: TextStyle(color: DesignTokens.neutral0),
            ),
          ),
        ],
      ),
    );
  }
}
