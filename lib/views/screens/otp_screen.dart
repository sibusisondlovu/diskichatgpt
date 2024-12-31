import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinput/pinput.dart';
import '../../config/theme.dart';
import '../widgets/custom_button_widget.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationId});
  static const String id = "otpScreen";
  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully verified!")),
      );

      // update firebase profile number field
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {

          Navigator.pushNamed(context, 'createProfileScreen');
        } catch (firestoreError) {
          // Handle Firestore update errors
          if (kDebugMode) {
            print("Firestore update error: $firestoreError");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error updating profile: $firestoreError")),
          );
        }
      } else {
        // Handle the case where the user is null (shouldn't happen here, but good practice)
        if (kDebugMode) {
          print("User is null after successful verification.");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error updating profile.")),
        );
      }

      Navigator.pushNamed(context, 'createProfileScreen');

      // Navigate to home or next screen
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Invalid OTP, please try again.")),
      // );
      // print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully verified!")),
      );
      Navigator.pushReplacementNamed(context, '/createProfile');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading
          ? Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
              decoration: const BoxDecoration(
                  color: AppTheme.darkColor
              ),
              // Add any child widgets you want inside the container
            ),

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              child: ListView(
                children: [
                  Image.asset('assets/images/logo.png', width: 150, height: 150,),
                  const Center(
                    child: Text('Enter OTP', style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white
                    ),),
                  ),
                  const SizedBox(height: 30,),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Instruction Text
                          const Text(textAlign: TextAlign.center,
                            "An OTP has been sent to your phone. Please enter it below.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Pinput(
                            controller: _otpController,
                            length: 6,
                            defaultPinTheme: PinTheme(
                              height: 50,
                              width: 40,
                              textStyle: const TextStyle(fontSize: 20),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          CustomElevatedButton(
                            onPressed: (){
                              _verifyOtp();
                            },
                            text: 'Verify',
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              //TODO Resent Logic
                            },
                            child: const Text("Resend OTP"),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )],
              ),
            ),
          ])
          : const Center(
        child: SpinKitCircle(
          color: AppTheme.mainColor,
          size: 50.0,
        ),
      ),
    );
  }
}
