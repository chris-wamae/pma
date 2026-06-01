import 'property_repository.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';
import '../models/property_rating_model.dart';
import '../models/property_issue_model.dart';

class LocalPropertyRepository implements PropertyRepository {
  final Map<String, PropertyModel> _store = {};
  final Map<String, List<UserModel>> _managersStore = {}; // propertyId -> list of managers
  final Map<String, UserModel> _usersStore = {}; // userId -> user (mock users)
  final Map<String, List<PropertyRatingModel>> _ratingsStore = {}; // propertyId -> list of ratings
  final Map<String, List<PropertyIssueModel>> _issuesStore = {}; // propertyId -> list of issues

  @override
  Future<PropertyModel> addProperty(PropertyModel property) async {
    _store[property.id] = property;
    return property;
  }

  @override
  Future<void> deleteProperty(String id) async {
    _store.remove(id);
    _managersStore.remove(id);
    _ratingsStore.remove(id);
    _issuesStore.remove(id);
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

  @override
  Future<List<PropertyRatingModel>> getRatingsForProperty(String propertyId) async {
    return _ratingsStore[propertyId] ?? [];
  }

  @override
  Future<List<PropertyIssueModel>> getPropertyIssues(String propertyId) async {
    return _issuesStore[propertyId] ?? [];
  }

  @override
  Future<void> updateIssueStatus(String issueId, String newStatus) async {
    for (final entry in _issuesStore.entries) {
      final idx = entry.value.indexWhere((i) => i.id == issueId);
      if (idx != -1) {
        final old = entry.value[idx];
        final updated = PropertyIssueModel(
          id: old.id,
          propertyId: old.propertyId,
          title: old.title,
          description: old.description,
          cost: old.cost,
          date: old.date,
          status: newStatus,
        );
        entry.value[idx] = updated;
        return;
      }
    }

    throw Exception('Issue with id $issueId not found');
  }
}
