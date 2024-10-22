import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';

class MyPage extends StatefulWidget {
  final String userId;

  const MyPage({Key? key, required this.userId}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userId = '';
  String name = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    if (userId.isNotEmpty) {
      await _fetchUserDetails(userId);
    }
  }

  Future<void> _fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.0.105:5000/user/$userId')); // Replace with your actual API URL

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        name = data['name'];
        email = data['email'];
        phone = data['phone'];
      });
    } else {
      setState(() {
        name = 'Error loading data';
        email = '';
        phone = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Profile", color: Colors.white, size: 32),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile_picture.jpg'), // Replace with user's profile picture
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name, // User's name
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email, // User's email
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        phone, // User's phone number
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to edit profile page
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to view bookings page or other relevant page
                  },
                  icon: Icon(Icons.bookmark),
                  label: Text('My Bookings'),
                  style: ElevatedButton.styleFrom(),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Additional Information
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Address'),
                    subtitle: Text('1234 Main St, City, Country'), // Static for now
                    onTap: () {
                      // Navigate to address details page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cake),
                    title: Text('Date of Birth'),
                    subtitle: Text('January 1, 1990'), // Static for now
                    onTap: () {
                      // Navigate to date of birth details page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Additional Info'),
                    subtitle: Text('Some additional information here...'), // Static for now
                    onTap: () {
                      // Navigate to more detailed info page
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
