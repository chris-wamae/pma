import 'package:flutter/material.dart';
import '../../viewmodel/chatviewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Messagingscreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _emailController = TextEditingController();
  final ChatViewModel _viewModel = ChatViewModel();

  void _startNewChat() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final String? chatId = await _viewModel.startChatByEmail(email);
    if (chatId != null) {
      _emailController.clear();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagingScreen(chatTarget: chatId),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found or error starting chat")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4E9A),
        elevation: 0,
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _viewModel.conversationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading chats"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No active conversations"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final String chatId = doc.id;
                    final String name = _viewModel.getOtherParticipantName(doc);
                    final String lastMsg = data['lastMessage'] ?? 'No messages yet';
                    final Timestamp? time = data['lastTimestamp'] as Timestamp?;

                    return _buildChatTile(name, lastMsg, time, chatId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter email to start chat...",
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
            onTap: _startNewChat,
            child: const CircleAvatar(
              backgroundColor: Color(0xFF0A4E9A),
              child: Icon(Icons.chat, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(String name, String msg, Timestamp? time, String chatId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF0A4E9A).withOpacity(0.1),
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF0A4E9A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          msg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: time != null
            ? Text(
                _formatTime(time),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagingScreen(chatTarget: chatId),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    return "${date.day}/${date.month}";
  }
}
