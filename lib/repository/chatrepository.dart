import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(
    String text,
    String senderId,
    String chatId,
  ) async {
    // 1. Add the message to the messages sub-collection
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Update the conversation metadata for the list view
    await updateConversationMetadata(chatId, text);
  }

  Future<void> updateConversationMetadata(String chatId, String text) async {
    await _firestore.collection('conversations').doc(chatId).set({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return UserModel.fromJson(query.docs.first.data());
  }

  Stream<QuerySnapshot> getConversations(String uid) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('lastTimestamp', descending: true)
        .snapshots();
  }

  Future<void> createConversation(UserModel user1, UserModel user2) async {
    final String chatId = _generateChatId(user1.uid, user2.uid);

    await _firestore.collection('conversations').doc(chatId).set({
      'participants': [user1.uid, user2.uid],
      'participantNames': {
        user1.uid: user1.name ?? 'User ${user1.uid.substring(0, 4)}',
        user2.uid: user2.name ?? 'User ${user2.uid.substring(0, 4)}',
      },
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  String _generateChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join('_');
  }

  String getChatIdForUsers(String uid1, String uid2) {
    return _generateChatId(uid1, uid2);
  }
}
