import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diskigpt/config/theme.dart';
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
        backgroundColor: AppTheme.darkColor,
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
                child: _buildCommentsSection(postId),
              ),

              // Add Comment Input
              _buildCommentInput(postId, currentUser),
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
            title: Text(
              post['username'],
              style: const TextStyle(fontSize: 12),
            ),
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
              child: Text(
                post['postText'],
                style: const TextStyle(fontSize: 12),
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  // Like functionality (not implemented here)
                },
              ),
              Text(
                '${post['likes']} Likes',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(String postId) {
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
          return const Center(
            child: Text('No comments yet. Be the first to comment!'),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(data['userAvatar']),
              ),
              title: Text(
                data['username'],
                style: const TextStyle(fontSize: 11),
              ),
              subtitle: Text(
                data['commentText'],
                style: const TextStyle(fontSize: 10),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCommentInput(String postId, User? currentUser) {
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
              if (commentText.isNotEmpty && currentUser != null) {
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
