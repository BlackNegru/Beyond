import 'package:beyond/pages/nav_pages/search_page.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import 'booking_page.dart';
import 'my_page.dart';


import 'package:beyond/pages/nav_pages/upload_page.dart';  // Import the new page

class MainPage extends StatefulWidget {
  final String userId;  // Accept the userId parameter

  const MainPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(),
      BookingPage(),
      SearchPage(),
      MyPage(),
      UploadPage(userId: widget.userId),  // Pass userId to UploadPage
    ];
  }

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.apps)),
          BottomNavigationBarItem(label: "Booking", icon: Icon(Icons.bar_chart_sharp)),
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "Me", icon: Icon(Icons.person)),
          BottomNavigationBarItem(label: "Upload", icon: Icon(Icons.upload)),  // New item
        ],
      ),
    );
  }
}


