import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/login_response_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthService(){
    _auth.authStateChanges().listen(authStateChangeStreamListener);
  }

  Future<LoginResponse> loginWithPhoneNumber(String phoneNumber) async {
    final Completer<LoginResponse> completer = Completer<LoginResponse>();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final cred = await _auth.signInWithCredential(credential);
            _user = cred.user;

            if (!completer.isCompleted) {
              completer.complete(LoginResponse(
                status: 'success',
                message: 'Auto sign-in successful',
              ));
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.complete(LoginResponse(
                status: 'failed',
                message: 'Auto sign-in failed: ${e.toString()}',
              ));
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.complete(LoginResponse(
              status: 'failed',
              message: e.message ?? 'Verification failed',
            ));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(LoginResponse(
              status: 'success',
              message: 'Code sent successfully',
              verificationId: verificationId,
            ));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(LoginResponse(
              status: 'timeout',
              message: 'Code auto-retrieval timed out',
              verificationId: verificationId,
            ));
          }
        },
      );
      return completer.future;
    } catch (e) {
      return LoginResponse(
        status: 'failed',
        message: 'Error occurred: ${e.toString()}',
      );
    }
  }

  Future<LoginResponse> verifyOtp(String verificationId, String otp) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      return LoginResponse(
        status: 'success',
        message: 'Verification successful',
      );
    } catch (e) {
      return LoginResponse(
        status: 'failed',
        message: 'Invalid OTP, please try again. Error: ${e.toString()}',
      );
    }
  }

  void authStateChangeStreamListener(User? user) {
    if (user != null) {
      _user = user;
    }else{
      _user = null;
    }
  }
}
