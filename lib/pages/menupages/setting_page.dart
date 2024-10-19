import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';
class SettingPage extends StatelessWidget {
  final String userId;

  const SettingPage({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Settings", color: Colors.white, size: 28),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLargeText(
              text: "Account Settings",
              color: Colors.black.withOpacity(0.8),
              size: 20,
            ),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.mainColor),
              title: AppText(text: "Edit Profile", color: AppColors.textColor1),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textColor1),
              onTap: () {
                // Navigate to Edit Profile page
              },
            ),
            Divider(),

            AppLargeText(
              text: "App Preferences",
              color: Colors.black.withOpacity(0.8),
              size: 20,
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: AppColors.mainColor),
              title: AppText(text: "Notifications", color: AppColors.textColor1),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Handle toggle action
                },
              ),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.language, color: AppColors.mainColor),
              title: AppText(text: "Language", color: AppColors.textColor1),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textColor1),
              onTap: () {
                // Navigate to Language Selection page
              },
            ),
            Divider(),

            AppLargeText(
              text: "More",
              color: Colors.black.withOpacity(0.8),
              size: 20,
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: AppColors.mainColor),
              title: AppText(text: "Help & Support", color: AppColors.textColor1),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textColor1),
              onTap: () {
                // Navigate to Help & Support page
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.mainColor),
              title: AppText(text: "About", color: AppColors.textColor1),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textColor1),
              onTap: () {
                // Navigate to About page
              },
            ),
          ],
        ),
      ),
    );
  }
}

