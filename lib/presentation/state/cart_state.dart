import 'package:flutter/material.dart';
import '../../domain/models/laundry_service.dart';
import '../../domain/models/promo_model.dart';

class CartState with ChangeNotifier {
  LaundryService? _selectedService;
  final List<LaundryItem> _items = [];
  double _estimatedWeight = 2.5; // Default 2.5 kg
  DateTime _pickupSchedule = DateTime.now().add(const Duration(hours: 2));
  DateTime _deliverySchedule = DateTime.now().add(const Duration(days: 2));
  
  String _addressName = 'Rumah';
  String _addressDetail = 'Apartemen Skyline, Penthouse 4B, Jl. Midtown Raya No. 12';
  
  PromoModel? _appliedPromo;
  final double _deliveryFee = 5000.0; // Standard Rp 5.000 delivery

  LaundryService? get selectedService => _selectedService;
  List<LaundryItem> get items => _items.where((i) => i.quantity > 0).toList();
  double get estimatedWeight => _estimatedWeight;
  DateTime get pickupSchedule => _pickupSchedule;
  DateTime get deliverySchedule => _deliverySchedule;
  String get addressName => _addressName;
  String get addressDetail => _addressDetail;
  PromoModel? get appliedPromo => _appliedPromo;
  double get deliveryFee => _deliveryFee;

  void selectService(LaundryService service) {
    if (_selectedService?.id != service.id) {
      _selectedService = service;
      _items.clear();
      for (var item in service.items) {
        _items.add(item.copyWith(quantity: 0));
      }
      _estimatedWeight = service.unit == 'kg' ? 2.5 : 1.0;
      _appliedPromo = null;
      notifyListeners();
    }
  }

  void updateItemQuantity(String itemId, int delta) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      int newQty = _items[index].quantity + delta;
      if (newQty < 0) newQty = 0;
      _items[index] = _items[index].copyWith(quantity: newQty);
      notifyListeners();
    }
  }

  void setWeight(double weight) {
    _estimatedWeight = weight;
    notifyListeners();
  }

  void setSchedules(DateTime pickup, DateTime delivery) {
    _pickupSchedule = pickup;
    _deliverySchedule = delivery;
    notifyListeners();
  }

  void setAddress(String name, String detail) {
    _addressName = name;
    _addressDetail = detail;
    notifyListeners();
  }

  bool applyPromo(PromoModel promo) {
    if (subtotal >= promo.minTransaction) {
      _appliedPromo = promo;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedPromo = null;
    notifyListeners();
  }

  double get subtotal {
    if (_selectedService == null) return 0.0;
    
    double itemsTotal = 0.0;
    for (var item in _items) {
      itemsTotal += item.price * item.quantity;
    }

    if (_selectedService!.unit == 'kg') {
      return (_selectedService!.basePrice * _estimatedWeight) + itemsTotal;
    } else {
      // For pc unit, base price applies per item, or if items are added, we sum the items, and if no items we use 1 * basePrice
      if (itemsTotal > 0) {
        return itemsTotal;
      } else {
        return _selectedService!.basePrice * _estimatedWeight;
      }
    }
  }

  double get tax => subtotal * 0.05; // 5% tax

  double get discount {
    if (_appliedPromo == null) return 0.0;
    return _appliedPromo!.discountAmount;
  }

  double get totalAmount {
    double total = subtotal + _deliveryFee + tax - discount;
    return total < 0 ? 0.0 : total;
  }

  void clearCart() {
    _selectedService = null;
    _items.clear();
    _estimatedWeight = 2.5;
    _appliedPromo = null;
    _pickupSchedule = DateTime.now().add(const Duration(hours: 2));
    _deliverySchedule = DateTime.now().add(const Duration(days: 2));
    notifyListeners();
  }
}
