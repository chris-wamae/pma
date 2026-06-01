import 'property_repository.dart';
import '../models/property_model.dart';

class LocalPropertyRepository implements PropertyRepository {
  final Map<String, PropertyModel> _store = {};

  @override
  Future<PropertyModel> addProperty(PropertyModel property) async {
    _store[property.id] = property;
    return property;
  }

  @override
  Future<void> deleteProperty(String id) async {
    _store.remove(id);
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
}
