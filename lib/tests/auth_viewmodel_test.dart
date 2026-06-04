import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pma/viewmodels/auth_viewmodel.dart';
import 'package:pma/repositories/auth_repository.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/tests/mocks.dart';

void main() {
  late AuthViewModel authViewModel;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authViewModel = AuthViewModel(mockAuthRepository);
  });

  group('AuthViewModel - signIn', () {
    final email = 'test@example.com';
    final password = 'Password123!';

    test('should return true and update user when signIn is successful', () async {
      // Arrange
      final tokens = {'accessToken': 'token123', 'refreshToken': 'refresh123'};
      final user = UserModel(
        uid: 'user123',
        email: email,
        name: 'Test User',
        role: 'Owner',
      );

      when(() => mockAuthRepository.signIn(email, password))
          .thenAnswer((_) async => tokens);
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => user);

      // Act
      final result = await authViewModel.signIn(email, password);

      // Assert
      expect(result, isTrue);
      expect(authViewModel.user, equals(user));
      expect(authViewModel.error, isNull);
    });

    test('should return false and set error when signIn fails (invalid credentials)', () async {
      // Arrange
      when(() => mockAuthRepository.signIn(email, password))
          .thenAnswer((_) async => null);

      // Act
      final result = await authViewModel.signIn(email, password);

      // Assert
      expect(result, isFalse);
      expect(authViewModel.error, equals('Invalid credentials'));
    });

    test('should return false when email is invalid', () async {
      // Arrange
      final invalidEmail = 'invalid-email';

      // Act
      final result = await authViewModel.signIn(invalidEmail, password);

      // Assert
      expect(result, isFalse);
      expect(authViewModel.error, contains('Invalid email address'));
      verifyNever(() => mockAuthRepository.signIn(any(), any()));
    });

    test('should return false when password is empty', () async {
      // Arrange
      final emptyPassword = '';

      // Act
      final result = await authViewModel.signIn(email, emptyPassword);

      // Assert
      expect(result, isFalse);
      expect(authViewModel.error, equals('Password cannot be empty'));
      verifyNever(() => mockAuthRepository.signIn(any(), any()));
    });
  });

  group('AuthViewModel - signUp', () {
    final email = 'new@example.com';
    final password = 'StrongPassword123!';

    test('should return true and update user when signUp is successful', () async {
      // Arrange
      final user = UserModel(
        uid: 'user456',
        email: email,
        name: 'New User',
        role: 'Owner',
      );

      when(() => mockAuthRepository.signUp(email, password, name: 'New User', role: 'Owner'))
          .thenAnswer((_) async => user);

      // Act
      final result = await authViewModel.signUp(email, password, name: 'New User');

      // Assert
      expect(result, isTrue);
      expect(authViewModel.user, equals(user));
    });

    test('should return false when password is not strong enough', () async {
      // Arrange
      final weakPassword = '123';

      // Act
      final result = await authViewModel.signUp(email, weakPassword);

      // Assert
      expect(result, isFalse);
      expect(authViewModel.error, isNotNull);
      verifyNever(() => mockAuthRepository.signUp(any(), any(), name: any(named: 'name'), role: any(named: 'role')));
    });
  });

  group('AuthViewModel - signOut', () {
    test('should clear user and notify listeners when signOut is successful', () async {
      // Arrange
      final user = UserModel(uid: 'user123', email: 'test@test.com', name: 'Test', role: 'Owner');
      authViewModel.user = user;
      when(() => mockAuthRepository.signOut(user.uid)).thenAnswer((_) async => {});

      // Act
      await authViewModel.signOut();

      // Assert
      expect(authViewModel.user, isNull);
      verify(() => mockAuthRepository.signOut(user.uid)).called(1);
    });
  });
}
