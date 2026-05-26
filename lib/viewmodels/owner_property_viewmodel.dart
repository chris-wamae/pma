import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../repositories/property_repository.dart';

class OwnerPropertyViewModel extends ChangeNotifier {
  final PropertyRepository _repo;
  List<PropertyModel> properties = [];
  bool isLoading = false;
  String? error;

  OwnerPropertyViewModel([PropertyRepository? repo]) : _repo = repo ?? PropertyRepository();

  Future<void> loadProperties() async {
    isLoading = true;
    notifyListeners();
    try {
      properties = await _repo.listProperties();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProperty(PropertyModel p) async {
    try {
      await _repo.addProperty(p);
      properties.add(p);
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
