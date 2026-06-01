import '../models/user_model.dart';

abstract class AuthService {
  /// Registers a new user and returns the created UserModel.
  Future<UserModel?> signUp(String email, String password, {String? name, String role = 'Owner'});

  /// Signs in and returns a map with accessToken and refreshToken.
  Future<Map<String, String>?> signIn(String email, String password);

  Future<bool> sendOtp(String email);
  Future<bool> verifyOtp(String email, String code);

  Future<bool> sendPasswordReset(String email);
  Future<bool> resetPassword(String email, String token, String newPassword);

  Future<Map<String, String>?> refreshToken(String refreshToken);
  Future<void> signOut(String uid);

  Future<UserModel?> getCurrentUser();
}
