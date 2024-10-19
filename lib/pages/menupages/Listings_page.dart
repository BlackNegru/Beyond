import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';

class ListingsPage extends StatelessWidget {
  final String userId;

  ListingsPage({Key? key, required this.userId}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchExperiences() async {
    final String url = 'http://192.168.0.105:5000/get-experiences/$userId'; // Your API endpoint

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((exp) => {
          'title': exp['name'],
          'location': exp['location'],
          'status': exp['status'] ?? 'Not Booked', // Default to 'Not Booked' if null
          'price': '\$${exp['price']}', // Assuming price is sent as a number
        }).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}'); // Debug output
        throw Exception('Failed to load experiences');
      }
    } catch (error) {
      print('Caught error: $error'); // Debug output
      throw Exception('Failed to load experiences');
    }
  }

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchExperiences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No experiences found.'));
          } else {
            final experiences = snapshot.data!;

            return Padding(
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
                                text: experience['title'] ?? 'Unnamed Experience', // Default text if title is null
                                color: Colors.black.withOpacity(0.8),
                                size: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: getStatusColor(experience['status'] ?? 'Not Booked'), // Default to 'Not Booked' if null
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: AppText(
                                  text: experience['status'] ?? 'Not Booked', // Default to 'Not Booked' if null
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
                                text: experience['location'] ?? 'Unknown Location', // Default text if location is null
                                color: AppColors.textColor1,
                                size: 14,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          AppText(
                            text: "Price: ${experience['price'] ?? '\$0'}", // Default price if null
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
            );
          }
        },
      ),
    );
  }
}
