import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Chat"),
        backgroundColor: const Color(0xFF0A4E9A),
      ),
      body: Column(
        children: [
          // 聊天訊息區域
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChatBubble(
                  "Hello! I have a question about my utility bill.",
                  true,
                ),
                _buildChatBubble(
                  "Sure, let me check that for you. Which month?",
                  false,
                ),
                _buildChatBubble(
                  "It's for the May invoice. The RM 250 one.",
                  true,
                ),
              ],
            ),
          ),

          // 底部輸入框
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.photo), onPressed: () {}),
                Expanded(
                  child: TextField(
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 聊天氣泡組件 (帶頭像升級版)
  Widget _buildChatBubble(String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end, // 讓頭像對齊氣泡底部
        children: [
          // 1. 如果是管理員發的，左邊顯示頭像
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

          // 2. 氣泡本體
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

          // 3. 如果是租客(我)發的，右邊可以顯示自己的小圖標（選填）
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
} // 這是 class 的結束括號，一定要有！
