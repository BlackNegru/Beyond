import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/responsive_button.dart';
import '../pages/booklisting_page.dart'; // Import your BookListingsPage here

class DetailPage extends StatefulWidget {
  final String experienceId;

  const DetailPage({Key? key, required this.experienceId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailPage> {
  Map<String, dynamic>? experienceDetails;
  bool isLoading = true;
  DateTime? selectedDate;
  int selectedPeople = 1; // Default number of people

  @override
  void initState() {
    super.initState();
    _fetchExperienceDetails();
  }

  Future<void> _fetchExperienceDetails() async {
    final String url =
        'http://192.168.0.105:5000/experience/${widget.experienceId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          experienceDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Caught error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openGoogleMaps() async {
    if (experienceDetails != null && experienceDetails!['mapsLink'] != null) {
      final String mapsLink = experienceDetails!['mapsLink'];
      final Uri googleMapsUrl = Uri.parse(mapsLink);

      try {
        final bool launched = await launchUrl(googleMapsUrl);
        if (!launched) {
          print('Could not launch $mapsLink');
        }
      } catch (e) {
        print('Error launching $mapsLink: $e');
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : experienceDetails != null
          ? Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            // Image area
            Positioned(
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Show image gallery
                },
                child: Container(
                  width: double.maxFinite,
                  height: 300, // Image height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(
                          experienceDetails!['images'][0])),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Scrollable content below the image
            Positioned(
              top: 260,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLargeText(
                            text: experienceDetails!['name'],
                            color: Colors.black.withOpacity(0.7),
                          ),
                          AppLargeText(
                            text: "\$${experienceDetails!['price']}",
                            color: AppColors.mainColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Location and Google Maps button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: AppColors.mainColor),
                              SizedBox(width: 5),
                              AppLargeText(
                                text: experienceDetails!['location'],
                                color: AppColors.textColor1,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _openGoogleMaps,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: AppColors.buttonBackground,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map, color: AppColors.mainColor, size: 15),
                                  SizedBox(width: 5),
                                  AppText(
                                    text: "View on Maps",
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      AppLargeText(
                        text: "Number of people in your group",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(height: 10),
                      // Number of people input
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter number of people',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedPeople = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      // Description
                      AppLargeText(
                        text: "Description",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(height: 10),
                      AppText(
                        text: experienceDetails!['description'],
                        color: AppColors.mainTextColor,
                      ),
                      SizedBox(height: 20),
                      // Date selection
                      AppLargeText(
                        text: "Select Date and Time",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.buttonBackground,
                          ),
                          child: Center(
                            child: AppText(
                              text: selectedDate == null
                                  ? "Select date"
                                  : DateFormat.yMMMMd().format(selectedDate!),
                              color: selectedDate == null
                                  ? AppColors.textColor2
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      // List of images (all images at the bottom)
                      AppLargeText(
                        text: "Images",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: List.generate(
                          experienceDetails!['images'].length,
                              (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                width: double.maxFinite,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(base64Decode(
                                        experienceDetails!['images'][index])),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // Book button styled
// Book button styled
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            // Check if date is selected
                            if (selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a date')),
                              );
                              return;
                            }

                            // Check if number of people is valid
                            if (selectedPeople <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Number of people must be at least 1')),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookListingsPage(
                                  expId: widget.experienceId,
                                  date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                                  totalPeople: selectedPeople,
                                ),
                              ),
                            );
                          },
                          child: AppText(
                            text: "Book Now",
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: AppText(text: "Experience not found")),
    );
  }
}
