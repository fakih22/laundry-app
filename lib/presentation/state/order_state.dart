import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/order_model.dart';
import '../../domain/services/order_service.dart';
import 'cart_state.dart';

class OrderState with ChangeNotifier {
  final OrderService _orderService;
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Keep track of active order status subscriptions
  final Map<String, StreamSubscription<OrderStatus>> _subscriptions = {};

  OrderState(this._orderService) {
    loadOrders();
  }

  List<OrderModel> get orders => _orders;
  List<OrderModel> get activeOrders => _orders.where((o) => o.status != OrderStatus.completed && o.status != OrderStatus.cancelled).toList();
  List<OrderModel> get completedOrders => _orders.where((o) => o.status == OrderStatus.completed).toList();
  List<OrderModel> get cancelledOrders => _orders.where((o) => o.status == OrderStatus.cancelled).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    for (var sub in _subscriptions.values) {
      sub.cancel();
    }
    super.dispose();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _orders = await _orderService.getOrders();
      // Start tracking active orders
      for (var order in _orders) {
        if (order.status != OrderStatus.completed && order.status != OrderStatus.cancelled) {
          _subscribeToOrderTracking(order.id);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel?> placeOrder(CartState cart, String paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final newOrder = OrderModel(
        id: 'LK-${1000 + _orders.length + DateTime.now().millisecond}',
        serviceName: cart.selectedService?.name ?? 'Layanan Laundry',
        status: OrderStatus.received,
        orderDate: DateTime.now(),
        pickupDate: cart.pickupSchedule,
        deliveryDate: cart.deliverySchedule,
        estimatedWeight: cart.estimatedWeight,
        items: cart.items,
        addressName: cart.addressName,
        addressDetail: cart.addressDetail,
        subtotal: cart.subtotal,
        deliveryFee: cart.deliveryFee,
        tax: cart.tax,
        discount: cart.discount,
        totalAmount: cart.totalAmount,
        driverName: 'Budi Santoso',
        driverRating: 4.9,
        driverAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        driverOrdersCount: 2401,
        promoCode: cart.appliedPromo?.code,
      );

      final created = await _orderService.createOrder(newOrder);
      _orders.insert(0, created);
      
      // Subscribe to active status changes
      _subscribeToOrderTracking(created.id);
      
      notifyListeners();
      return created;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _subscribeToOrderTracking(String orderId) {
    if (_subscriptions.containsKey(orderId)) return;

    final sub = _orderService.trackOrder(orderId).listen((status) {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: status);
        notifyListeners();

        if (status == OrderStatus.completed || status == OrderStatus.cancelled) {
          _subscriptions[orderId]?.cancel();
          _subscriptions.remove(orderId);
        }
      }
    });

    _subscriptions[orderId] = sub;
  }
}
