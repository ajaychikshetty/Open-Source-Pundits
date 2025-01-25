import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:xie_hackathon/const/AppColors.dart';
import 'package:provider/provider.dart';  // Import provider to listen to localization changes
import '../const/LocalizationProvider.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _navigateToPage(BuildContext context, int index) {
    if (index == widget.currentIndex) return;

    final routes = {
      0: '/MyHomePage',
      1: '/CreateAnimalPage',
      2: '/DiagnosticFormPage',
      3: '/ImagePickerPage',
      4: '/AnimalFormPage',
    };

    if (routes.containsKey(index)) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index]!,
        (Route route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     var strings = Provider.of<LocalizationProvider>(context).currentStrings;

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 20,
              spreadRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 6,
                  activeColor: Colors.black87,
                  iconSize: 28, // Increased icon size for bolder appearance
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  duration: const Duration(milliseconds: 300),
                  tabBackgroundColor: Colors.white.withOpacity(0.9),
                  color: Colors.white,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: strings['home']!,
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800, // Increased font weight
                        color: Colors.black
                      ),
                      iconActiveColor: Colors.black, // Added for consistent active state
                      iconColor: Colors.white,    // Added for consistent inactive state
                    ),
                    GButton(
                      icon: LineIcons.qrcode,
                      text: 'Report',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black
                      ),
                      iconActiveColor: Colors.black,
                      iconColor: Colors.white,
                    ),
                    GButton(
                      icon: LineIcons.calendar,
                      text: 'Event',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black
                      ),
                      iconActiveColor: Colors.black,
                      iconColor: Colors.white,
                    ),
                    GButton(
                      icon: LineIcons.gamepad,
                      text: 'Game',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black
                      ),
                      iconActiveColor: Colors.black,
                      iconColor: Colors.white,
                    ),
                    GButton(
                      icon: LineIcons.user,
                      text: 'Profile',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black
                      ),
                      iconActiveColor: Colors.black,
                      iconColor: Colors.white,
                    ),
                  ],
                  selectedIndex: widget.currentIndex,
                  onTabChange: (index) => _navigateToPage(context, index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}