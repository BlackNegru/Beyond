import 'package:flutter/material.dart';

import '../misc/colors.dart';
import '../widgets/app_largetext.dart';
import '../widgets/app_text.dart';
import '../widgets/responsive_button.dart';
import 'login_page.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    List images = [
      "welcome-one.png",
      "welcome-two.png",
      "welcome-three.png",
      "welcome-four.png"
    ];

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (_, index) {
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("img/" + images[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Title with Background Color and Border
                      Container(
                        padding: EdgeInsets.all(5),  // Padding inside the border
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppLargeText(
                          text: "BEYOND",
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Subtitle with Background Color and Border
                      Container(
                        padding: EdgeInsets.all(5),  // Padding inside the border
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppText(
                          text: "Views",
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      // Description Text with Background Color and Border
                      Container(
                        width: 250,
                        padding: EdgeInsets.all(5),  // Padding inside the border
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppText(
                          text: "Travelling anywhere, Travel without concerns",
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      SizedBox(height: 40),
                      ResponsiveButton(
                        width: 120,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: List.generate(4, (indexDots) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 4),
                        width: 8,
                        height: index == indexDots ? 25 : 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: index == indexDots
                              ? AppColors.mainColor
                              : AppColors.mainColor,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
