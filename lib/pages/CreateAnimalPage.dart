import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../const/AppColors.dart';
import '../widgets/CustomBottomNavBar.dart';

class CreateAnimalPage extends StatefulWidget {
  const CreateAnimalPage({Key? key}) : super(key: key);

  @override
  State<CreateAnimalPage> createState() => _CreateAnimalPageState();
}

class _CreateAnimalPageState extends State<CreateAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController diseaseHistoryController = TextEditingController();

  File? _animalPhoto;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _animalPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _animalPhoto = File(pickedFile.path);
      });
    }
  }
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        },
      );

      final animalData = {
        "email": "ajaychikshetty123@gmail.com",
        "name": nameController.text,
        "age": ageController.text,
        "breed": breedController.text,
        "weight": weightController.text,
        "disease_history": diseaseHistoryController.text,
      };

      const String apiUrl = "http://192.168.235.140:5000/add_pet";

      try {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.fields.addAll(animalData);

        if (_animalPhoto != null) {
          final compressedImage = await _compressImage(_animalPhoto!);

          final tempDir = Directory.systemTemp;
          final tempFile = File('${tempDir.path}/compressed_animal_photo.jpg');
          await tempFile.writeAsBytes(compressedImage);

          request.files.add(await http.MultipartFile.fromPath(
            'pet_image',
            tempFile.path,
          ));
        }

        var response = await request.send();
        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final responseData = jsonDecode(responseBody);

          if (responseData['status'] == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Animal details submitted successfully!'),
                backgroundColor: AppColors.primaryColor,
              ),
            );

            _formKey.currentState!.reset();
            setState(() {
              _animalPhoto = null;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseData['message'] ?? 'Submission failed.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        print("Error: $e");
      }
    }
  }

  Future<List<int>> _compressImage(File file) async {
    final imageBytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage != null) {
      final resizedImage = img.copyResize(decodedImage, width: 800);
      final compressedImage = img.encodeJpg(resizedImage, quality: 85);

      return compressedImage;
    }

    return imageBytes;
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
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
                        decoration: BoxDecoration(
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Create Animal',
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
                          
                          // Photo Upload Section
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
                              padding: const EdgeInsets.all(20),
                              child: _buildPhotoUploadSection(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Form Fields
                          _buildTextField(
                            controller: nameController,
                            labelText: "Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the animal's name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: ageController,
                            labelText: "Age (in years)",
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the animal's age";
                              }
                              if (double.tryParse(value) == null) {
                                return "Please enter a valid number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: breedController,
                            labelText: "Breed",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the animal's breed";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: weightController,
                            labelText: "Weight (in kg)",
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the animal's weight";
                              }
                              if (double.tryParse(value) == null) {
                                return "Please enter a valid number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: diseaseHistoryController,
                            labelText: "Disease History",
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the animal's disease history";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          Center(
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                backgroundColor: AppColors.accentColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Submit',
                                style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
    TextInputType? keyboardType,
    int? maxLines = 1,
    required String? Function(String?)? validator,
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
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photo of Animal",
          style: GoogleFonts.rajdhani(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        _animalPhoto == null
            ? Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'No photo selected',
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  _animalPhoto!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: const Icon(Icons.photo_library),
              label: Text('Gallery', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _captureImageWithCamera,
              icon: const Icon(Icons.camera_alt),
              label: Text('Camera', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    breedController.dispose();
    weightController.dispose();
    diseaseHistoryController.dispose();
    super.dispose();
  }
}