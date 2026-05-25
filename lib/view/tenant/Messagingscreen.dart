import 'package:flutter/material.dart';
import '../../models/MessageModel.dart';

class MessagingScreen extends StatefulWidget {
  // 從 StatelessWidget 改成 StatefulWidget
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  // 1. 定義控制器，用來拿輸入框的字
  final TextEditingController _controller = TextEditingController();

  // 2. 把 dummyMessages 搬進 State，這樣它才能被修改
  final List<MessageModel> _messages = [
    MessageModel(
      senderId: 'admin',
      text: "Hello! I have a question about my utility bill.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    MessageModel(
      senderId: 'tenant',
      text: "Sure, let me check that for you. Which month?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  // 3. 發送訊息的邏輯
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return; // 如果沒打字，不准發送

    setState(() {
      _messages.add(
        MessageModel(
          senderId: 'tenant',
          text: _controller.text,
          timestamp: DateTime.now(),
        ),
      );
    });
    _controller.clear(); // 發完後清空輸入框
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Manager Chat"),
        backgroundColor: const Color(0xFF0A4E9A),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length, // 使用 _messages 列表
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg.text, msg.senderId == 'tenant');
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.photo), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _controller, // 綁定控制器
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF0A4E9A)),
                  onPressed: _sendMessage, // 點擊呼叫發送邏輯
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF0A4E9A) : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isMe ? 15 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
          if (isMe)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
