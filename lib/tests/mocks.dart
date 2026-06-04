import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma/repositories/auth_repository.dart';
import 'package:pma/repositories/property_repository.dart';
import 'package:pma/services/auth_service.dart';

// Mocks for Firebase Services
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

// Mocks for App Repositories and Services
class MockAuthRepository extends Mock implements AuthRepository {}
class MockPropertyRepository extends Mock implements PropertyRepository {}
class MockAuthService extends Mock implements AuthService {}
