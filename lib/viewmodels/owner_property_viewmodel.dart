import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';
import '../repositories/property_repository.dart';
import '../repositories/local_property_repository.dart';
import '../services/auth_service.dart';
import '../services/service_locator.dart';

class OwnerPropertyViewModel extends ChangeNotifier {
  final PropertyRepository _repo;
  final AuthService _authService;
  List<PropertyModel> properties = [];
  bool isLoading = false;
  String? error;

  // State for property manager management
  List<UserModel> propertyManagers = [];
  bool isManagersLoading = false;
  String? managerError;

  OwnerPropertyViewModel([PropertyRepository? repo, AuthService? authSvc]) 
      : _repo = repo ?? propertyRepository, 
        _authService = authSvc ?? authService;

  Future<void> loadProperties() async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }
      properties = await _repo.listProperties(user.uid);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProperty(PropertyModel p) async {
    try {
      // Ensure the property has the correct ownerId before saving
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User not authenticated');
      
      final propertyWithOwner = PropertyModel(
        id: p.id,
        ownerId: user.uid,
        name: p.name,
        address: p.address,
        units: p.units,
        createdAt: p.createdAt,
      );

      await _repo.addProperty(propertyWithOwner);
      properties.add(propertyWithOwner);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  Future<bool> removeProperty(String id) async {
    try {
      await _repo.deleteProperty(id);
      properties.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  Future<bool> updateProperty(PropertyModel p) async {
    try {
      await _repo.updateProperty(p);
      final idx = properties.indexWhere((x) => x.id == p.id);
      if (idx != -1) properties[idx] = p;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  // --- Property Manager Management ---

  Future<void> loadManagersForProperty(String propertyId) async {
    isManagersLoading = true;
    managerError = null;
    notifyListeners();
    try {
      propertyManagers = await _repo.getManagersForProperty(propertyId);
    } catch (e) {
      managerError = e.toString();
    } finally {
      isManagersLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addManagerToProperty(String propertyId, String email) async {
    managerError = null;
    try {
      await _repo.addManagerToProperty(propertyId, email);
      await loadManagersForProperty(propertyId);
      return true;
    } catch (e) {
      managerError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeManagerFromProperty(String propertyId, String managerId) async {
    try {
      await _repo.removeManagerFromProperty(propertyId, managerId);
      await loadManagersForProperty(propertyId);
      return true;
    } catch (e) {
      managerError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
