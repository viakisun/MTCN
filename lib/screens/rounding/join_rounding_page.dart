import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';
import '../../models/player.dart';

/// 결제 방법
enum PaymentMethod { card, transfer, cash }

class JoinRoundingPage extends ConsumerStatefulWidget {
  final Rounding rounding;

  const JoinRoundingPage({super.key, required this.rounding});

  @override
  ConsumerState<JoinRoundingPage> createState() => _JoinRoundingPageState();
}

class _JoinRoundingPageState extends ConsumerState<JoinRoundingPage> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  bool _agreeToTerms = false;
  bool _isProcessing = false;

  String get _paymentMethodLabel {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.card:
        return '신용카드';
      case PaymentMethod.transfer:
        return '계좌이체';
      case PaymentMethod.cash:
        return '현장결제';
    }
  }

  IconData get _paymentMethodIcon {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.transfer:
        return Icons.account_balance;
      case PaymentMethod.cash:
        return Icons.money;
    }
  }

  int get _totalAmount {
    return (widget.rounding.greenFee) + (widget.rounding.fee ?? 0);
  }

  Future<void> _submitJoinRequest() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('약관에 동의해주세요'),
          backgroundColor: DesignTokens.error,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // TODO: 실제 결제 및 참가 신청 처리
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isProcessing = false);

    // 성공 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: DesignTokens.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: DesignTokens.neutral0,
                size: 40,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            const Text(
              '참가 신청 완료!',
              style: TextStyle(
                fontSize: DesignTokens.fontXl,
                fontWeight: DesignTokens.fontBold,
                color: DesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing2),
            Text(
              '${widget.rounding.eventName} 참가 신청이\n성공적으로 완료되었습니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary600,
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignTokens.spacing3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: DesignTokens.fontBase,
                    fontWeight: DesignTokens.fontSemibold,
                    color: DesignTokens.neutral0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR');

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
          '라운딩 참가 신청',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rounding Info Section
                _buildRoundingInfoSection(dateFormat),
                const SizedBox(height: DesignTokens.spacing4),

                // Participants Section
                _buildParticipantsSection(),
                const SizedBox(height: DesignTokens.spacing4),

                // Options Section
                if (widget.rounding.options != null) ...[
                  _buildOptionsSection(),
                  const SizedBox(height: DesignTokens.spacing4),
                ],

                // Payment Method Section
                _buildPaymentMethodSection(),
                const SizedBox(height: DesignTokens.spacing4),

                // Cost Breakdown Section
                _buildCostBreakdownSection(),
                const SizedBox(height: DesignTokens.spacing4),

                // Terms & Conditions
                _buildTermsSection(),
                const SizedBox(height: DesignTokens.spacing20),
              ],
            ),
          ),

          // Bottom Submit Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSubmitButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundingInfoSection(DateFormat dateFormat) {
    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing2,
                  vertical: DesignTokens.spacing1,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.primary100,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                child: Text(
                  widget.rounding.status == RoundingStatus.upcoming
                      ? '모집중'
                      : '진행중',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontXs,
                    fontWeight: DesignTokens.fontSemibold,
                    color: DesignTokens.primary600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${widget.rounding.players.length}/${widget.rounding.maxPlayers ?? 24}명',
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontSemibold,
                  color: DesignTokens.primary600,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing3),
          Text(
            widget.rounding.eventName,
            style: const TextStyle(
              fontSize: DesignTokens.fontXl,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: DesignTokens.textSecondary,
              ),
              const SizedBox(width: DesignTokens.spacing1),
              Expanded(
                child: Text(
                  widget.rounding.courseName,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (widget.rounding.courseAddress != null) ...[
            const SizedBox(height: DesignTokens.spacing1),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.rounding.courseAddress!,
                style: const TextStyle(
                  fontSize: DesignTokens.fontXs,
                  color: DesignTokens.textTertiary,
                ),
              ),
            ),
          ],
          const SizedBox(height: DesignTokens.spacing3),
          const Divider(),
          const SizedBox(height: DesignTokens.spacing3),
          _buildInfoRow(Icons.calendar_today, '날짜', widget.rounding.date),
          const SizedBox(height: DesignTokens.spacing2),
          _buildInfoRow(Icons.access_time, '시간', widget.rounding.time),
          const SizedBox(height: DesignTokens.spacing2),
          _buildInfoRow(Icons.golf_course, '홀 수', '${widget.rounding.holes}홀'),
          if (widget.rounding.description != null) ...[
            const SizedBox(height: DesignTokens.spacing3),
            const Divider(),
            const SizedBox(height: DesignTokens.spacing3),
            Text(
              widget.rounding.description!,
              style: const TextStyle(
                fontSize: DesignTokens.fontSm,
                color: DesignTokens.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: DesignTokens.textSecondary),
        const SizedBox(width: DesignTokens.spacing2),
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontSm,
            color: DesignTokens.textSecondary,
          ),
        ),
        const SizedBox(width: DesignTokens.spacing2),
        Text(
          value,
          style: const TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection() {
    return Container(
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
                children: [
                  const Text(
                    '참가자',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '${widget.rounding.players.length}명',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontSemibold,
                      color: DesignTokens.primary600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing3),
              Wrap(
                spacing: DesignTokens.spacing2,
                runSpacing: DesignTokens.spacing2,
                children: widget.rounding.players.take(8).map((player) {
                  return _buildPlayerChip(player);
                }).toList(),
              ),
              if (widget.rounding.players.length > 8) ...[
                const SizedBox(height: DesignTokens.spacing2),
                Text(
                  '외 ${widget.rounding.players.length - 8}명',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontXs,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 50.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildPlayerChip(Player player) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing2,
        vertical: DesignTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.neutral50,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: DesignTokens.neutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: DesignTokens.primary100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player.name[0],
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.primary600,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing1),
          Text(
            player.name,
            style: const TextStyle(
              fontSize: DesignTokens.fontXs,
              color: DesignTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    final options = widget.rounding.options!;

    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '포함 옵션',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              Wrap(
                spacing: DesignTokens.spacing2,
                runSpacing: DesignTokens.spacing2,
                children: [
                  if (options.includeCaddie)
                    _buildOptionChip('캐디', Icons.person),
                  if (options.includeCart)
                    _buildOptionChip('카트', Icons.directions_car),
                  if (options.includeMeal) ...[
                    _buildOptionChip(
                      options.mealType == 'breakfast'
                          ? '조식'
                          : options.mealType == 'lunch'
                          ? '중식'
                          : '석식',
                      Icons.restaurant,
                    ),
                  ],
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildOptionChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing3,
        vertical: DesignTokens.spacing2,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(color: DesignTokens.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: DesignTokens.success),
          const SizedBox(width: DesignTokens.spacing1),
          Text(
            label,
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '결제 방법',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              _buildPaymentMethodOption(
                PaymentMethod.card,
                '신용카드',
                Icons.credit_card,
                '간편하고 빠른 결제',
              ),
              const SizedBox(height: DesignTokens.spacing2),
              _buildPaymentMethodOption(
                PaymentMethod.transfer,
                '계좌이체',
                Icons.account_balance,
                '수수료 없는 직접 이체',
              ),
              const SizedBox(height: DesignTokens.spacing2),
              _buildPaymentMethodOption(
                PaymentMethod.cash,
                '현장결제',
                Icons.money,
                '라운딩 당일 현장 결제',
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 150.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildPaymentMethodOption(
    PaymentMethod method,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacing3),
        decoration: BoxDecoration(
          color: isSelected ? DesignTokens.primary50 : DesignTokens.neutral50,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: isSelected
                ? DesignTokens.primary600
                : DesignTokens.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? DesignTokens.primary100
                    : DesignTokens.neutral100,
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? DesignTokens.primary600
                    : DesignTokens.textSecondary,
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
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontSemibold,
                      color: isSelected
                          ? DesignTokens.primary600
                          : DesignTokens.textPrimary,
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
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: DesignTokens.primary600,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdownSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '결제 내역',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              _buildCostRow('그린피', widget.rounding.greenFee),
              if (widget.rounding.fee != null && widget.rounding.fee! > 0) ...[
                const SizedBox(height: DesignTokens.spacing2),
                _buildCostRow('참가비', widget.rounding.fee!),
              ],
              const SizedBox(height: DesignTokens.spacing3),
              const Divider(),
              const SizedBox(height: DesignTokens.spacing3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '총 결제 금액',
                    style: TextStyle(
                      fontSize: DesignTokens.fontBase,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,###').format(_totalAmount)}원',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontXl,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.primary600,
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

  Widget _buildCostRow(String label, int amount) {
    return Row(
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
          '${NumberFormat('#,###').format(amount)}원',
          style: const TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '약관 동의',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              InkWell(
                onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _agreeToTerms
                            ? DesignTokens.primary600
                            : DesignTokens.neutral0,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMd,
                        ),
                        border: Border.all(
                          color: _agreeToTerms
                              ? DesignTokens.primary600
                              : DesignTokens.neutral300,
                          width: 2,
                        ),
                      ),
                      child: _agreeToTerms
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: DesignTokens.neutral0,
                            )
                          : null,
                    ),
                    const SizedBox(width: DesignTokens.spacing2),
                    const Expanded(
                      child: Text(
                        '환불 정책 및 이용약관에 동의합니다',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSm,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DesignTokens.spacing2),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  '• 라운딩 3일 전까지: 전액 환불\n• 2일 전: 50% 환불\n• 1일 전 및 당일: 환불 불가',
                  style: TextStyle(
                    fontSize: DesignTokens.fontXs,
                    color: DesignTokens.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 250.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildBottomSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: const BoxDecoration(
        color: DesignTokens.neutral0,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '총 결제 금액',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),
                Text(
                  '${NumberFormat('#,###').format(_totalAmount)}원',
                  style: const TextStyle(
                    fontSize: DesignTokens.fontLg,
                    fontWeight: DesignTokens.fontBold,
                    color: DesignTokens.primary600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacing3),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _submitJoinRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary600,
                  disabledBackgroundColor: DesignTokens.neutral300,
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignTokens.spacing4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            DesignTokens.neutral0,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _paymentMethodIcon,
                            size: 20,
                            color: DesignTokens.neutral0,
                          ),
                          const SizedBox(width: DesignTokens.spacing2),
                          Text(
                            '$_paymentMethodLabel로 결제하기',
                            style: const TextStyle(
                              fontSize: DesignTokens.fontBase,
                              fontWeight: DesignTokens.fontSemibold,
                              color: DesignTokens.neutral0,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
