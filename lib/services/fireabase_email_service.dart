import 'email_service.dart';

class FirebaseEmailService implements EmailService {
  /// Firebase Auth handles the actual sending of OTPs (via verification links) 
  /// and password reset emails. This service becomes a thin wrapper or 
  /// can be used for custom transactional emails via a Cloud Function.
  
  @override
  Future<bool> sendOtpEmail(String email, String code) async {
    // For standard Firebase Auth, this is handled by sendEmailVerification()
    // in the AuthService.
    return true; 
  }

  @override
  Future<bool> sendPasswordResetEmail(String email, String resetToken) async {
    // For standard Firebase Auth, this is handled by sendPasswordResetEmail()
    // in the AuthService.
    return true;
  }
}
