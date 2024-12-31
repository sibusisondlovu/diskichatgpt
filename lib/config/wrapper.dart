import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/register_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  static const String id = 'wrapper';

  @override
  State<Wrapper> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is authenticated
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen(); // User is authenticated
        } else {
          return const RegisterScreen(); // User is not authenticated
        }
      },
    );
  }
}
