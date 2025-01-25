import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../const/AppColors.dart';
import '../const/LocalizationProvider.dart';
import '../screens/DrawerScreen.dart';
import '../widgets/CustomBottomNavBar.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> homeCategories = [
    {
      'title': 'WasteBot',
      'description': 'AI Waste Management',
      'icon': Icons.recycling,
      'imageUrl':
          'https://images.unsplash.com/photo-1545987796-200677ee1011?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'title': 'Recycle',
      'description': 'Smart Recycling',
      'icon': Icons.auto_awesome,
      'imageUrl':
          'https://images.unsplash.com/photo-1545987796-200677ee1011?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var strings = Provider.of<LocalizationProvider>(context).currentStrings;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      drawer: DrawerScreen(),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: const CustomBottomNavBar(currentIndex: 0),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                strings['appTitle']!,
                style: GoogleFonts.spaceMono(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: AppColors.textColor,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryColor,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1545987796-200677ee1011?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'OUR SERVICES',
                      style: GoogleFonts.spaceMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor.withOpacity(0.6),
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: screenHeight * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        physics: BouncingScrollPhysics(),
                        itemCount: homeCategories.length,
                        itemBuilder: (context, index) {
                          final category = homeCategories[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Container(
                              width: screenWidth * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColors.primaryColor.withOpacity(0.1),
                                border: Border.all(
                                  color: AppColors.accentColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15),
                                    SizedBox(height: 15),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        category['imageUrl'],
                                        height: screenHeight * 0.12,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      category['title'],
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category['description'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.textColor
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05,),
                     Text(
                      'OUR SERVICES',
                      style: GoogleFonts.spaceMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor.withOpacity(0.6),
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Header Container
                    Container(
                      height: screenHeight * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Left side with counter
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${homeCategories.length}',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.backgroundColor,
                                      ),
                                    ),
                                    Text(
                                      'SERVICES',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 14,
                                        letterSpacing: 2,
                                        color: AppColors.backgroundColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),

                            // Right side with title
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'CROP',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'DISEASE',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'DETECTION HERE',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: screenHeight * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Left side with counter
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${homeCategories.length}',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.backgroundColor,
                                      ),
                                    ),
                                    Text(
                                      'SERVICES',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 14,
                                        letterSpacing: 2,
                                        color: AppColors.backgroundColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            // Right side with title
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ANIMAL',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'DISEASE',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'DETECTION HERE',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
