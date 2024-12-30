import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String username;
  final String userAvatar;
  final String teamLogo;
  final String teamName;
  final int userLevel;
  final String postText;
  final String? postImage;
  final Timestamp postedAt;
  final int likes;
  final int comments;
  final int shares;

  PostModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.teamLogo,
    required this.teamName,
    required this.userLevel,
    required this.postText,
    this.postImage,
    required this.postedAt,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      username: data['username'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      teamLogo: data['teamLogo'] ?? '',
      teamName: data['teamName'] ?? '',
      userLevel: data['userLevel'] ?? 0,
      postText: data['postText'] ?? '',
      postImage: data['postImage'],
      postedAt: data['postedAt'] ?? Timestamp.now(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      shares: data['shares'] ?? 0,
    );
  }

  // Factory method to create a PostModel object from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      teamLogo: json['teamLogo'] ?? '',
      teamName: json['teamName'] ?? '',
      userLevel: json['userLevel'] ?? 0,
      postText: json['postText'] ?? '',
      postImage: json['postImage'],
      postedAt: json['postedAt'] ?? Timestamp.now(),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userAvatar': userAvatar,
      'teamLogo': teamLogo,
      'teamName': teamName,
      'userLevel': userLevel,
      'postText': postText,
      'postImage': postImage,
      'postedAt': postedAt, // Uses Firestore Timestamp
      'likes': likes,
      'comments': comments,
      'shares': shares,
    };
  }
}
