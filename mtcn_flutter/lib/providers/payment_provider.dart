import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/payment_service.dart';

/// PaymentService Provider
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService.instance;
});

/// 결제 처리 상태 Provider
class PaymentState {
  final bool isProcessing;
  final PaymentResult? result;
  final String? error;

  const PaymentState({this.isProcessing = false, this.result, this.error});

  PaymentState copyWith({
    bool? isProcessing,
    PaymentResult? result,
    String? error,
  }) {
    return PaymentState(
      isProcessing: isProcessing ?? this.isProcessing,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

/// PaymentNotifier
class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentService _paymentService;

  PaymentNotifier(this._paymentService) : super(const PaymentState());

  /// 결제 처리
  Future<PaymentResult> processPayment({
    required String roundingId,
    required String userId,
    required int amount,
    required PaymentMethod method,
    Map<String, dynamic>? extras,
  }) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final result = await _paymentService.processPayment(
        roundingId: roundingId,
        userId: userId,
        amount: amount,
        method: method,
        extras: extras,
      );

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: result.success ? null : result.errorMessage,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return PaymentResult.failure(errorMessage: e.toString());
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
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final result = await _paymentService.processCardPayment(
        roundingId: roundingId,
        userId: userId,
        amount: amount,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        cardPassword: cardPassword,
      );

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: result.success ? null : result.errorMessage,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return PaymentResult.failure(errorMessage: e.toString());
    }
  }

  /// 계좌이체
  Future<PaymentResult> processTransferPayment({
    required String roundingId,
    required String userId,
    required int amount,
    required String bankCode,
    required String accountNumber,
  }) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final result = await _paymentService.processTransferPayment(
        roundingId: roundingId,
        userId: userId,
        amount: amount,
        bankCode: bankCode,
        accountNumber: accountNumber,
      );

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: result.success ? null : result.errorMessage,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return PaymentResult.failure(errorMessage: e.toString());
    }
  }

  /// 간편결제
  Future<PaymentResult> processSimplePayment({
    required String roundingId,
    required String userId,
    required int amount,
    required PaymentMethod method,
  }) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final result = await _paymentService.processSimplePayment(
        roundingId: roundingId,
        userId: userId,
        amount: amount,
        method: method,
      );

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: result.success ? null : result.errorMessage,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return PaymentResult.failure(errorMessage: e.toString());
    }
  }

  /// 현장결제 등록
  Future<PaymentResult> registerCashPayment({
    required String roundingId,
    required String userId,
    required int amount,
  }) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final result = await _paymentService.registerCashPayment(
        roundingId: roundingId,
        userId: userId,
        amount: amount,
      );

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: result.success ? null : result.errorMessage,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return PaymentResult.failure(errorMessage: e.toString());
    }
  }

  /// 결제 취소/환불
  Future<PaymentResult> cancelPayment({
    required String transactionId,
    required String reason,
    int? refundAmount,
  }) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      final result = await _paymentService.cancelPayment(
        transactionId: transactionId,
        reason: reason,
        refundAmount: refundAmount,
      );

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: result.success ? null : result.errorMessage,
      );

      return result;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return PaymentResult.failure(errorMessage: e.toString());
    }
  }

  /// 상태 초기화
  void reset() {
    state = const PaymentState();
  }
}

/// Payment State Provider
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  final paymentService = ref.watch(paymentServiceProvider);
  return PaymentNotifier(paymentService);
});

/// 결제 내역 Provider (사용자별)
final paymentHistoryProvider = FutureProvider.family<List<PaymentInfo>, String>(
  (ref, userId) async {
    final paymentService = ref.watch(paymentServiceProvider);
    return paymentService.getPaymentHistory(userId: userId);
  },
);
