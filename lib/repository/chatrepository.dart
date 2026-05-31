import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatStream(String collectionName) {
    return _firestore
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(
    String text,
    String senderId,
    String collectionName,
  ) async {
    await _firestore.collection(collectionName).add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
