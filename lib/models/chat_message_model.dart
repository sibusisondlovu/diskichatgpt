import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String senderId;
  String content;
  DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  // Factory constructor to create a ChatMessage from a Firestore document
  factory ChatMessage.fromFirestore(
      DocumentSnapshot document,
      SnapshotOptions? options,
      ) {
    final data = document.data() as Map<String, dynamic>;
    return ChatMessage(
      senderId: data['senderId'],
      content: data['content'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}