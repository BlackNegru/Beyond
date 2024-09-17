import 'package:flutter/material.dart';

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
  int selectedIndex=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Search", color: Colors.white, size: 32),
        elevation: 0,
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                child: Container(
                  width: double.maxFinite,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("img/mountain.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Positioned(
                left: 20,
                top: 50,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu_rounded),
                        color: Colors.white)
                  ],
                )),
            Positioned(
                top: 320,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      )),
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.mainColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          AppLargeText(
                            text: "USA California",
                            color: AppColors.textColor1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      AppLargeText(
                        text: "People",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AppText(
                        text: "Number of people in your group",
                        color: AppColors.mainTextColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                          children: List.generate(5, (index) {
                            return InkWell(
                              onTap:(){
                                setState(() {
                                  selectedIndex=index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right:10),
                                child: AppButtons(
                                  size: 50,
                                  color: selectedIndex==index?Colors.white:Colors.black,
                                  backgroundcolor: selectedIndex==index?Colors.black:AppColors.buttonBackground,
                                  bordercolor: selectedIndex==index?Colors.black:AppColors.buttonBackground,
                                  text: (index+1).toString(),
                                ),
                              ),
                            );
                            },
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppLargeText(text: "Description",color: Colors.black.withOpacity(0.8),size: 20,),
                      SizedBox(
                        height: 10,
                      ),
                      AppText(text: "You must go for a travel fkjf fgkas fgf dfhbds fsdkbf sdbh sdfhsdf hsdjfh sdjhvsd fjhsdf sdhfb sdfjh",color: AppColors.mainTextColor,),

                    ],
                  ),
                )),
            Positioned(
              bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    AppButtons(
                      size: 60,
                      color: AppColors.textColor2,
                      backgroundcolor: Colors.white,
                      bordercolor: AppColors.textColor1,
                      isIcon: true,
                      icon: Icons.favorite_border,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ResponsiveButton(
                      isResponsive: true,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
