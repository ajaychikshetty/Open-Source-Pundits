import 'package:flutter/material.dart';
import 'package:xie_hackathon/const/AppColors.dart';
import 'package:xie_hackathon/pages/LoginPage.dart';
import 'package:xie_hackathon/pages/MyHomePage.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildMenuItems(context), // Pass context to handle navigation
                const Spacer(),
                _buildLogoutButton(context), // Logout action
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: const AssetImage('assets/Images/avatar_2.jpg'),
        ),
        const SizedBox(width: 15),
        Text(
          'Side Bar',
          style: TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      DrawerMenuItem(
        icon: Icons.settings_outlined,
        text: 'Add Animal',
        onTap: () => Navigator.pushNamed(context, '/CreateAnimalPage'),
      ),
      DrawerMenuItem(
        icon: Icons.person_outline,
        text: 'Profile',
        onTap: () => Navigator.pushNamed(context, '/profile'),
      ),
      DrawerMenuItem(
        icon: Icons.chat_bubble_outline,
        text: 'Messages',
        onTap: () => Navigator.pushNamed(context, '/messages'),
      ),
      DrawerMenuItem(
        icon: Icons.bookmark_border,
        text: 'Saved',
        onTap: () => Navigator.pushNamed(context, '/saved'),
      ),
      DrawerMenuItem(
        icon: Icons.favorite_border,
        text: 'Favorites',
        onTap: () => Navigator.pushNamed(context, '/favorites'),
      ),
      DrawerMenuItem(
        icon: Icons.lightbulb_outline,
        text: 'Hint',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This is a helpful hint!')),
          );
        },
      ),
    ];

    return Column(
      children: menuItems
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: item,
              ))
          .toList(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging out...')),
        );
        // LoginPage.username = "-1";
        Navigator.pushNamedAndRemoveUntil(context, "/LoginPage", (Route<dynamic> route) => false);
      },
      child: Row(
        children: [
          Icon(
            Icons.cancel,
            color: AppColors.backgroundColor.withOpacity(0.5),
          ),
          const SizedBox(width: 10),
          Text(
            'Log out',
            style: TextStyle(color: AppColors.backgroundColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap; // Callback for item tap

  const DrawerMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.backgroundColor,
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(color: AppColors.backgroundColor),
          ),
        ],
      ),
    );
  }
}
