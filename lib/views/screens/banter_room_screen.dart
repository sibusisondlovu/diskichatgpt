import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BanterRoom extends StatefulWidget {
  final String roomId;

  const BanterRoom({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  static const String id = "banterRoomScreen";

  @override
  State<BanterRoom> createState() => _BanterRoomState();
}

class _BanterRoomState extends State<BanterRoom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  late Stream<QuerySnapshot> _messagesStream;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeRoom();
    _messagesStream = _firestore
        .collection('chat_rooms')
        .doc(widget.roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initializeRoom() async {
    final roomDoc = await _firestore.collection('chat_rooms').doc(widget.roomId).get();
    if (!roomDoc.exists) {
      await _firestore.collection('chat_rooms').doc(widget.roomId).set({
        'roomId': widget.roomId,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastMessageTime': null,
      });
    }
  }

  Future<void> _handleSendMessage() async {
    if (_auth.currentUser == null) {
      _showLoginRequired();
      return;
    }

    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(widget.roomId)
          .collection('messages')
          .add({
        'text': messageText,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser!.uid,
        'userName': _auth.currentUser!.displayName ?? 'Anonymous User',
        'userAvatar': _auth.currentUser!.photoURL ?? '',
      });

      await _firestore
          .collection('chat_rooms')
          .doc(widget.roomId)
          .update({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to login to send messages. You can continue viewing messages as a guest.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue as Guest'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'login_route');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    if (_auth.currentUser != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[200],
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Login to send messages',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'login_route'),
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.send),
            onPressed: _isLoading ? null : _handleSendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room ${widget.roomId}'),
        actions: [
          if (_auth.currentUser == null)
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, 'login_route'),
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Be the first to send a message!',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return ChatMessage(
                    text: data['text'] ?? '',
                    user: ChatUser(
                      id: data['userId'] ?? '',
                      firstName: data['userName'] ?? 'Anonymous',
                      profileImage: data['userAvatar'] ?? '',
                    ),
                    createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                  );
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.user.id == _auth.currentUser?.uid;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.user.firstName ?? 'Anonymous',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(message.text),
                              const SizedBox(height: 4),
                              Text(
                                message.createdAt.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}