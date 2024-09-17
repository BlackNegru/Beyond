import 'package:flutter/material.dart';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

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
        //backgroundColor: Colors.deepPurple.withOpacity(0.7),
        title: AppLargeText(text: "My Bookings", color: AppColors.bigTextColor,size: 32,),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.mainColor,
          unselectedLabelColor: AppColors.mainColor,
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

class UpcomingBookingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example upcoming booking items
    final upcomingBookings = [
      {"title": "Yosemite Trek", "date": "2024-09-15", "status": "Confirmed", "image": "img/mountain.jpeg"},
      {"title": "Snorkeling Adventure", "date": "2024-10-05", "status": "Pending", "image": "img/mountain.jpeg"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: upcomingBookings.length,
      itemBuilder: (context, index) {
        final booking = upcomingBookings[index];
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
    super.key,
  });

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
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: AppLargeText(text: title, color: Colors.black),
        subtitle: AppText(text: "Date: $date", color: AppColors.textColor2),
        trailing: AppText(
          text: status,
          color: status == "Completed" ? Colors.green : (status == "Confirmed" ? Colors.blue : Colors.orange),
        ),
      ),
    );
  }
}
