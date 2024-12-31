
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../config/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../controllers/authentication_service.dart';
import '../../models/login_response_model.dart';
import '../widgets/custom_button_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String id = "registerScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String? _phoneNumber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void onSendOtpPressed(String phoneNumber) async {
    setState(() {
      _isLoading = true;
    });
    AuthService authService = AuthService();
    try {
      LoginResponse response = await authService.loginWithPhoneNumber(phoneNumber);

      if (response.status == 'success' && response.verificationId != null) {
        Navigator.pushReplacementNamed(context, 'otpScreen', arguments:response.verificationId );
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: response.message.toString(),
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  child: Text('Register', style: TextStyle(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instruction Text
                        Text(
                          "Enter your mobile number to register.",
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        IntlPhoneField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          initialCountryCode: 'ZA',
                          style: TextStyle(
                            fontSize: 12
                          ),
                          showCountryFlag: false,
                          onChanged: (phone) {
                            if (phone.completeNumber.isNotEmpty) {
                              _phoneNumber = phone.completeNumber; // Save full phone number
                            }
                          },
                        ),
                        const SizedBox(height: 30),

                        CustomElevatedButton(
                          onPressed: () async{
                            if (_phoneNumber != null) {
                              onSendOtpPressed(_phoneNumber!);
                            } else {
                              AwesomeDialog(
                                btnOkColor: AppTheme.darkColor,

                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Please enter your phone number',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          text: 'Verify',
                        ),
                      ],
                    ),
                  ),
                )],
            ),
          ),
          _isLoading
              ? const Center(
            child: SpinKitCircle(
              color: AppTheme.mainColor,
              size: 50.0,
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}