import 'package:flutter/material.dart';
import 'package:xie_hackathon/const/AppColors.dart';

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
                _buildMenuItems(),
                const Spacer(),
                _buildLogoutButton(),
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

  Widget _buildMenuItems() {
    final menuItems = [
      const DrawerMenuItem(
        icon: Icons.settings_outlined,
        text: 'Settings',
      ),
      const DrawerMenuItem(
        icon: Icons.person_outline,
        text: 'Profile',
      ),
      const DrawerMenuItem(
        icon: Icons.chat_bubble_outline,
        text: 'Messages',
      ),
      const DrawerMenuItem(
        icon: Icons.bookmark_border,
        text: 'Saved',
      ),
      const DrawerMenuItem(
        icon: Icons.favorite_border,
        text: 'Favorites',
      ),
      const DrawerMenuItem(
        icon: Icons.lightbulb_outline,
        text: 'Hint',
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

  Widget _buildLogoutButton() {
    return Row(
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
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const DrawerMenuItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}