import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../widgets/custom_button_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const String id = "userProfileScreen";

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String teamLogo = Strings.defaultProfileImage;
  String teamName = 'No Team Selected';
  int userPoints = 0;
  String userBadge = 'Bronze';
  String userLevel = 'Beginner';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            teamLogo = userData['teamLogo'] ?? Strings.defaultProfileImage;
            teamName = userData['teamName'] ?? 'No Team Selected';
            userPoints = userData['points'] ?? 0;
            userBadge = userData['badge'] ?? 'Bronze';
            userLevel = userData['level'] ?? 'Beginner';
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  void _inviteFriends() {
    Share.share(
        'Join me on this amazing app! Download it now: https://play.google.com/store/apps/details?id=com.example.app');
  }

  void _rateApp() {
    // Replace this URL with your app's Google Play Store link
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.example.app';
    Share.share('Rate our app on Google Play: $playStoreUrl');
  }

  void _editTeam() {
    // Navigate to a screen where the user can edit their team
    Navigator.pushNamed(context, 'editTeamScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Photo
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? Strings.defaultProfileImage),
              ),
            ),
            const SizedBox(height: 20),
            // Username
            Text(
              FirebaseAuth.instance.currentUser?.displayName ?? 'Guest',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // User Details
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                leading: Image.network(teamLogo, width: 50, height: 50),
                title: Text(teamName, style: const TextStyle(fontSize: 14),),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editTeam,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.star, color: AppTheme.secondaryColor, size: 40),
                title: const Text('Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                subtitle: Text(userLevel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                trailing: Text(
                  '$userPoints Points',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Invite Friends Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomElevatedButton(
                onPressed: _inviteFriends,
                text: 'Invite Friends',
              ),
            ),

            const SizedBox(height: 10),

            // Rate App Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomElevatedButton(
                onPressed: _rateApp,
                text: 'Rate App',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
