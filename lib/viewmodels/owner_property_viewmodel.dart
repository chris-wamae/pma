import 'package:flutter/material.dart';
import '../models/property_model.dart';
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

  OwnerPropertyViewModel([PropertyRepository? repo, AuthService? authSvc]) 
      : _repo = repo ?? LocalPropertyRepository(), 
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
}
