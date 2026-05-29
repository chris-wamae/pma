import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../utils/validators.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  UserModel? user;
  bool isLoading = false;
  String? error;

  AuthViewModel([AuthRepository? repo]) : _repo = repo ?? AuthRepository();

  void _setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, {String? name, String role = 'Owner'}) async {
    _setLoading(true);
    // input validation
    if (!Validators.isValidEmail(email)) {
      error = 'Invalid email address';
      _setLoading(false);
      return false;
    }
    if (!Validators.isStrongPassword(password)) {
      error = Validators.passwordRequirements();
      _setLoading(false);
      return false;
    }

    try {
      final u = await _repo.signUp(email, password, name: name, role: role);
      user = u;
      error = null;
      return u != null;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    if (!Validators.isValidEmail(email)) {
      error = 'Invalid email address';
      _setLoading(false);
      return false;
    }
    if (password.isEmpty) {
      error = 'Password cannot be empty';
      _setLoading(false);
      return false;
    }

    try {
      final tokens = await _repo.signIn(email, password);
      final current = await _repo.getCurrentUser();
      user = current;
      error = tokens == null ? 'Invalid credentials' : null;
      return tokens != null;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendOtp(String email) async {
    if (!Validators.isValidEmail(email)) {
      error = 'Invalid email address';
      return false;
    }
    return _repo.sendOtp(email);
  }

  Future<bool> verifyOtp(String email, String code) async {
    return _repo.verifyOtp(email, code);
  }

  Future<bool> sendPasswordReset(String email) async {
    if (!Validators.isValidEmail(email)) {
      error = 'Invalid email address';
      return false;
    }
    return _repo.sendPasswordReset(email);
  }

  Future<bool> resetPassword(String email, String token, String newPassword) async {
    if (!Validators.isStrongPassword(newPassword)) {
      error = Validators.passwordRequirements();
      return false;
    }
    return _repo.resetPassword(email, token, newPassword);
  }

  Future<bool> refreshToken(String refreshToken) async {
    final tokens = await _repo.refreshToken(refreshToken);
    return tokens != null;
  }

  Future<void> signOut() async {
    if (user == null) return;
    await _repo.signOut(user!.uid);
    user = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    user = await _repo.getCurrentUser();
    notifyListeners();
  }

  /// Fetches the current user's role from the repository and updates `user`.
  Future<String?> getUserRole() async {
    final current = await _repo.getCurrentUser();
    if (current != null) {
      user = current;
      notifyListeners();
      return current.role;
    }
    return null;
  }
}
