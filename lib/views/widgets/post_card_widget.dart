import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiskiPostCard extends StatelessWidget {
  final String postId;
  final String username;
  final String userAvatar;
  final String teamLogo;
  final String teamName;
  final int userLevel;
  final String postText;
  final String? postImage;
  final String timeAgo;
  final int likes;
  final int comments;
  final int shares;

  const DiskiPostCard({
    super.key,
    required this.postId,
    required this.username,
    required this.userAvatar,
    required this.teamLogo,
    required this.teamName,
    required this.userLevel,
    required this.postText,
    this.postImage,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, 'postDetailsPage', arguments: postId);
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(),
            _buildPostContent(),
            _buildPostActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(userAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and Level Badge
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.military_tech,
                            size: 14,
                            color: Colors.purple[700],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            userLevel.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Team Info
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        teamLogo,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      teamName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $timeAgo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Text

        if (postImage != null) ...[
          const SizedBox(height: 8),
          // Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              postImage!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            postText,
            style: const TextStyle(fontSize: 12),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(Icons.chat_bubble_outline, comments),
         // _buildActionButton(Icons.repeat, shares),
          _buildActionButton(Icons.favorite_border, likes),
        //  _buildActionButton(Icons.share_outlined, null),
        ],
      ),
    );
  }

  static DiskiPostCard fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAt = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : null;

    return DiskiPostCard(
      postId: data['postId'],
      username: data['username'] ?? 'Guest', // Provide default values to avoid null errors
      userAvatar: data['userAvatar'] ?? '',
      teamLogo: data['teamLogo'] ?? Strings.defaultTeamLogo,
      teamName: data['teamName'] ?? 'Diskichat FC',
      userLevel: data['userLevel'] ?? 0,
      postText: data['postText'] ?? '',
      postImage: data['postImage'],
      timeAgo: createdAt != null ? timeago.format(createdAt) : 'Just now',
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      shares: data['shares'] ?? 0,
    );
  }

  Widget _buildActionButton(IconData icon, int? count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        if (count != null) ...[
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}