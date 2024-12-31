import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../widgets/custom_button_widget.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  static const String id = "createProfileScreen";

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _selectedTeam;
  bool _isLoading = false;

  List<Map<String, dynamic>> allTeams = [
    {
      "id": 2669,
      "name": "Amazulu",
      "code": "AMA",
      "country": "South-Africa",
      "founded": 1932,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2669.png"
    },
    {
      "id": 2682,
      "name": "Marumo Gallants",
      "code": "MIL",
      "country": "South-Africa",
      "founded": 1986,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2682.png"
    },
    {
      "id": 2690,
      "name": "Golden Arrows",
      "code": "GOL",
      "country": "South-Africa",
      "founded": 1943,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2690.png"
    },
    {
      "id": 2691,
      "name": "Kaizer Chiefs",
      "code": "KAI",
      "country": "South-Africa",
      "founded": 1970,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2691.png"
    },
    {
      "id": 2693,
      "name": "Polokwane City",
      "code": "POL",
      "country": "South-Africa",
      "founded": null,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2693.png"
    },
    {
      "id": 2694,
      "name": "Supersport United",
      "code": "SUP",
      "country": "South-Africa",
      "founded": 1994,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2694.png"
    },
    {
      "id": 2697,
      "name": "Cape Town City",
      "code": "BLA",
      "country": "South-Africa",
      "founded": 2007,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2697.png"
    },
    {
      "id": 2698,
      "name": "Chippa United",
      "code": "CHI",
      "country": "South-Africa",
      "founded": null,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2698.png"
    },
    {
      "id": 2699,
      "name": "Mamelodi Sundowns",
      "code": "MAM",
      "country": "South-Africa",
      "founded": 1970,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2699.png"
    },
    {
      "id": 2700,
      "name": "Orlando Pirates",
      "code": "ORL",
      "country": "South-Africa",
      "founded": 1937,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/2700.png"
    },
    {
      "id": 4905,
      "name": "Stellenbosch",
      "code": "STE",
      "country": "South-Africa",
      "founded": 1980,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/4905.png"
    },
    {
      "id": 8074,
      "name": "TS Galaxy",
      "code": null,
      "country": "South-Africa",
      "founded": 2015,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/8074.png"
    },
    {
      "id": 10566,
      "name": "Royal AM",
      "code": null,
      "country": "South-Africa",
      "founded": 2015,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/10566.png"
    },
    {
      "id": 10567,
      "name": "Richards Bay",
      "code": null,
      "country": "South-Africa",
      "founded": null,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/10567.png"
    },
    {
      "id": 15537,
      "name": "Sekhukhune United",
      "code": null,
      "country": "South-Africa",
      "founded": null,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/15537.png"
    },
    {
      "id": 19999,
      "name": "Magesi",
      "code": null,
      "country": "South-Africa",
      "founded": 2011,
      "national": false,
      "logo": "https://media.api-sports.io/football/teams/19999.png"
    }
  ];

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _selectedTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter your name and select a language")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      await _firestore.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'teamId': _selectedTeam!['id'],
        'teamName': _selectedTeam!['name'],
        'teamLogo': _selectedTeam!['logo'],
        'mobile': user.phoneNumber,
        'uid': user.uid,
      });

      // Update Firebase profile with display name
      await user.updateDisplayName(_nameController.text);
      await user.updatePhotoURL(Strings.defaultProfileImage);

      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Congratulations!',
        desc: 'Your profile has been created successfully.',
        btnOkOnPress: () {
          // Navigate to main page
          Navigator.pushReplacementNamed(context, 'homeScreen');
        },
      ).show();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading
          ? Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.4, // 40% of screen height
                  decoration: const BoxDecoration(
                    color: AppTheme.darkColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ListView(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const Center(
                        child: Text(
                          'Create Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Instruction Text
                              const Text(
                                "Enter your name and select your preferred language.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 20),
                              // Name Input Field
                              TextField(
                                style: const TextStyle(
                                  fontSize: 13
                                ),
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Enter Your Name",
                                  hintStyle: TextStyle(
                                    fontSize: 13
                                  ),
                                  helperStyle: TextStyle(
                                    fontSize: 13
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<Map<String, dynamic>>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Select Team",
                                ),
                                value: _selectedTeam,
                                items: allTeams.map((team) {
                                  return DropdownMenuItem<Map<String, dynamic>>(
                                    value: team,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          team['logo'],
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 15),
                                        Text(team['name'], style: const TextStyle(
                                          fontSize: 12
                                        ),),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedTeam = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 30),
                              // Submit Button
                              CustomElevatedButton(
                                onPressed: () {
                                  _saveProfile();
                                },
                                text: 'Save Profile',
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: SpinKitCircle(
                color: AppTheme.mainColor,
                size: 50.0,
              ),
            ),
    );
  }
}
