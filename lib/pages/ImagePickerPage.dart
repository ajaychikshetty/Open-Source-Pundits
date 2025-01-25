import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/AppColors.dart';
import '../widgets/CustomBottomNavBar.dart';
import 'ResultsPage.dart'; // Import the new results page

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<Uint8List> _compressImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }
    final compressedImage = img.encodeJpg(
      originalImage,
      quality: 50,
    );
    return Uint8List.fromList(compressedImage);
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final compressedImage = await _compressImage(_selectedImage!);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.235.140:5000/crop_pred'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'crop_img',
          compressedImage,
          filename: 'compressed_image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Navigate to ResultsPage with the image and response
        ///////////////////////////////////////////////////////////Route this Fuckedup Navigator////////////////////////////
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              imageFile: _selectedImage!,
              predictionResult: responseBody,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Upload Failed: ${response.reasonPhrase} (Code: ${response.statusCode})',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
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
                    'Image Picker',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        
                        // Image Display Section
                        Container(
                          height: screenHeight * 0.4,
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
                            child: _buildImageDisplay(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Image Selection Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildImagePickButton(
                              onPressed: _pickImageFromGallery,
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              color: AppColors.primaryColor,
                            ),
                            _buildImagePickButton(
                              onPressed: _captureImageWithCamera,
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              color: AppColors.accentColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Upload Button
                        if (_selectedImage != null)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _isUploading ? null : _uploadImage,
                              icon: const Icon(Icons.upload),
                              label: Text(
                                _isUploading ? 'Uploading...' : 'Upload',
                                style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                backgroundColor: AppColors.accentColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildImageDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selected Image",
          style: GoogleFonts.rajdhani(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'No image selected',
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildImagePickButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label, 
        style: GoogleFonts.poppins(),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}