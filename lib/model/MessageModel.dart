import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MessageModel(
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'senderId': senderId, 'text': text, 'timestamp': timestamp};
  }
}
