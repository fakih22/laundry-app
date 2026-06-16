class PromoModel {
  final String code;
  final String title;
  final String description;
  final double discountAmount;
  final double minTransaction;
  final DateTime expiryDate;

  PromoModel({
    required this.code,
    required this.title,
    required this.description,
    required this.discountAmount,
    required this.minTransaction,
    required this.expiryDate,
  });
}
