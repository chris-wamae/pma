import 'package:flutter/material.dart';
import '../../viewmodel/chatviewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessagingScreen extends StatefulWidget {
  // 1. 修正：这里必须要求传入 chatTarget
  final String chatTarget;
  const MessagingScreen({super.key, required this.chatTarget});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatViewModel _viewModel = ChatViewModel();

  @override
  void initState() {
    super.initState();
    // 2. 关键：页面初始化时，告诉 ViewModel 现在的房间名是什么
    // 注意：这里的 chatTarget 必须和你 ViewModel 里的变量名大小写一致
    _viewModel.chatTarget = widget.chatTarget;
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    _viewModel.sendNewMessage(_controller.text);
    _controller.clear();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "...";
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // 3. 动态设置标题
    String appBarTitle = widget.chatTarget == 'manager_chats'
        ? "Manager Chat"
        : "Owner Chat";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A4E9A),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _viewModel.messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Connection Error"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final bool isMe = data['senderId'] == 'tenant_user';
                    final String timeStr = _formatTimestamp(
                      data['timestamp'] as Timestamp?,
                    );

                    return _buildChatBubble(data['text'] ?? '', isMe, timeStr);
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF0F2F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                backgroundColor: Color(0xFF0A4E9A),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) _buildAvatar(isMe),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF0A4E9A) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isMe) _buildAvatar(isMe),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isMe ? 0 : 48,
              right: isMe ? 48 : 0,
            ),
            child: Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isMe) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isMe ? const Color(0xFF4A90E2) : Colors.grey[400],
      child: Icon(
        isMe ? Icons.person : Icons.support_agent,
        size: 18,
        color: Colors.white,
      ),
    );
  }
}
