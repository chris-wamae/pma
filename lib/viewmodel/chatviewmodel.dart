import 'package:flutter/material.dart';
import '../repository/chatrepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();

  // 增加一个变量来存储当前的频道名称
  String chatTarget = 'manager_chats';

  // 修改 Stream：调用 Repository 时传入当前的频道名称
  Stream<QuerySnapshot> get messagesStream =>
      _repository.getChatStream(chatTarget);

  Future<void> sendNewMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      // 发送时也传入当前频道
      await _repository.sendMessage(text, 'tenant_user', chatTarget);
      print("ViewModel: Message sent successfully to $chatTarget!");
      notifyListeners();
    } catch (e) {
      print("ViewModel: Message send failed! -> $e");
    }
  }
}
