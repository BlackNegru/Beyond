import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../misc/colors.dart';
import '../widgets/app_largetext.dart';
import '../widgets/app_text.dart';
import 'login_page.dart'; // Ensure you have a login page

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  Future<void> registerUser(BuildContext context, String name, String email, String password) async {
    final url = 'https://beyondserver.onrender.com/register'; // Replace with your backend server URL

    // Check if the email is valid using regex
    if (!validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email format!")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Navigate to LoginPage on successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Handle registration failure
        print('Registration failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed. Try again.")),
        );
      }
    } catch (error) {
      print('Error during registration: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  bool validateEmail(String email) {
    // Regular expression for basic email validation
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This line removes the back button
        title: Center(
          child: AppLargeText(
            text: "BEYOND",
            color: AppColors.mainColor.withOpacity(0.8),
          ),
        ),
        backgroundColor: Colors.cyan.withOpacity(0.1),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'img/loginpageimg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 4),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "Create an Account",
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      labelText: "Full Name",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.white),
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        registerUser(context, nameController.text, emailController.text, passwordController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all fields")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
