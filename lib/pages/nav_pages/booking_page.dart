import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';

class BookingPage extends StatefulWidget {
  final String userId;

  const BookingPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Bookings", color: Colors.white, size: 32),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.textColor2,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpcomingBookingsTab(),
          PastBookingsTab(),
        ],
      ),
    );
  }
}

class UpcomingBookingsTab extends StatefulWidget {
  @override
  _UpcomingBookingsTabState createState() => _UpcomingBookingsTabState();
}

class _UpcomingBookingsTabState extends State<UpcomingBookingsTab> {
  List<dynamic> upcomingBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUpcomingBookings();
  }

  Future<void> fetchUpcomingBookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Fetching userId from shared preferences.

    if (userId != null) {
      final response = await http.get(Uri.parse('https://beyondserver.onrender.com/bookings/upcoming?userId=$userId'));

      if (response.statusCode == 200) {
        setState(() {
          upcomingBookings = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle case where userId is not found
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: upcomingBookings.length,
      itemBuilder: (context, index) {
        final booking = upcomingBookings[index];
        return BookingCard(
          title: booking['name']!, // Assuming your API returns experience name
          date: booking['date']!,   // Assuming your API returns booking date
          status: booking['status']!, // Assuming your API returns booking status
          imagePath: booking['image']!, // Assuming your API returns image URL
        );
      },
    );
  }
}

class PastBookingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example past booking items
    final pastBookings = [
      {"title": "Hiking in Alps", "date": "2024-07-12", "status": "Completed", "image": "img/mountain.jpeg"},
      {"title": "Kayaking Trip", "date": "2024-06-20", "status": "Completed", "image": "img/mountain.jpeg"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: pastBookings.length,
      itemBuilder: (context, index) {
        final booking = pastBookings[index];
        return BookingCard(
          title: booking['title']!,
          date: booking['date']!,
          status: booking['status']!,
          imagePath: booking['image']!,
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final String imagePath;

  const BookingCard({
    required this.title,
    required this.date,
    required this.status,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: AppLargeText(text: title, color: Colors.black,size: 15,),
        subtitle: AppText(text: "Date: $date", color: AppColors.textColor2,size: 10,),
        trailing: AppText(
          text: status,
          color: status == "Completed" ? Colors.green : (status == "Confirmed" ? Colors.blue : Colors.orange),
        ),
      ),
    );
  }
}
