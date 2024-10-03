import 'package:flutter/material.dart';
import '../misc/colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_largetext.dart';
import '../widgets/app_text.dart';

class ListingsPage extends StatelessWidget {
  final List<Map<String, String>> experiences = [
    {
      "title": "Skydiving",
      "location": "USA, California",
      "status": "Booked",
      "price": "\$300",
    },
    {
      "title": "Scuba Diving",
      "location": "Australia, Great Barrier Reef",
      "status": "Pending",
      "price": "\$400",
    },
    {
      "title": "Mountain Trekking",
      "location": "Nepal, Everest Base Camp",
      "status": "Not Booked",
      "price": "\$500",
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Not Booked':
        return Colors.red.withOpacity(0.7);
      case 'Pending':
        return Colors.yellow.withOpacity(0.7);
      case 'Booked':
        return Colors.green.withOpacity(0.7);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Manage Experiences", color: Colors.white, size: 28),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            final experience = experiences[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                          text: experience['title']!,
                          color: Colors.black.withOpacity(0.8),
                          size: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            color: getStatusColor(experience['status']!),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: AppText(
                            text: experience['status']!,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.mainColor, size: 16),
                        SizedBox(width: 5),
                        AppText(
                          text: experience['location']!,
                          color: AppColors.textColor1,
                          size: 14,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    AppText(
                      text: "Price: ${experience['price']}",
                      color: AppColors.textColor1,
                      size: 14,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Handle edit action
                          },
                          icon: Icon(Icons.edit, color: AppColors.mainColor),
                        ),
                        IconButton(
                          onPressed: () {
                            // Handle delete action
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
