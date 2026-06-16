import '../models/order_model.dart';

abstract class OrderService {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
  Future<OrderModel?> getOrderById(String id);
  Stream<OrderStatus> trackOrder(String id);
}
