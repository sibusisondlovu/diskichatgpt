import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diskigpt/config/theme.dart';
import 'package:diskigpt/views/widgets/app_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/post_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String id = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? liveMatchData;
  late final Stream<QuerySnapshot> _postsStream;

  @override
  void initState() {
    super.initState();
    _fetchLiveMatch();
    _postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> _fetchLiveMatch() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('fixtures')
         // .orderBy('timestamp') // Assumes you want the earliest match by timestamp
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          liveMatchData = querySnapshot.docs.first.data();
        });
      }
    } catch (e) {
      print('Error fetching live match: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DiskiAppBar(userName: '@conniemental'),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Text(
            'Live Match',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildLiveMatchCard(),
          const SizedBox(height: 24),
          _buildLatestNewsSection(),
        ],
      ),
    );
  }

  Widget _buildLiveMatchCard() {
    if (liveMatchData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final teams = liveMatchData!['teams'] as Map<String, dynamic>;
    final homeTeam = teams['home'] as Map<String, dynamic>;
    final awayTeam = teams['away'] as Map<String, dynamic>;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppTheme.secondaryColor, AppTheme.mainColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Teams Container
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Left Team
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            homeTeam['logo'],
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            homeTeam['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // VS Text
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Right Team
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            awayTeam['logo'],
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            awayTeam['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'matchDetailScreen', arguments: liveMatchData);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.ascentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Banter Room',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Live Badge
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // Watch Now Button
        ],
      ),
    );
  }

  Widget _buildLatestNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Siyagobhoza',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: _postsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching posts: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No posts yet.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Be the first to create a post!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final posts = snapshot.data!.docs.map((doc) {
              final data = doc.data();
              if (data != null && data is Map<String, dynamic>) {
                try {
                  return DiskiPostCard.fromDocumentSnapshot(doc);
                } catch (e) {
                  if (kDebugMode) {
                    print('Error parsing document: $e');
                  }
                  return null; // Filter out invalid posts
                }
              } else {
                if (kDebugMode) {
                  print('Error: Unexpected data format in Firestore document');
                }
                return null; // Filter out invalid posts
              }
            }).whereType<DiskiPostCard>().toList(); // Ensure valid types only

            if (posts.isEmpty) {
              return const Center(
                child: Text(
                  'No valid posts available.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return posts[index];
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, 'createPostScreen'); // Replace with your route name
          },
          icon: const Icon(Icons.add),
          label: const Text('Create Post'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50), // Stretch button across width
          ),
        ),
      ],
    );
  }
}
