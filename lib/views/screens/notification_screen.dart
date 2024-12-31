import 'package:diskigpt/views/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const String id = "notificationScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkColor,
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon to represent no notifications
            Icon(
              Icons.notifications_off,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),

            // Message for no notifications
            const Text(
              "No Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Upgrade your plan to receive push and in-app notifications.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Upgrade to Premium Button
            CustomElevatedButton(
              onPressed: () {
                // Navigate to premium upgrade page
                Navigator.pushNamed(context, 'subscriptionScreen');
              },
              text: 'Upgrade To Premium',

            ),
          ],
        ),
      ),
    );
  }
}
