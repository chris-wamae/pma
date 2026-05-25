import '../models/property_model.dart';

abstract class PropertyRepository {
  Future<PropertyModel> addProperty(PropertyModel property);
  Future<List<PropertyModel>> listProperties();
  Future<void> updateProperty(PropertyModel property);
  Future<void> deleteProperty(String id);
}
