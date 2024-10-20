import 'package:flutter/material.dart';
import '../pages/menupages/faq_page.dart';
import '../pages/menupages/setting_page.dart';

class CustomMenuBar extends StatelessWidget {
  final String userId;  // Add userId parameter

  const CustomMenuBar({Key? key, required this.userId}) : super(key: key);  // Add required constructor

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage(userId: userId)),  // Pass userId
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('FAQ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQPage(userId: userId)),  // Pass userId
              );
            },
          ),
        ],
      ),
    );
  }
}
