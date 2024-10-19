import 'package:flutter/material.dart';

import '../misc/colors.dart';

class AdminPage extends StatefulWidget {
  final String userId;

  const AdminPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;
  // List of widget options corresponding to each tab
  final List<Widget> _widgetOptions = <Widget>[
    Text('Admin Dashboard', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Manage Users', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Manage Listings', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Manage Reviews', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Settings', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
