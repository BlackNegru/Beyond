import 'package:flutter/material.dart';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';


class MyPage extends StatelessWidget {
  final String userId;

  const MyPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
                        'Moe joe lester', // Replace with user's name
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'moe.joe.lester@example.com', // Replace with user's email
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '123-456-7890', // Replace with user's phone number
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
                  style: ElevatedButton.styleFrom(

                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to view bookings page or other relevant page
                  },
                  icon: Icon(Icons.bookmark),
                  label: Text('My Bookings'),
                  style: ElevatedButton.styleFrom(

                  ),
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
                    subtitle: Text('1234 Main St, City, Country'), // Replace with user's address
                    onTap: () {
                      // Navigate to address details page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cake),
                    title: Text('Date of Birth'),
                    subtitle: Text('January 1, 1990'), // Replace with user's date of birth
                    onTap: () {
                      // Navigate to date of birth details page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Additional Info'),
                    subtitle: Text('Some additional information here...'), // Replace with other details
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
