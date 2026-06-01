import 'property_repository.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';

class LocalPropertyRepository implements PropertyRepository {
  final Map<String, PropertyModel> _store = {};
  final Map<String, List<UserModel>> _managersStore = {}; // propertyId -> list of managers
  final Map<String, UserModel> _usersStore = {}; // userId -> user (mock users)

  @override
  Future<PropertyModel> addProperty(PropertyModel property) async {
    _store[property.id] = property;
    return property;
  }

  @override
  Future<void> deleteProperty(String id) async {
    _store.remove(id);
    _managersStore.remove(id);
  }

  @override
  Future<List<PropertyModel>> listProperties(String ownerId) async {
    return _store.values.where((p) => p.ownerId == ownerId).toList();
  }

  @override
  Future<void> updateProperty(PropertyModel property) async {
    if (!_store.containsKey(property.id)) throw StateError('Property not found');
    _store[property.id] = property;
  }

  @override
  Future<List<UserModel>> getManagersForProperty(String propertyId) async {
    return _managersStore[propertyId] ?? [];
  }

  @override
  Future<void> addManagerToProperty(String propertyId, String managerEmail) async {
    // Find user by email in mock store
    final user = _usersStore.values.firstWhere(
      (u) => u.email == managerEmail,
      orElse: () => throw Exception('Manager with email $managerEmail not found.'),
    );

    // Check if manager is already assigned to any property
    bool alreadyAssigned = _managersStore.values.any((list) => list.any((u) => u.uid == user.uid));
    if (alreadyAssigned) {
      throw Exception('This manager is already managing another property.');
    }

    _managersStore.putIfAbsent(propertyId, () => []).add(user);
  }

  @override
  Future<void> removeManagerFromProperty(String propertyId, String managerId) async {
    final managers = _managersStore[propertyId];
    if (managers == null) throw Exception('No managers found for this property.');
    
    managers.removeWhere((u) => u.uid == managerId);
  }
}
