import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyRatingRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRating({
    required String propertyId,
    required String tenantId,
    required int rating,
    required String comment,
  }) async {
    await firestore.collection("ratings").add({
      "propertyId": propertyId,
      "tenantId": tenantId,
      "rating": rating,
      "comment": comment,
      "createdAt": Timestamp.now(),
    });
  }
}
