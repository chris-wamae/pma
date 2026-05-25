// import '../models/user_model.dart';
// import '../services/auth_service.dart';
// import '../services/service_locator.dart';

// class AuthRepository {
//   final AuthService _service;
//   AuthRepository([AuthService? service]) : _service = service ?? authService;

//   Future<UserModel?> signUp(String email, String password, {String? name, String role = 'Owner'}) {
//     return _service.signUp(email, password, name: name, role: role);
//   }

//   Future<Map<String, String>?> signIn(String email, String password) {
//     return _service.signIn(email, password);
//   }

//   Future<bool> sendOtp(String email) => _service.sendOtp(email);
//   Future<bool> verifyOtp(String email, String code) => _service.verifyOtp(email, code);

//   Future<bool> sendPasswordReset(String email) => _service.sendPasswordReset(email);
//   Future<bool> resetPassword(String email, String token, String newPassword) => _service.resetPassword(email, token, newPassword);

//   Future<Map<String, String>?> refreshToken(String refreshToken) => _service.refreshToken(refreshToken);
//   Future<void> signOut(String uid) => _service.signOut(uid);

//   Future<UserModel?> getCurrentUser() => _service.getCurrentUser();
// }
