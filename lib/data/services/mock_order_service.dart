import 'dart:async';
import '../../domain/models/order_model.dart';
import '../../domain/services/order_service.dart';

class MockOrderService implements OrderService {
  final List<OrderModel> _orders = [];
  final Map<String, StreamController<OrderStatus>> _trackingControllers = {};

  MockOrderService() {
    _prepopulateOrders();
  }

  void _prepopulateOrders() {
    _orders.addAll([
      OrderModel(
        id: 'LK-9021',
        serviceName: 'Premium Cuci & Lipat',
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(hours: 4)),
        pickupDate: DateTime.now().subtract(const Duration(hours: 3)),
        deliveryDate: DateTime.now().add(const Duration(hours: 2)),
        estimatedWeight: 5.0,
        items: [],
        addressName: 'Rumah',
        addressDetail: 'Apartemen Skyline, Penthouse 4B, Jl. Midtown Raya No. 10',
        subtotal: 30000.0,
        deliveryFee: 5000.0,
        tax: 1500.0,
        discount: 10000.0,
        totalAmount: 26500.0,
        driverName: 'Budi Santoso',
        driverRating: 4.9,
        driverAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        driverOrdersCount: 2401,
      ),
      OrderModel(
        id: 'LK-8842',
        serviceName: 'Cuci Kering (5 Item)',
        status: OrderStatus.completed,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        pickupDate: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 2)),
        estimatedWeight: 0.0,
        items: [],
        addressName: 'Kantor',
        addressDetail: 'Gedung Cyber, Lantai 12, Sudirman, Jakarta',
        subtotal: 75000.0,
        deliveryFee: 5000.0,
        tax: 3750.0,
        discount: 0.0,
        totalAmount: 83750.0,
        driverName: 'Rian Wijaya',
        driverRating: 4.8,
        driverAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
        driverOrdersCount: 1820,
      ),
      OrderModel(
        id: 'LK-8711',
        serviceName: 'Setrika Kemeja & Sprei',
        status: OrderStatus.completed,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        pickupDate: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 4)),
        estimatedWeight: 4.5,
        items: [],
        addressName: 'Rumah',
        addressDetail: 'Apartemen Skyline, Penthouse 4B, Jl. Midtown Raya No. 10',
        subtotal: 18000.0,
        deliveryFee: 5000.0,
        tax: 900.0,
        discount: 5000.0,
        totalAmount: 18900.0,
        driverName: 'Budi Santoso',
        driverRating: 4.9,
        driverAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        driverOrdersCount: 2401,
      ),
      OrderModel(
        id: 'LK-8509',
        serviceName: 'Cuci & Lipat Standar',
        status: OrderStatus.cancelled,
        orderDate: DateTime.now().subtract(const Duration(days: 10)),
        pickupDate: DateTime.now().subtract(const Duration(days: 10)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 10)),
        estimatedWeight: 3.0,
        items: [],
        addressName: 'Rumah',
        addressDetail: 'Apartemen Skyline, Penthouse 4B, Jl. Midtown Raya No. 10',
        subtotal: 18000.0,
        deliveryFee: 5000.0,
        tax: 900.0,
        discount: 0.0,
        totalAmount: 23900.0,
        driverName: 'Dani Ramadhan',
        driverRating: 4.6,
        driverAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        driverOrdersCount: 502,
      ),
    ]);
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    await Future.delayed(const Duration(seconds: 1));
    _orders.insert(0, order);
    
    // Start status simulation stream
    _simulateOrderStatusProgression(order.id);
    
    return order;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_orders);
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<OrderStatus> trackOrder(String id) {
    if (!_trackingControllers.containsKey(id)) {
      final controller = StreamController<OrderStatus>.broadcast();
      _trackingControllers[id] = controller;
      
      // Emit current status immediately
      getOrderById(id).then((order) {
        if (order != null) {
          controller.add(order.status);
          if (order.status != OrderStatus.completed && order.status != OrderStatus.cancelled) {
            _simulateOrderStatusProgression(id);
          }
        }
      });
    }
    return _trackingControllers[id]!.stream;
  }

  void _simulateOrderStatusProgression(String orderId) {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index == -1) {
        timer.cancel();
        return;
      }

      final order = _orders[index];
      OrderStatus nextStatus;

      switch (order.status) {
        case OrderStatus.received:
          nextStatus = OrderStatus.pickupAssigned;
          break;
        case OrderStatus.pickupAssigned:
          nextStatus = OrderStatus.processing;
          break;
        case OrderStatus.processing:
          nextStatus = OrderStatus.ironing;
          break;
        case OrderStatus.ironing:
          nextStatus = OrderStatus.packaging;
          break;
        case OrderStatus.packaging:
          nextStatus = OrderStatus.delivery;
          break;
        case OrderStatus.delivery:
          nextStatus = OrderStatus.completed;
          break;
        case OrderStatus.completed:
        case OrderStatus.cancelled:
          timer.cancel();
          return;
      }

      // Update order in list
      _orders[index] = order.copyWith(status: nextStatus);
      
      // Push to stream
      if (_trackingControllers.containsKey(orderId)) {
        _trackingControllers[orderId]!.add(nextStatus);
      }

      if (nextStatus == OrderStatus.completed) {
        timer.cancel();
      }
    });
  }
}
