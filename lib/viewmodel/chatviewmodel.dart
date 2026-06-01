import 'package:flutter/material.dart';
import '../repository/chatrepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();

  // The ID of the current chat room/conversation
  String currentChatId = 'general_chat';

  // Stream for messages in the current chat room
  Stream<QuerySnapshot> get messagesStream =>
      _repository.getChatStream(currentChatId);

  // Stream for the current user's active conversations
  Stream<QuerySnapshot> get conversationsStream {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null 
        ? _repository.getConversations(uid) 
        : const Stream.empty();
  }

  /// Changes the active chat room and notifies listeners to refresh the stream.
  void setChatRoom(String chatId) {
    if (currentChatId == chatId) return;
    currentChatId = chatId;
    notifyListeners();
  }

  /// Starts a new chat by looking up a user's email.
  Future<String?> startChatByEmail(String email) async {
    if (email.trim().isEmpty) return null;

    final String? myUid = FirebaseAuth.instance.currentUser?.uid;
    if (myUid == null) return null;

    try {
      // 1. Lookup user by email
      final UserModel? targetUser = await _repository.getUserByEmail(email);
      if (targetUser == null) {
        print("ViewModel: User with email $email not found.");
        return null;
      }

      if (targetUser.uid == myUid) {
        print("ViewModel: Cannot start a chat with yourself.");
        return null;
      }

      // 2. Check if conversation already exists or create a new one
      final String chatId = _repository.getChatIdForUsers(myUid, targetUser.uid);

      // Create a simple UserModel for the current user to initialize the conversation record
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final currentUserName = "Me"; // In a real app, this would come from the current user's profile

      await _repository.createConversation(
        UserModel(uid: currentUserId, email: '', name: currentUserName), 
        targetUser
      );

      return chatId;
    } catch (e) {
      print("ViewModel: Error starting chat: $e");
      return null;
    }
  }

  Future<void> sendNewMessage(String text) async {
    if (text.trim().isEmpty) return;

    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("ViewModel: No authenticated user found. Cannot send message.");
      return;
    }

    try {
      await _repository.sendMessage(text, userId, currentChatId);
      notifyListeners();
    } catch (e) {
      print("ViewModel: Message send failed! -> $e");
    }
  }

  /// Helper to get the name of the other participant in a conversation.
  String getOtherParticipantName(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<String> participants = data['participants'] as List<String>;
    final Map<String, String> names = data['participantNames'] as Map<String, String>;
    final String? myUid = FirebaseAuth.instance.currentUser?.uid;

    if (myUid == null) return "Unknown";

    // Find the UID that isn't mine
    final String otherUid = participants.firstWhere(
      (id) => id != myUid, 
      orElse: () => ""
    );

    return names[otherUid] ?? "Unknown User";
  }
}

