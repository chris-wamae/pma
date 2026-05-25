abstract class EmailService {
  /// Send an OTP code to the given email. Returns true if queued/sent.
  Future<bool> sendOtpEmail(String email, String code);

  /// Send a password reset email containing a time-limited token/link.
  Future<bool> sendPasswordResetEmail(String email, String resetToken);
}
