abstract class PaymentService {
  Future<bool> processPayment({
    required String orderId,
    required String paymentMethod,
    required double amount,
  });
}
