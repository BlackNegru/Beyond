import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import '../misc/colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_largetext.dart';
import '../widgets/app_text.dart';
import '../widgets/responsive_button.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int gottenStars = 3;
  int selectedIndex = 1;
  String bookingStatus = "Not Booked"; // Example status, will come from the backend later
  DateTime? selectedDate;

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

  String getStatusText(String status) {
    switch (status) {
      case 'Not Booked':
        return "Not Booked";
      case 'Pending':
        return "Pending";
      case 'Booked':
        return "Booked";
      default:
        return "Unknown";
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Only future dates
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showImageGallery() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Image Gallery", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 6, // Placeholder, this will be dynamic
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("img/mountain.jpeg"), // Change this to dynamic images later
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openGoogleMaps() async {
    const url = 'https://www.google.com/maps/place/Yosemite+National+Park'; // Static link for now
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            // Image area, made smaller
            Positioned(
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showImageGallery,
                child: Container(
                  width: double.maxFinite,
                  height: 300, // Made smaller
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("img/mountain.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Scrollable content below the image
            Positioned(
              top: 260, // Adjusted to match the smaller image height
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 260, // Scrollable area
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
                            text: "Yosemite",
                            color: Colors.black.withOpacity(0.7),
                          ),
                          AppLargeText(
                            text: "\$ 250",
                            color: AppColors.mainColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Floating location button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: AppColors.mainColor),
                              SizedBox(width: 5),
                              AppLargeText(
                                text: "USA California",
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
                                  Icon(Icons.location_on, color: AppColors.mainColor, size: 15),
                                  SizedBox(width: 5),
                                  AppText(
                                    text: "View on Maps",
                                    color: Colors.black,
                                    size: 16, // Increased size for visibility
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Floating Status Widget aligned to the left and resized
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: getStatusColor(bookingStatus),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AppLargeText(
                          text: getStatusText(bookingStatus),
                          color: Colors.white,
                          size: 14, // Reduced size of the status text
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index) {
                              return Icon(Icons.star,
                                  color: gottenStars > index
                                      ? AppColors.starColor
                                      : AppColors.textColor2);
                            }),
                          ),
                          SizedBox(width: 10),
                          AppText(
                            text: "4.0",
                            color: AppColors.textColor2,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
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
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                backgroundcolor: selectedIndex == index
                                    ? Colors.black
                                    : AppColors.buttonBackground,
                                bordercolor: selectedIndex == index
                                    ? Colors.black
                                    : AppColors.buttonBackground,
                                text: (index + 1).toString(),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      AppLargeText(
                        text: "Description",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(height: 10),
                      AppText(
                        text:
                        "You must go for a travel fkjf fgkas fgf dfhbds fsdkbf sdbh sdfhsdf hsdjfh sdjhvsd fjhsdf sdhfb sdfjh",
                        color: AppColors.mainTextColor,
                      ),
                      SizedBox(height: 20),
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
      ),
    );
  }
}
