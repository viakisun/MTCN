import 'package:flutter/foundation.dart';

/// 결제 결과
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final DateTime timestamp;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  PaymentResult.success({required String transactionId})
    : this(success: true, transactionId: transactionId);

  PaymentResult.failure({required String errorMessage})
    : this(success: false, errorMessage: errorMessage);
}

/// 결제 방법
enum PaymentMethod {
  card, // 신용카드
  transfer, // 계좌이체
  cash, // 현장결제
  kakaoPay, // 카카오페이
  naverPay, // 네이버페이
  tosspay, // 토스페이
}

/// 결제 정보
class PaymentInfo {
  final String roundingId;
  final String userId;
  final int amount;
  final PaymentMethod method;
  final String? cardNumber; // 마스킹된 카드번호
  final String? accountNumber; // 계좌번호
  final Map<String, dynamic>? extras; // 추가 정보

  const PaymentInfo({
    required this.roundingId,
    required this.userId,
    required this.amount,
    required this.method,
    this.cardNumber,
    this.accountNumber,
    this.extras,
  });

  Map<String, dynamic> toJson() {
    return {
      'roundingId': roundingId,
      'userId': userId,
      'amount': amount,
      'method': method.name,
      'cardNumber': cardNumber,
      'accountNumber': accountNumber,
      'extras': extras,
    };
  }
}

/// 결제 서비스
///
/// 아임포트, 토스페이먼츠 등 결제 게이트웨이 연동
/// 현재는 Mock 구현이며, 실제 결제는 Phase 2-B에서 연동
class PaymentService {
  PaymentService._();
  static final PaymentService instance = PaymentService._();

  /// 결제 처리
  ///
  /// TODO: 실제 결제 게이트웨이 연동
  /// - 아임포트: https://github.com/iamport/iamport_flutter
  /// - 토스페이먼츠: https://docs.tosspayments.com/
  Future<PaymentResult> processPayment({
    required String roundingId,
    required String userId,
    required int amount,
    required PaymentMethod method,
    Map<String, dynamic>? extras,
  }) async {
    try {
      debugPrint('=== Payment Processing ===');
      debugPrint('Rounding ID: $roundingId');
      debugPrint('User ID: $userId');
      debugPrint('Amount: $amount원');
      debugPrint('Method: ${method.name}');

      // Mock 결제 처리 (2초 지연)
      await Future.delayed(const Duration(seconds: 2));

      // Mock 성공 (90% 확률)
      final success = DateTime.now().millisecond % 10 != 0;

      if (success) {
        final transactionId = _generateTransactionId();
        debugPrint('Payment Success! Transaction ID: $transactionId');

        // TODO: 실제 결제 후 서버에 결과 저장
        await _savePaymentRecord(
          roundingId: roundingId,
          userId: userId,
          amount: amount,
          method: method,
          transactionId: transactionId,
        );

        return PaymentResult.success(transactionId: transactionId);
      } else {
        debugPrint('Payment Failed: Insufficient balance');
        return PaymentResult.failure(errorMessage: '잔액이 부족합니다');
      }
    } catch (e) {
      debugPrint('Payment Error: $e');
      return PaymentResult.failure(errorMessage: '결제 처리 중 오류가 발생했습니다');
    }
  }

  /// 카드 결제
  Future<PaymentResult> processCardPayment({
    required String roundingId,
    required String userId,
    required int amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    String? cardPassword,
  }) async {
    // TODO: 실제 PG사 카드 결제 API 호출
    // 카드번호 마스킹
    final maskedCardNumber = _maskCardNumber(cardNumber);

    return processPayment(
      roundingId: roundingId,
      userId: userId,
      amount: amount,
      method: PaymentMethod.card,
      extras: {'cardNumber': maskedCardNumber, 'expiryDate': expiryDate},
    );
  }

  /// 계좌이체 결제
  Future<PaymentResult> processTransferPayment({
    required String roundingId,
    required String userId,
    required int amount,
    required String bankCode,
    required String accountNumber,
  }) async {
    // TODO: 실제 계좌이체 API 호출
    return processPayment(
      roundingId: roundingId,
      userId: userId,
      amount: amount,
      method: PaymentMethod.transfer,
      extras: {'bankCode': bankCode, 'accountNumber': accountNumber},
    );
  }

  /// 간편결제 (카카오페이, 네이버페이, 토스페이)
  Future<PaymentResult> processSimplePayment({
    required String roundingId,
    required String userId,
    required int amount,
    required PaymentMethod method, // kakaoPay, naverPay, tosspay
  }) async {
    assert(
      method == PaymentMethod.kakaoPay ||
          method == PaymentMethod.naverPay ||
          method == PaymentMethod.tosspay,
      'Invalid simple payment method',
    );

    // TODO: 각 간편결제 SDK 연동
    // - 카카오페이: https://developers.kakao.com/docs/latest/ko/kakaopay/common
    // - 네이버페이: https://developer.pay.naver.com/docs/v2/api
    // - 토스페이: https://docs.tosspayments.com/reference/widget-sdk

    return processPayment(
      roundingId: roundingId,
      userId: userId,
      amount: amount,
      method: method,
    );
  }

  /// 현장결제 등록
  Future<PaymentResult> registerCashPayment({
    required String roundingId,
    required String userId,
    required int amount,
  }) async {
    // 현장결제는 실제 결제 없이 참가 신청만 등록
    debugPrint('=== Cash Payment Registration ===');
    debugPrint('Rounding ID: $roundingId');
    debugPrint('User ID: $userId');
    debugPrint('Amount: $amount원 (현장결제 예정)');

    await Future.delayed(const Duration(seconds: 1));

    final transactionId = _generateTransactionId();

    // TODO: 서버에 현장결제 예정으로 저장
    await _savePaymentRecord(
      roundingId: roundingId,
      userId: userId,
      amount: amount,
      method: PaymentMethod.cash,
      transactionId: transactionId,
      isPending: true,
    );

    return PaymentResult.success(transactionId: transactionId);
  }

  /// 결제 취소/환불
  Future<PaymentResult> cancelPayment({
    required String transactionId,
    required String reason,
    int? refundAmount, // null이면 전액 환불
  }) async {
    try {
      debugPrint('=== Payment Cancellation ===');
      debugPrint('Transaction ID: $transactionId');
      debugPrint('Reason: $reason');
      debugPrint('Refund Amount: ${refundAmount ?? "전액"}');

      // TODO: 실제 결제 취소 API 호출
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('Cancellation Success!');
      return PaymentResult.success(transactionId: transactionId);
    } catch (e) {
      debugPrint('Cancellation Error: $e');
      return PaymentResult.failure(errorMessage: '환불 처리 중 오류가 발생했습니다');
    }
  }

  /// 결제 기록 조회
  Future<List<PaymentInfo>> getPaymentHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // TODO: 서버에서 결제 기록 조회
    debugPrint('=== Fetching Payment History ===');
    debugPrint('User ID: $userId');

    await Future.delayed(const Duration(seconds: 1));

    // Mock 데이터 반환
    return [];
  }

  /// 결제 상태 확인
  Future<PaymentResult?> checkPaymentStatus({
    required String transactionId,
  }) async {
    // TODO: 결제 상태 조회 API 호출
    debugPrint('=== Checking Payment Status ===');
    debugPrint('Transaction ID: $transactionId');

    await Future.delayed(const Duration(milliseconds: 500));

    return null;
  }

  // ========== Private Methods ==========

  /// 트랜잭션 ID 생성
  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return 'TXN${timestamp}_$random';
  }

  /// 카드번호 마스킹 (1234-5678-****-****)
  String _maskCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 12) return cardNumber;

    return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-****-****';
  }

  /// 결제 기록 저장
  Future<void> _savePaymentRecord({
    required String roundingId,
    required String userId,
    required int amount,
    required PaymentMethod method,
    required String transactionId,
    bool isPending = false,
  }) async {
    // TODO: Firebase/Supabase에 결제 기록 저장
    debugPrint('=== Saving Payment Record ===');
    debugPrint('Transaction ID: $transactionId');
    debugPrint('Status: ${isPending ? "Pending" : "Completed"}');

    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Payment record saved successfully');
  }
}
