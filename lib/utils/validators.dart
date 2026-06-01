class Validators {
  static final RegExp _emailReg = RegExp(r"^[\w\-\.]+@([\w\-]+\.)+[A-Za-z]{2,}");

  static bool isValidEmail(String? email) {
    if (email == null) return false;
    return _emailReg.hasMatch(email);
  }

  /// Password policy: min 8 chars, at least one upper, one lower, one digit, one symbol
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'\d').hasMatch(password)) return false;
    // require at least one non-alphanumeric symbol
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) return false;
    return true;
  }

  static String passwordRequirements() =>
      'Password must be at least 8 characters and include uppercase, lowercase, a digit and a symbol.';
}
