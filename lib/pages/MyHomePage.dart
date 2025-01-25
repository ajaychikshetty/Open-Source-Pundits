import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xie_hackathon/pages/EditPetScreen.dart';
import '../const/AppColors.dart';
import '../const/LocalizationProvider.dart';
import '../screens/DrawerScreen.dart';
import '../widgets/CustomBottomNavBar.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedPetName; // To hold the currently selected pet name
  List<dynamic> pets = []; // To hold the fetched pets data
  String? feedingSchedule;
  bool isLoading = true;

  Future<void> _fetchPetsData() async {
    const String apiUrl = "http://192.168.235.140:5000/get_pet";
    const String email = "ajaychikshetty123@gmail.com";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          pets = responseData['pets'] ?? []; // Save pets data
          print(pets);
          isLoading = false;
        });

        if (pets.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No pets found.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPetsData();
  }

  @override
  Widget build(BuildContext context) {
    var strings = Provider.of<LocalizationProvider>(context).currentStrings;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
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
                    backgroundImage: AssetImage(
                        'assets/Images/avatar_2.jpg'), // Use AssetImage here
                  ),
                )
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
                      'MY PETS',
                      style: GoogleFonts.spaceMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor.withOpacity(0.6),
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: screenHeight * 0.30,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              physics: BouncingScrollPhysics(),
                              itemCount: pets.length,
                              itemBuilder: (context, index) {
                                final category = pets[index];
                                print(pets[index]);
                                return Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPetScreen(
                                                      petData: category)));
                                    },
                                    child: Container(
                                      width: screenWidth * 0.6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        border: Border.all(
                                          color: AppColors.accentColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 15),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                category['pet_image'],
                                                height: screenHeight * 0.14,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              category['name'],
                                              style: GoogleFonts.rajdhani(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              category['breed'],
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
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
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
                                      '${pets.length}',
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
                                      '${pets.length}',
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
