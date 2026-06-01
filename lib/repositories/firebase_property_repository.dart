import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_repository.dart';
import '../models/property_model.dart';

class FirebasePropertyRepository implements PropertyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'properties';

  @override
  Future<PropertyModel> addProperty(PropertyModel property) async {
    try {
      await _firestore.collection(_collection).doc(property.id).set(property.toJson());
      return property;
    } catch (e) {
      throw Exception('Failed to add property to Firebase: $e');
    }
  }

  @override
  Future<List<PropertyModel>> listProperties(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .get();
      return snapshot.docs
          .map((doc) => PropertyModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch properties for owner $ownerId from Firebase: $e');
    }
  }

  @override
  Future<void> updateProperty(PropertyModel property) async {
    try {
      await _firestore.collection(_collection).doc(property.id).update(property.toJson());
    } catch (e) {
      throw Exception('Failed to update property in Firebase: $e');
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete property from Firebase: $e');
    }
  }
}
