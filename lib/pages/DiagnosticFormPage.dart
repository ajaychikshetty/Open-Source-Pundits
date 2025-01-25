import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../const/AppColors.dart';
import '../utils/DiagnosticService.dart';
import '../widgets/CustomBottomNavBar.dart';

class DiagnosticFormPage extends StatefulWidget {
  const DiagnosticFormPage({super.key});

  @override
  State<DiagnosticFormPage> createState() => _DiagnosticFormPageState();
}

class _DiagnosticFormPageState extends State<DiagnosticFormPage> {
  // Controllers for form inputs
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController diseaseHistoryController =
      TextEditingController();
  final TextEditingController symptomsController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // State variables
  List<dynamic> pets = []; // To hold the fetched pets data
  String? selectedPetName; // To hold the currently selected pet name
  bool isLoading = false; // To manage loading state
  String? diagnosticSummary;
  // Fetch pets data from the Flask API
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

  void _showDiagnosticSummaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Diagnostic Summary',
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              diagnosticSummary ?? 'No summary available',
              style: GoogleFonts.poppins(),
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
                  color: AppColors.accentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Populate fields when a pet name is selected
  void _populateFields(String selectedName) {
    final selectedPet = pets.firstWhere((pet) => pet['name'] == selectedName);

    breedController.text = selectedPet['breed'] ?? '';
    ageController.text = selectedPet['age'].toString();
    weightController.text = selectedPet['weight'] ?? '';
    diseaseHistoryController.text =
        (selectedPet['disease_history'] as List<dynamic>).join(', ');
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
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
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
                    'Diagnostic Form',
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

                          _buildTextField(
                            controller: diseaseHistoryController,
                            labelText: "Disease History",
                            maxLines: 3,
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: symptomsController,
                            labelText: "Symptoms",
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please describe the symptoms";
                              }
                              return null;
                            },
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
                                        diagnosticSummary = null;
                                      });

                                      try {
                                        // Call the service to generate a diagnostic summary
                                        final response = await DiagnosticService
                                            .generateDiagnosticSummary(
                                          breed: breedController.text,
                                          age: ageController.text,
                                          weight: weightController.text,
                                          symptoms: symptomsController.text,
                                          diseaseHistory:
                                              diseaseHistoryController.text,
                                        );
                                        // ---------------------
                                      print(response);

                                        // ---------------------
                                        // ----------------------
                                        setState(() {
                                          isLoading = false;
                                          diagnosticSummary = response;
                                        });

                                        // Optionally show the summary in a dialog or navigate to a new page
                                        _showDiagnosticSummaryDialog();
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Error generating summary: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
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
                                          'Generate Diagnostic Summary',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),

                                // Optionally show loading indicator or summary
                                if (isLoading)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
                            ),
                          ),

                          // Add this method to show the diagnostic summary

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
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    diseaseHistoryController.dispose();
    symptomsController.dispose();
    super.dispose();
  }
}
