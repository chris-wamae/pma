import 'package:pma/services/fireabase_email_service.dart';
import 'auth_service.dart';
import 'firebase_auth_service.dart';
import 'email_service.dart';
import '../repositories/property_repository.dart';
import '../repositories/firebase_property_repository.dart';


/// Simple service locator for dev: exposes global implementations for services used in local development.
final EmailService emailService = FirebaseEmailService();
final AuthService authService = FirebaseAuthService();
final PropertyRepository propertyRepository = FirebasePropertyRepository();
