import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId; // 發送者的 ID (租客或管理員)
  final String text; // 訊息內容
  final DateTime timestamp; // 發送時間

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  // 以後從 Firebase 拿資料時會用到這個「轉換器」
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MessageModel(
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // 以後要把訊息傳到 Firebase 時會用到這個
  Map<String, dynamic> toMap() {
    return {'senderId': senderId, 'text': text, 'timestamp': timestamp};
  }
}
