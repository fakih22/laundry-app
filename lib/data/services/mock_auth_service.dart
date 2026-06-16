import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_model.dart';
import '../../domain/services/auth_service.dart';

class MockAuthService implements AuthService {
  UserModel? _currentUser;
  static const String _tokenKey = 'auth_token';

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password tidak boleh kosong.');
    }
    
    // Simulate auth success
    _currentUser = UserModel(
      id: 'usr-8831',
      name: email.split('@')[0].toUpperCase(),
      email: email,
      profileImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      tier: 'Platinum Member',
      totalOrders: 124,
      points: 2850,
      waterSaved: 450.0,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, 'mock-jwt-token-xyz');
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', _currentUser!.name);

    return _currentUser!;
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Semua kolom harus diisi.');
    }

    _currentUser = UserModel(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      profileImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      tier: 'Bronze Member',
      totalOrders: 0,
      points: 50, // Welcome points
      waterSaved: 0.0,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, 'mock-jwt-token-xyz');
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', name);

    return _currentUser!;
  }

  @override
  Future<bool> sendOtp(String contact) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return otp == '1234' || otp.length == 4; // Mock validation
  }

  @override
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove('user_email');
    await prefs.remove('user_name');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      final email = prefs.getString('user_email') ?? 'julian@example.com';
      final name = prefs.getString('user_name') ?? 'Julian Thorne';
      _currentUser = UserModel(
        id: 'usr-8831',
        name: name,
        email: email,
        profileImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        tier: 'Platinum Member',
        totalOrders: 124,
        points: 2850,
        waterSaved: 450.0,
      );
      return _currentUser;
    }
    return null;
  }
}
