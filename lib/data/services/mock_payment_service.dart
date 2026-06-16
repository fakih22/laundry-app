import '../../domain/services/payment_service.dart';

class MockPaymentService implements PaymentService {
  @override
  Future<bool> processPayment({
    required String orderId,
    required String paymentMethod,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Mock payment success
  }
}
