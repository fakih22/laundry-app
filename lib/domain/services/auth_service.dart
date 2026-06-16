import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<bool> sendOtp(String contact);
  Future<bool> verifyOtp(String otp);
  Future<bool> resetPassword(String email);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}
