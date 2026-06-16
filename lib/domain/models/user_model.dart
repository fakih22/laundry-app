class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String tier; // e.g. "Platinum Member", "Gold Member", "Eco Hero"
  final int totalOrders;
  final int points;
  final double waterSaved; // in Liters, for the eco badge

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.tier,
    required this.totalOrders,
    required this.points,
    required this.waterSaved,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? tier,
    int? totalOrders,
    int? points,
    double? waterSaved,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      tier: tier ?? this.tier,
      totalOrders: totalOrders ?? this.totalOrders,
      points: points ?? this.points,
      waterSaved: waterSaved ?? this.waterSaved,
    );
  }
}
