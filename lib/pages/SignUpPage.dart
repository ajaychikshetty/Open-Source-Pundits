import 'package:flutter/material.dart';
import '../const/AppColors.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController fullName = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController dob = TextEditingController();
    TextEditingController mobileNumber = TextEditingController();
    TextEditingController gender = TextEditingController();
    TextEditingController password = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Added GIF at the top
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
                  _buildForm(
                    fullName, email, dob, 
                    mobileNumber, gender, password
                  ),
                  const SizedBox(height: 30),
                  _buildSignUpButton(context),
                  const SizedBox(height: 20),
                  _buildLoginLink(context),
                ],
              ),
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
        )
      ],
    );
  }

  Widget _buildForm(
    TextEditingController fullName,
    TextEditingController email,
    TextEditingController dob,
    TextEditingController mobileNumber,
    TextEditingController gender,
    TextEditingController password,
  ) {
    return Column(
      children: <Widget>[
        _buildTextField(fullName, "Full Name", Icons.person),
        const SizedBox(height: 15),
        _buildTextField(email, "Email", Icons.email),
        const SizedBox(height: 15),
        _buildTextField(dob, "Date of Birth", Icons.calendar_today),
        const SizedBox(height: 15),
        _buildTextField(mobileNumber, "Mobile Number", Icons.phone),
        const SizedBox(height: 15),
        _buildTextField(gender, "Gender", Icons.person_outline),
        const SizedBox(height: 15),
        _buildPasswordField(password, "Password"),
        const SizedBox(height: 15),
        _buildPasswordField(TextEditingController(), "Confirm Password"),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String hintText, 
    IconData icon
  ) {
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

  Widget _buildPasswordField(TextEditingController controller, String hintText) {
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
        Navigator.pushNamedAndRemoveUntil(context, "/MyHomePage", (Route<dynamic> route) => false);;;
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
        Navigator.pushNamedAndRemoveUntil(context, "/LoginPage", (Route<dynamic> route) => false);
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
}