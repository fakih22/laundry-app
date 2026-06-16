import 'laundry_service.dart';

enum OrderStatus {
  received,      // Order Received / Pesanan Diterima
  pickupAssigned,// Pickup Assigned / Kurir Ditugaskan
  processing,    // Laundry Processing / Sedang Dicuci
  ironing,       // Ironing / Sedang Disetrika
  packaging,     // Packaging / Pengemasan
  delivery,      // Delivery / Pengiriman
  completed,     // Completed / Selesai
  cancelled      // Cancelled / Dibatalkan
}

extension OrderStatusExtension on OrderStatus {
  String get displayNameIndonesian {
    switch (this) {
      case OrderStatus.received:
        return 'Pesanan Diterima';
      case OrderStatus.pickupAssigned:
        return 'Penjemputan';
      case OrderStatus.processing:
        return 'Sedang Dicuci';
      case OrderStatus.ironing:
        return 'Sedang Disetrika';
      case OrderStatus.packaging:
        return 'Pengemasan';
      case OrderStatus.delivery:
        return 'Pengiriman';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String get stepDescriptionIndonesian {
    switch (this) {
      case OrderStatus.received:
        return 'Pesanan berhasil dibuat dan dikonfirmasi.';
      case OrderStatus.pickupAssigned:
        return 'Kurir sedang menjemput pakaian Anda.';
      case OrderStatus.processing:
        return 'Pakaian sedang dicuci dan dibersihkan dari noda.';
      case OrderStatus.ironing:
        return 'Pakaian sedang disetrika agar rapi.';
      case OrderStatus.packaging:
        return 'Pakaian sedang dikemas dengan rapi dan steril.';
      case OrderStatus.delivery:
        return 'Pakaian sedang dikirim kembali ke alamat Anda.';
      case OrderStatus.completed:
        return 'Pesanan telah selesai diantar dan diterima.';
      case OrderStatus.cancelled:
        return 'Pesanan dibatalkan karena kendala pembayaran/sistem.';
    }
  }
}

class OrderModel {
  final String id;
  final String serviceName;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final double estimatedWeight;
  final List<LaundryItem> items;
  final String addressName;
  final String addressDetail;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double totalAmount;
  final String driverName;
  final double driverRating;
  final String driverAvatar;
  final int driverOrdersCount;
  final String? promoCode;

  OrderModel({
    required this.id,
    required this.serviceName,
    required this.status,
    required this.orderDate,
    required this.pickupDate,
    required this.deliveryDate,
    required this.estimatedWeight,
    required this.items,
    required this.addressName,
    required this.addressDetail,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.driverName,
    required this.driverRating,
    required this.driverAvatar,
    required this.driverOrdersCount,
    this.promoCode,
  });

  OrderModel copyWith({
    String? id,
    String? serviceName,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? pickupDate,
    DateTime? deliveryDate,
    double? estimatedWeight,
    List<LaundryItem>? items,
    String? addressName,
    String? addressDetail,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? discount,
    double? totalAmount,
    String? driverName,
    double? driverRating,
    String? driverAvatar,
    int? driverOrdersCount,
    String? promoCode,
  }) {
    return OrderModel(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      items: items ?? this.items,
      addressName: addressName ?? this.addressName,
      addressDetail: addressDetail ?? this.addressDetail,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      driverName: driverName ?? this.driverName,
      driverRating: driverRating ?? this.driverRating,
      driverAvatar: driverAvatar ?? this.driverAvatar,
      driverOrdersCount: driverOrdersCount ?? this.driverOrdersCount,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}
