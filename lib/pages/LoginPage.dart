import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xie_hackathon/utils/AuthManager.dart';
import '../const/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // if (readData()!) {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, "/MyHomePage", (Route<dynamic> route) => false);
    // }

    print("${readData()}-----------------------");
    print(readData() != Null);
  }

  void saveData(username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username); // Save data
  }

  Future<String?> readData() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username'); // Read data
    print('Username: $username');
    return username;
  }
   Future<void> checkLoginStatus() async {
    bool isLoggedIn = await AuthManager.isLoggedIn();
    // navigateToPage(true);
    navigateToPage(isLoggedIn);
  }
  void navigateToPage(bool isLoggedIn) {
    print("is logged in is $isLoggedIn");
    if (isLoggedIn) {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => Home()));
      Navigator.pushNamedAndRemoveUntil(
          context, '/MyHomePage', ModalRoute.withName('/Home'));
    } 
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                  Center(
                    child: Image.asset(
                      'assets/Images/gif2.gif',
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildForm(emailController, passwordController),
                  const SizedBox(height: 20),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 20),
                  _buildLoginButton(
                      context, emailController, passwordController),
                  const SizedBox(height: 20),
                  _buildSignUpLink(context),
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
          "Login",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Sign in to continue",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textColor.withOpacity(0.7),
          ),
        )
      ],
    );
  }

  Widget _buildForm(TextEditingController emailController,
      TextEditingController passwordController) {
    return Column(
      children: <Widget>[
        _buildTextField(emailController, "Email", Icons.email, false),
        const SizedBox(height: 15),
        _buildTextField(passwordController, "Password", Icons.lock, true),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      IconData icon, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
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

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: AppColors.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return ElevatedButton(
      onPressed: () {
        String username = emailController.text;
        String password = passwordController.text;

        // Validate inputs
        if (username.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill in both fields")),
          );
          return;
        }

        // Call the login method
        _login(context, username, password);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _login(
      BuildContext context, String username, String password) async {
    const String apiUrl =
        "http://192.168.235.140:5000/login"; // Replace with your API URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      print("${response.statusCode}------------");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("${data}--------------------------------");
        if (data['status'] == 1) {
          // Navigate to the home page and pass the username
          AuthManager.setLoggedIn(true, data['username']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/MyHomePage",
            (Route<dynamic> route) => false,
          );
          saveData(data[username]);
          // LoginPage.username = data["username"];
        } else if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wrong password")),
          );
        } else if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found")),
          );
        } else {
          // Show error message for invalid login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid username or password")),
          );
        }
      } else {
        // Handle unexpected response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account?",
          style: TextStyle(color: AppColors.textColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/SignUp", (Route<dynamic> route) => false);
          },
          child: Text(
            "Sign Up",
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
