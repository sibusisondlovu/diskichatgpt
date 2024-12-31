import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diskigpt/config/theme.dart';
import 'package:diskigpt/views/widgets/custom_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../config/constants.dart';
import '../../controllers/image_upload_service.dart';

class CreatePostScreen extends StatefulWidget {
  static const String id = 'createPostScreen';
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _mediaFile;
  final TextEditingController _captionController = TextEditingController();
  final picker = ImagePicker();
  VideoPlayerController? _videoPlayerController;
  bool _isUploading = false;

  Future<void> _pickMedia(ImageSource source) async {
    final pickedFile = await picker.pickMedia();
    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a media file')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final imageUrl = null;

      try {
        // Upload the file to Cloudinary
       // final imageUrl = await CloudinaryService.uploadImage(file!);
        User? user = FirebaseAuth.instance.currentUser;
        final postId = FirebaseFirestore.instance.collection('posts').doc().id;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        String teamLogo = userData?['teamLogo'] ?? '';
        String teamName = userData?['teamName'] ?? '';
        String userLevel = userData?['level'] ?? 'Beginner';

        await FirebaseFirestore.instance.collection('posts').doc(postId).set({
          'postId': postId,
          'userId': user?.uid ?? 'diskichat',
          'username': user?.displayName ?? 'Guest',
          'userAvatar': user?.photoURL ?? Strings.defaultProfileImage,
          'teamLogo':teamLogo,
          'teamName' :teamName,
          //'userLevel' : userLevel,
          'postText': _captionController.text,
          'postImage': imageUrl ?? Strings.defaultPostImage,
          'postVideo': imageUrl ?? Strings.defaultPostImage,
          'createdAt': FieldValue.serverTimestamp(),
          'likes': 0,
          'comments': 0,
          'shares': 0,
        });
        Navigator.pushReplacementNamed(context, 'homeScreen');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post submitted successfully!'),
            backgroundColor: Colors.lightGreen,
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print('An error has occurred $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit post: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }

      setState(() {
        _isUploading = false;
        _mediaFile = null;
        _captionController.clear();
        if (_videoPlayerController != null) {
          _videoPlayerController!.dispose();
          _videoPlayerController = null;
        }
      });
      Navigator.pop(context); // Return to previous screen

    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading post: $e')));
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppTheme.darkColor,
          title: const Text('Create Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Wrap(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Photo Library'),
                          onTap: () {
                            _pickMedia(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                          onTap: () {
                            _pickMedia(ImageSource.camera);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _mediaFile == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 50))
                    : _mediaFile!.path.endsWith('.mp4') && _videoPlayerController != null
                    ? AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                )
                    : Image.file(_mediaFile!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              maxLines: 3,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed: _isUploading ? null : _uploadPost,
              text: _isUploading
                  ? 'Posting...'
                  : 'Post',
            ),
          ],
        ),
      ),
    );
  }
}