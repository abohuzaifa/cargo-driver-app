import '../../auth_screen/login_screen.dart';
import '../../constant/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              bgColor,
              bgColor.withOpacity(0.01),
            ]),
          ),
          child: Column(
            children: [
              // Language selection buttons at the top
              Container(
                margin: EdgeInsets.only(top: 30, right: 20), // Top margin of 30
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Change language to English
                        changeLanguage('en');
                        Get.offAll(LoginScreen());
                      },
                      child: Text("en"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Change language to Arabic
                        changeLanguage('ar');
                        Get.offAll(LoginScreen());
                      },
                      child: Text("عربى"),
                    ),
                  ],
                ),
              ),
        
              // Center the text content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Arabic text centered
                    Text(
                      "طرد دریفر",
                      style: TextStyle(
                          fontSize: 50.sp,
                          fontFamily: 'RadioCanada',
                          color: textcyanColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20), // Space between Arabic and Welcome text
        
                    // Welcome text centered
                    InkWell(
                      onTap: () {
                        Get.to(() => LoginScreen());
                      },
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 31.sp,
                            fontFamily: 'RadioCanada',
                            color: textcyanColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
