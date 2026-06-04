import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pma/viewmodels/owner_property_viewmodel.dart';
import 'package:pma/repositories/property_repository.dart';
import 'package:pma/services/auth_service.dart';
import 'package:pma/models/property_model.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/tests/mocks.dart';

void main() {
  late OwnerPropertyViewModel ownerViewModel;
  late MockPropertyRepository mockPropertyRepository;
  late MockAuthService mockAuthService;

  setUp(() {
    mockPropertyRepository = MockPropertyRepository();
    mockAuthService = MockAuthService();
    ownerViewModel = OwnerPropertyViewModel(
      mockPropertyRepository,
      mockAuthService,
    );
  });

  group('OwnerPropertyViewModel - loadProperties', () {
    final user = UserModel(uid: 'owner123', email: 'owner@test.com', name: 'Owner', role: 'Owner');
    final properties = [
      PropertyModel(id: 'p1', ownerId: 'owner123', name: 'Property 1', address: 'Addr 1', units: 5),
      PropertyModel(id: 'p2', ownerId: 'owner123', name: 'Property 2', address: 'Addr 2', units: 10),
    ];

    test('should update properties list when loadProperties is successful', () async {
      // Arrange
      when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => user);
      when(() => mockPropertyRepository.listProperties(user.uid)).thenAnswer((_) async => properties);

      // Act
      await ownerViewModel.loadProperties();

      // Assert
      expect(ownerViewModel.properties, equals(properties));
      expect(ownerViewModel.isLoading, isFalse);
      expect(ownerViewModel.error, isNull);
    });

    test('should set error when user is not authenticated', () async {
      // Arrange
      when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => null);

      // Act
      await ownerViewModel.loadProperties();

      // Assert
      expect(ownerViewModel.properties, isEmpty);
      expect(ownerViewModel.error, contains('User not authenticated'));
      expect(ownerViewModel.isLoading, isFalse);
    });

    test('should set error when repository throws an exception', () async {
      // Arrange
      when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => user);
      when(() => mockPropertyRepository.listProperties(user.uid))
          .thenThrow(Exception('Database error'));

      // Act
      await ownerViewModel.loadProperties();

      // Assert
      expect(ownerViewModel.error, contains('Exception: Database error'));
      expect(ownerViewModel.isLoading, isFalse);
    });
  });

  group('OwnerPropertyViewModel - addProperty', () {
    final user = UserModel(uid: 'owner123', email: 'owner@test.com', name: 'Owner', role: 'Owner');
    final property = PropertyModel(id: 'p3', ownerId: 'owner123', name: 'New Property', address: 'New Addr', units: 2);

    test('should add property to list when addProperty is successful', () async {
      // Arrange
      when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => user);
      when(() => mockPropertyRepository.addProperty(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as PropertyModel);

      // Act
      final result = await ownerViewModel.addProperty(property);

      // Assert
      expect(result, isTrue);
      expect(ownerViewModel.properties.length, 1);
      expect(ownerViewModel.properties.first.ownerId, equals(user.uid));
      verify(() => mockPropertyRepository.addProperty(any())).called(1);
    });

    test('should return false and set error when addProperty fails', () async {
      // Arrange
      when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => user);
      when(() => mockPropertyRepository.addProperty(any())).thenThrow(Exception('Failed to add'));

      // Act
      final result = await ownerViewModel.addProperty(property);

      // Assert
      expect(result, isFalse);
      expect(ownerViewModel.error, contains('Exception: Failed to add'));
    });
  });

  group('OwnerPropertyViewModel - removeProperty', () {
    final property = PropertyModel(id: 'p1', ownerId: 'owner123', name: 'Property 1', address: 'Addr 1', units: 5);

    test('should remove property from list when removeProperty is successful', () async {
      // Arrange
      ownerViewModel.properties = [property];
      when(() => mockPropertyRepository.deleteProperty('p1')).thenAnswer((_) async => {});

      // Act
      final result = await ownerViewModel.removeProperty('p1');

      // Assert
      expect(result, isTrue);
      expect(ownerViewModel.properties, isEmpty);
      verify(() => mockPropertyRepository.deleteProperty('p1')).called(1);
    });

    test('should return false and set error when removeProperty fails', () async {
      // Arrange
      ownerViewModel.properties = [property];
      when(() => mockPropertyRepository.deleteProperty('p1')).thenThrow(Exception('Delete failed'));

      // Act
      final result = await ownerViewModel.removeProperty('p1');

      // Assert
      expect(result, isFalse);
      expect(ownerViewModel.error, contains('Exception: Delete failed'));
    });
  });

  group('OwnerPropertyViewModel - updateProperty', () {
    final property = PropertyModel(id: 'p1', ownerId: 'owner123', name: 'Property 1', address: 'Addr 1', units: 5);
    final updatedProperty = PropertyModel(id: 'p1', ownerId: 'owner123', name: 'Updated Name', address: 'Addr 1', units: 5);

    test('should update property in list when updateProperty is successful', () async {
      // Arrange
      ownerViewModel.properties = [property];
      when(() => mockPropertyRepository.updateProperty(any())).thenAnswer((_) async => {});

      // Act
      final result = await ownerViewModel.updateProperty(updatedProperty);

      // Assert
      expect(result, isTrue);
      expect(ownerViewModel.properties.first.name, equals('Updated Name'));
      verify(() => mockPropertyRepository.updateProperty(any())).called(1);
    });

    test('should return false and set error when updateProperty fails', () async {
      // Arrange
      ownerViewModel.properties = [property];
      when(() => mockPropertyRepository.updateProperty(any())).thenThrow(Exception('Update failed'));

      // Act
      final result = await ownerViewModel.updateProperty(updatedProperty);

      // Assert
      expect(result, isFalse);
      expect(ownerViewModel.error, contains('Exception: Update failed'));
    });
  });
}
