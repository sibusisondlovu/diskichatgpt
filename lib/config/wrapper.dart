import 'package:diskigpt/views/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  static const String id = 'wrapper';

  @override
  State<Wrapper> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<Wrapper> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}