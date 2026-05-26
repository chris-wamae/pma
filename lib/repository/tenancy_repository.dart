import 'package:cloud_firestore/cloud_firestore.dart';

class TenancyRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> acceptTenancy(String propertyId, String tenantId) async {
    await firestore.collection("tenancies").doc(propertyId).set({
      "propertyId": propertyId,
      "tenantId": tenantId,
      "status": "Accepted",
    });
  }
}
