import 'package:diskigpt/config/theme.dart';
import 'package:flutter/material.dart';

class DiskiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? userImage;

  const DiskiAppBar({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.secondaryColor,
      elevation: 0,
      toolbarHeight: 70,
      title: Row(
        children: [
          // User Profile Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'userProfileScreen');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: userImage != null
                    ? Image.network(
                  userImage!,
                  fit: BoxFit.cover,
                )
                    : const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Welcome Text and Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hi Welcome 👋',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Search Icon
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            // Implement search functionality
          },
        ),
        // Notification Icon with Badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                // Implement notifications functionality
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 8,
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8), // Add some padding at the end
      ],
    );
  }
}