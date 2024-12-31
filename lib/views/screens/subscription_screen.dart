import 'package:diskigpt/config/theme.dart';
import 'package:diskigpt/views/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});
  static const String id = "subscriptionScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        title: const Text("Premium Plan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '\R9.99',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.ascentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Annually',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description of the Premium Plan
            const Text(textAlign: TextAlign.center,
              'As a Premium Subscriber, you get to enjoy the following benefits:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // List of Benefits
            Container(
              decoration: BoxDecoration(
                color: AppTheme.darkColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitItem(
                    icon: Icons.sports_soccer,
                    title: "Follow More Than One Team",
                    description: "Keep up with your favorite teams and their matches.",
                  ),
                  _buildBenefitItem(
                    icon: Icons.notifications,
                    title: "Live Push Notifications",
                    description: "Get notified for live updates and important events.",
                  ),
                  _buildBenefitItem(
                    icon: Icons.chat,
                    title: "Join Multiple Banter Rooms",
                    description: "Join discussions and banter with fans worldwide.",
                  ),
                  _buildBenefitItem(
                    icon: Icons.video_collection,
                    title: "View Match Highlights",
                    description: "Watch game highlights as soon as the match ends.",
                  ),
                  _buildBenefitItem(
                    icon: Icons.bar_chart,
                    title: "Pro Betting Tips",
                    description: "Receive expert tips to improve your betting game.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Subscribe Button
            CustomElevatedButton(
              onPressed: () {
               //TODO create subscription
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Subscribed to Premium Plan!")),
                );
              },

              text: "Subscribe Now",
            ),
          ],
        ),
      ),
    );
  }

  // Custom method to build each benefit item
  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
