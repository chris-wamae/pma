import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_repository.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';
import '../models/property_rating_model.dart';
import '../models/property_issue_model.dart';

class FirebasePropertyRepository implements PropertyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'properties';
  final String _managersCollection = 'property_managers';
  final String _usersCollection = 'users';
  final String _ratingsCollection = 'property_ratings';
  final String _issuesCollection = 'owner_property_issues';

  @override
  Future<PropertyModel> addProperty(PropertyModel property) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(property.id)
          .set(property.toJson());
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
      throw Exception(
        'Failed to fetch properties for owner $ownerId from Firebase: $e',
      );
    }
  }

  @override
  Future<void> updateProperty(PropertyModel property) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(property.id)
          .update(property.toJson());
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

  @override
  Future<List<UserModel>> getManagersForProperty(String propertyId) async {
    try {
      final managerSnapshot = await _firestore
          .collection(_managersCollection)
          .where('propertyId', isEqualTo: propertyId)
          .get();

      final List<UserModel> managers = [];
      for (var doc in managerSnapshot.docs) {
        final managerId = doc.data()['managerId'];
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(managerId)
            .get();
        if (userDoc.exists) {
          managers.add(UserModel.fromJson(userDoc.data()!));
        }
      }
      return managers;
    } catch (e) {
      throw Exception('Failed to fetch managers for property $propertyId: $e');
    }
  }

  @override
  Future<void> addManagerToProperty(
    String propertyId,
    String managerEmail,
  ) async {
    try {
      // 1. Find user by email
      final userSnapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: managerEmail)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception('Manager with email $managerEmail not found.');
      }

      final managerId = userSnapshot.docs.first.id;

      // 2. Check if manager is already assigned to any property
      final existingAssignment = await _firestore
          .collection(_managersCollection)
          .where('managerId', isEqualTo: managerId)
          .get();

      if (existingAssignment.docs.isNotEmpty) {
        throw Exception('This manager is already managing another property.');
      }

      // 3. Add manager to property
      await _firestore.collection(_managersCollection).add({
        'managerId': managerId,
        'propertyId': propertyId,
      });
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> removeManagerFromProperty(
    String propertyId,
    String managerId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_managersCollection)
          .where('propertyId', isEqualTo: propertyId)
          .where('managerId', isEqualTo: managerId)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Manager assignment not found.');
      }

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove manager from property: $e');
    }
  }

  @override
  Future<List<PropertyRatingModel>> getRatingsForProperty(
    String propertyId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_ratingsCollection)
          .where('propertyId', isEqualTo: propertyId)
          .get();

      return snapshot.docs
          .map((doc) => PropertyRatingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch ratings for property $propertyId: $e');
    }
  }

  @override
  Future<List<PropertyIssueModel>> getPropertyIssues(String propertyId) async {
    try {
      final snapshot = await _firestore
          .collection(_issuesCollection)
          .where('propertyId', isEqualTo: propertyId)
          .get();

      return snapshot.docs
          .map((doc) => PropertyIssueModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch issues for property $propertyId: $e');
    }
  }

  @override
  Future<void> updateIssueStatus(String issueId, String newStatus) async {
    try {
      await _firestore.collection(_issuesCollection).doc(issueId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Failed to update issue status: $e');
    }
  }
}
