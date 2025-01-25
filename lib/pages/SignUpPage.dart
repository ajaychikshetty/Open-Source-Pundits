import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../const/AppColors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers for form fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  // For profile picture upload
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Method to capture image using camera
  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Registration API call
  Future<void> _registerWithMultipart(
    BuildContext context,
    String fullName,
    String email,
    String password,
    String mobileNumber,
    String dob,
    String gender,
    File? profilePicture, // Pass the file object directly
  ) async {
    const String apiUrl =
        "http://192.168.235.140:5000/register"; // Replace with your Flask API URL

    try {
      // Create a multipart request
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      // Add text fields
      request.fields['full_name'] = fullName;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['mobile_number'] = mobileNumber;
      request.fields['dob'] = dob;
      request.fields['gender'] = gender;

      // Add file if present
      if (profilePicture != null) {
        var picture = await http.MultipartFile.fromPath(
          'profile_picture', // This field name must match the Flask backend
          profilePicture.path,
        );
        request.files.add(picture);
      }

      // Send the request
      var response = await request.send();
      print("${response.statusCode}---------------------");
      // Handle response
      if (response.statusCode == 200) {
        print("inside if");
        var responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        
          // Registration successful
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful!")),
          );

          // Navigate to login page
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/LoginPage",
            (Route<dynamic> route) => false,
          );
        
      } else {
        // Unexpected status code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // GIF at the top
                Center(
                  child: Image.asset(
                    'assets/Images/gif1.gif',
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildProfilePictureSection(),
                const SizedBox(height: 30),
                _buildForm(),
                const SizedBox(height: 30),
                _buildSignUpButton(context),
                const SizedBox(height: 20),
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        Text(
          "Sign up",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Create your account",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        const Text(
          "Upload Profile Picture",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showImagePickerOptions(),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(75),
              border: Border.all(color: AppColors.primaryColor, width: 2),
              image: _profileImage != null
                  ? DecorationImage(
                      image: FileImage(_profileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _profileImage == null
                ? const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.black54,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        _buildTextField(fullNameController, "Full Name", Icons.person),
        const SizedBox(height: 15),
        _buildTextField(emailController, "Email", Icons.email),
        const SizedBox(height: 15),
        _buildTextField(mobileNumberController, "Mobile Number", Icons.phone),
        const SizedBox(height: 15),
        _buildTextField(dobController, "Date of Birth", Icons.calendar_today),
        const SizedBox(height: 15),
        _buildTextField(genderController, "Gender", Icons.person),
        const SizedBox(height: 15),
        _buildPasswordField(passwordController, "Password"),
        const SizedBox(height: 15),
        _buildPasswordField(confirmPasswordController, "Confirm Password"),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.accentColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.accentColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String fullName = fullNameController.text;
        String email = emailController.text;
        String password = passwordController.text;
        String mobileNumber = mobileNumberController.text;
        String dob = dobController.text;
        String gender = genderController.text;

        // Validate inputs
        if (fullName.isEmpty ||
            email.isEmpty ||
            password.isEmpty ||
            mobileNumber.isEmpty ||
            dob.isEmpty ||
            gender.isEmpty ||
            _profileImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Please fill in all fields and upload a profile picture")),
          );
          return;
        }

        // Call the Flask-compatible register function
        _registerWithMultipart(
          context,
          fullName,
          email,
          password,
          mobileNumber,
          dob,
          gender,
          _profileImage, // Pass the file object
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        "Sign up",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Already have an account?",
          style: TextStyle(color: AppColors.textColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/LoginPage", (Route<dynamic> route) => false);
          },
          child: Text(
            "Login",
            style: TextStyle(
              color: AppColors.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a Picture"),
            onTap: () {
              Navigator.pop(context);
              _captureImageWithCamera();
            },
          ),
        ],
      ),
    );
  }
}
