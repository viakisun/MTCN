import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';
import '../../widgets/common/avatar.dart';
import 'stadium_page.dart';
import 'qr_checkin_page.dart';
import '../groups/round_report_page.dart';
import 'real_time_game_page.dart';

class RoundingDetailPage extends ConsumerWidget {
  final Rounding rounding;

  const RoundingDetailPage({super.key, required this.rounding});

  int _calculateDDay(String dateString) {
    try {
      final targetDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final target = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final difference = target.difference(today);
      return difference.inDays;
    } catch (e) {
      return 0;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('M월 d일 (E)', 'ko_KR');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _getStatusColor() {
    switch (rounding.status) {
      case RoundingStatus.upcoming:
        return DesignTokens.info;
      case RoundingStatus.inProgress:
        return DesignTokens.warning;
      case RoundingStatus.completed:
        return DesignTokens.success;
    }
  }

  Color _getStatusLightColor() {
    switch (rounding.status) {
      case RoundingStatus.upcoming:
        return DesignTokens.infoLight;
      case RoundingStatus.inProgress:
        return DesignTokens.warningLight;
      case RoundingStatus.completed:
        return DesignTokens.successLight;
    }
  }

  String _getStatusText() {
    final dDay = _calculateDDay(rounding.date);

    if (rounding.status == RoundingStatus.upcoming) {
      if (dDay == 0) return '오늘';
      if (dDay == 1) return '내일';
      return 'D-$dDay';
    } else if (rounding.status == RoundingStatus.inProgress) {
      return '진행중';
    } else {
      return '완료';
    }
  }

  String _getStatusDescription() {
    switch (rounding.status) {
      case RoundingStatus.upcoming:
        return '예정된 라운딩';
      case RoundingStatus.inProgress:
        return '진행중인 라운딩';
      case RoundingStatus.completed:
        return '완료된 라운딩';
    }
  }

  bool _canEnterCourse() {
    final dDay = _calculateDDay(rounding.date);
    return dDay == 0 && rounding.status == RoundingStatus.upcoming;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dDay = _calculateDDay(rounding.date);

    return Scaffold(
      backgroundColor: DesignTokens.neutral0,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '라운딩 상세',
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
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge and Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing2,
                        vertical: DesignTokens.spacing1,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusLightColor(),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: TextStyle(
                          fontSize: DesignTokens.fontXs,
                          fontWeight: DesignTokens.fontBold,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    Text(
                      _getStatusDescription(),
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSm,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: DesignTokens.spacing3),

                // Course Name
                Text(
                      rounding.courseName,
                      style: const TextStyle(
                        fontSize: DesignTokens.font2xl,
                        fontWeight: DesignTokens.fontBold,
                        color: DesignTokens.textPrimary,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 100.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: DesignTokens.spacing2),

                // Date and Time
                Text(
                  '${_formatDate(rounding.date)} ${rounding.time} 티오프',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontBase,
                    color: DesignTokens.textSecondary,
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 150.ms),

                const SizedBox(height: DesignTokens.spacing6),

                // Basic Information Card
                Container(
                      padding: const EdgeInsets.all(DesignTokens.spacing4),
                      decoration: BoxDecoration(
                        color: DesignTokens.neutral0,
                        border: Border.all(color: DesignTokens.neutral200),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusXl,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '기본 정보',
                            style: TextStyle(
                              fontSize: DesignTokens.fontBase,
                              fontWeight: DesignTokens.fontBold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacing4),
                          _buildInfoRow('코스', '${rounding.holes}홀'),
                          const Divider(color: DesignTokens.neutral100),
                          _buildInfoRow(
                            '그린피',
                            '${_formatCurrency(rounding.greenFee)}원',
                          ),
                          const Divider(color: DesignTokens.neutral100),
                          _buildInfoRow(
                            '날씨',
                            '${_getWeatherIcon(rounding.weather)} ${rounding.weather} ${rounding.temperature}°C',
                          ),
                          const Divider(color: DesignTokens.neutral100),
                          _buildInfoRow(
                            '참가 인원',
                            '${rounding.players.length}명 (1개 조)',
                            isLast: true,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: DesignTokens.spacing4),

                // Players Card
                Container(
                      padding: const EdgeInsets.all(DesignTokens.spacing4),
                      decoration: BoxDecoration(
                        color: DesignTokens.neutral0,
                        border: Border.all(color: DesignTokens.neutral200),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusXl,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '참가자',
                            style: TextStyle(
                              fontSize: DesignTokens.fontBase,
                              fontWeight: DesignTokens.fontBold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacing4),
                          ...rounding.players.map((player) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: DesignTokens.spacing3,
                              ),
                              child: Row(
                                children: [
                                  Avatar(
                                    imageUrl: player.avatar,
                                    name: player.name,
                                    size: AvatarSize.medium,
                                  ),
                                  const SizedBox(width: DesignTokens.spacing3),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          player.name,
                                          style: const TextStyle(
                                            fontSize: DesignTokens.fontSm,
                                            fontWeight:
                                                DesignTokens.fontSemibold,
                                            color: DesignTokens.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '평균 ${player.averageScore}타',
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
                            );
                          }).toList(),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 250.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: DesignTokens.spacing4),

                // Entrance Notice (if upcoming and not today)
                if (rounding.status == RoundingStatus.upcoming && dDay > 0)
                  Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                          ),
                          border: Border.all(color: DesignTokens.warning),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusXl,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('⏰', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: DesignTokens.spacing3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '경기장 입장 안내',
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontSm,
                                      fontWeight: DesignTokens.fontBold,
                                      color: Colors.amber[900],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: DesignTokens.spacing1 / 2,
                                  ),
                                  Text(
                                    '경기 당일 오전 8시부터 입장 가능합니다',
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontXs,
                                      color: Colors.amber[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 300.ms)
                      .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 100), // Space for bottom buttons
              ],
            ),
          ),

          // Bottom Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              decoration: const BoxDecoration(
                color: DesignTokens.neutral0,
                border: Border(top: BorderSide(color: DesignTokens.neutral200)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // QR Check-in Button (show on D-Day)
                  if (dDay == 0)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: DesignTokens.spacing2,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QRCheckinPage(rounding: rounding),
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
                            Icons.qr_code_2,
                            color: DesignTokens.neutral0,
                          ),
                          label: const Text(
                            'QR 체크인',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSm,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.neutral0,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Chat and Enter Course / View Report Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Open chat
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacing3,
                            ),
                            side: const BorderSide(
                              color: DesignTokens.neutral200,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                            ),
                          ),
                          child: const Text(
                            '💬 채팅방',
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
                        child: rounding.status == RoundingStatus.completed
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RoundReportPage(rounding: rounding),
                                    ),
                                  );
                                },
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
                                  '📊 리포트 보기',
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSm,
                                    fontWeight: DesignTokens.fontSemibold,
                                    color: DesignTokens.neutral0,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _canEnterCourse()
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StadiumPage(rounding: rounding),
                                          ),
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: DesignTokens.spacing3,
                                  ),
                                  backgroundColor: _canEnterCourse()
                                      ? DesignTokens.info
                                      : DesignTokens.neutral200,
                                  disabledBackgroundColor:
                                      DesignTokens.neutral200,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      DesignTokens.radiusLg,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '⚡ 경기장 입장',
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSm,
                                    fontWeight: DesignTokens.fontSemibold,
                                    color: _canEnterCourse()
                                        ? DesignTokens.neutral0
                                        : DesignTokens.textTertiary,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RealTimeGamePage(
                                  roundingId: rounding.id,
                                  courseName: rounding.courseName,
                                  date: DateFormat(
                                    'yyyy.MM.dd',
                                  ).format(DateTime.parse(rounding.date)),
                                  time: rounding.date.split('T').length > 1
                                      ? rounding.date
                                            .split('T')[1]
                                            .substring(0, 5)
                                      : '14:00',
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacing3,
                            ),
                            side: const BorderSide(color: DesignTokens.success),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                            ),
                          ),
                          child: const Text(
                            '📊 실시간 경기',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSm,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.success,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : DesignTokens.spacing3,
        top: DesignTokens.spacing3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeatherIcon(String weather) {
    switch (weather) {
      case '맑음':
        return '☀️';
      case '구름':
        return '☁️';
      case '흐림':
        return '🌥️';
      case '비':
        return '🌧️';
      case '눈':
        return '❄️';
      default:
        return '☀️';
    }
  }
}
