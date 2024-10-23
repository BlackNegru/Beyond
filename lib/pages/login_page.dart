import 'package:beyond/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../misc/colors.dart';
import '../widgets/app_largetext.dart';
import '../widgets/app_text.dart';
import 'nav_pages/main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> loginUser(BuildContext context, String email, String password) async {
    final url = 'https://beyondserver.onrender.com/login'; // Replace with your backend server URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userId = jsonResponse['userId'];

        // Save userId to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        // Navigate to MainPage on successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage(userId: userId)),
        );
      } else {
        // Handle invalid credentials
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    text: "Welcome Back",
                    size: 24,
                    color: Colors.white,
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
                      loginUser(context, emailController.text, passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 15.0),
                    ),
                    child: Text(
                      "Don't have an account?Sign up",
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
