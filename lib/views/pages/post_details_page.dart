import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;
  static const String id = 'postDetailsPage';
  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Post not found.'));
          }

          final post = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              // Post Details
              _buildPostCard(post),

              // Comments Section
              Expanded(
                child: _buildCommentsSection(postId, currentUser),
              ),

              // Add Comment Input
              _buildCommentInput(postId, 'currentUser'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post['userAvatar']),
            ),
            title: Text(post['username']),
            subtitle: Text(post['createdAt'].toDate().toString()), // Format as needed
          ),

          if (post['postImage'] != null)
            Image.network(
              post['postImage'],
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          if (post['postText'] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post['postText']),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  // Like functionality (not implemented here)
                },
              ),
              Text('${post['likes']} Likes'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Share functionality (not implemented here)
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(String postId, User? currentUser) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No comments yet. Be the first to comment!'));
        }

        final messages = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ChatMessage(
            user: ChatUser(
              id: data['userId'],
              firstName: data['username'],
              profileImage: data['userAvatar'],
            ),
            text: data['commentText'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

        return DashChat(
          currentUser: ChatUser(
            id: currentUser?.uid ?? 'guest',
            firstName: currentUser?.displayName ?? 'Guest',
            profileImage: currentUser?.photoURL ??
                'https://jaspahost.co.za/assets/diskichat-default-avatar.png',
          ),
          messages: messages, onSend: (ChatMessage message) {  },
        );
      },
    );
  }

  Widget _buildCommentInput(String postId, currentUser) {
    final TextEditingController commentController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(
                fontSize: 12,
              ),
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final commentText = commentController.text.trim();
              if (commentText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .collection('comments')
                    .add({
                  'userId': currentUser.uid,
                  'username': currentUser.displayName ?? 'Guest',
                  'userAvatar': currentUser.photoURL ??
                      'https://jaspahost.co.za/assets/diskichat-default-avatar.png',
                  'commentText': commentText,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
