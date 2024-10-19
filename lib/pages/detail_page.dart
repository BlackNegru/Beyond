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
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchExperienceDetails();
  }

  Future<void> _fetchExperienceDetails() async {
    final String url = 'http://192.168.0.105:5000/experience/${widget.experienceId}';

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
    final String url = 'https://www.google.com/maps/place/${experienceDetails!['location']}'; // Dynamic link
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
                      image: MemoryImage(base64Decode(experienceDetails!['images'][0])),
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
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      SizedBox(height: 20),
                      // Star rating
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: (experienceDetails!['rating'] > index)
                                    ? AppColors.starColor
                                    : AppColors.textColor2,
                              );
                            }),
                          ),
                          SizedBox(width: 10),
                          AppText(
                            text: "${experienceDetails!['rating']}",
                            color: AppColors.textColor2,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // People selection
                      AppLargeText(
                        text: "People",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(height: 5),
                      AppText(
                        text: "Number of people in your group",
                        color: AppColors.mainTextColor,
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: AppButtons(
                                size: 50,
                                color: selectedIndex == index ? Colors.white : Colors.black,
                                backgroundcolor: selectedIndex == index ? Colors.black : AppColors.buttonBackground,
                                bordercolor: selectedIndex == index ? Colors.black : AppColors.buttonBackground,
                                text: (index + 1).toString(),
                              ),
                            ),
                          );
                        }),
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
                              color: selectedDate == null ? AppColors.textColor2 : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButtons(
                            color: AppColors.textColor1,
                            backgroundcolor: Colors.white,
                            bordercolor: AppColors.textColor1,
                            size: 60,
                            text: "Cancel",
                          ),
                          ResponsiveButton(
                            isResponsive: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: Text("Experience not found")),
    );
  }
}
