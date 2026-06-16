class LaundryService {
  final String id;
  final String name;
  final String description;
  final String icon;
  final double basePrice;
  final String unit; // "kg" or "pc"
  final List<LaundryItem> items;

  LaundryService({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.basePrice,
    required this.unit,
    required this.items,
  });
}

class LaundryItem {
  final String id;
  final String name;
  final double price;
  final String icon; // Icon name
  int quantity;

  LaundryItem({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    this.quantity = 0,
  });

  LaundryItem copyWith({
    String? id,
    String? name,
    double? price,
    String? icon,
    int? quantity,
  }) {
    return LaundryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
    );
  }
}
