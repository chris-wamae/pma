import 'auth_service.dart';
import 'email_service.dart';

/// Simple service locator for dev: exposes global implementations for services used in local development.
final EmailService emailService = EmailService();
final AuthService authService = AuthService(emailService);
