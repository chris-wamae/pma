import '../models/property_model.dart';
import '../models/user_model.dart';
import '../models/property_rating_model.dart';

abstract class PropertyRepository {
  Future<PropertyModel> addProperty(PropertyModel property);
  Future<List<PropertyModel>> listProperties(String ownerId);
  Future<void> updateProperty(PropertyModel property);
  Future<void> deleteProperty(String id);

  Future<List<UserModel>> getManagersForProperty(String propertyId);
  Future<void> addManagerToProperty(String propertyId, String managerEmail);
  Future<void> removeManagerFromProperty(String propertyId, String managerId);

  Future<List<PropertyRatingModel>> getRatingsForProperty(String propertyId);
}
