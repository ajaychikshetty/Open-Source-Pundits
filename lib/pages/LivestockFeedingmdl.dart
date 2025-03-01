import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'package:xie_hackathon/const/AppColors.dart';
import 'package:xie_hackathon/widgets/CustomBottomNavBar.dart';
import '../utils/livestockservice.dart';

class LivestockFeeding extends StatefulWidget {
  const LivestockFeeding({super.key});

  @override
  State<LivestockFeeding> createState() => _LivestockFeedingState();
}

class _LivestockFeedingState extends State<LivestockFeeding> {
  // Controllers for form fields
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? healthStatus;
  final List<String> healthStatusOptions = [
    'Healthy',
    'Sick',
    'Pregnant',
    'Recovering'
  ];

  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  List<dynamic> pets = []; // To hold the fetched pets data
  String? selectedPetName; // To hold the currently selected pet name

  // State to store the generated feeding schedule
  String? feedingSchedule;
  bool isLoading = false;

  Future<void> _fetchPetsData() async {
    const String apiUrl = "http://192.168.235.140:5000/get_pet";
    const String email = "ajaychikshetty123@gmail.com";

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          pets = responseData['pets'] ?? []; // Save pets data
          isLoading = false;
        });

        if (pets.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No pets found.")),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
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

  void _populateFields(String selectedName) {
    final selectedPet = pets.firstWhere((pet) => pet['name'] == selectedName);

    breedController.text = selectedPet['breed'] ?? '';
    ageController.text = selectedPet['age'].toString();
    weightController.text = selectedPet['weight'] ?? '';
  }

  @override
  void initState() {
    super.initState();
    _fetchPetsData(); // Fetch pets data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Stack(
          children: [
            // Background with subtle gradient
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.backgroundColor,
                    AppColors.backgroundColor.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                blendMode: BlendMode.srcOver,
                child: Container(color: AppColors.backgroundColor),
              ),
            ),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  pinned: true,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: const BoxDecoration(),
                      ),
                    ),
                  ),
                  title: Text(
                    'Livestock Feeding',
                    style: GoogleFonts.spaceMono(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.black,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          // Pet Selection Section
                          Container(
                            height: screenHeight * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColors.primaryColor.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildPetSelectionDropdown(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Form Fields
                          _buildTextField(
                            controller: breedController,
                            labelText: "Breed",
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: ageController,
                            labelText: "Age (in years)",
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: weightController,
                            labelText: "Weight (in kg)",
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: healthStatus,
                            items: healthStatusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                healthStatus = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a health status";
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintText: "Choose Health Status",
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.hintTextColor,
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: AppColors.accentColor.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: AppColors.accentColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              errorStyle: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                        feedingSchedule = null;
                                      });

                                      // Call the service to generate the feeding schedule
                                      final response = await LivestockService
                                          .generateFeedingSchedule(
                                        breed: breedController.text,
                                        age: ageController.text,
                                        weight: weightController.text,
                                        healthStatus: healthStatus!,
                                      );

                                      setState(() {
                                        isLoading = false;
                                      });

                                      // Show the feeding schedule in an AlertDialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Feeding Schedule',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor,
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: Text(
                                                response,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: AppColors.textColor,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Close',
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.accentColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    backgroundColor: AppColors.accentColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          'Generate Feeding Schedule',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                // Display Feeding Schedule
                                if (feedingSchedule != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        feedingSchedule!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int? maxLines = 1,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        style: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: AppColors.hintTextColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          errorStyle: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 14,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPetSelectionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Pet",
          style: GoogleFonts.rajdhani(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 3),
        DropdownButtonFormField<String>(
          value: selectedPetName,
          items: pets.map((pet) {
            return DropdownMenuItem<String>(
              value: pet['name'],
              child: Text(pet['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPetName = value;
            });
            if (value != null) {
              _populateFields(value);
            }
          },
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: "Choose a pet",
            hintStyle: GoogleFonts.poppins(
              color: AppColors.hintTextColor,
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppColors.accentColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppColors.accentColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            errorStyle: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a pet";
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }
}
