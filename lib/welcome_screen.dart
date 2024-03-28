import '../../auth_screen/login_screen.dart';
import '../../constant/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            bgColor,
            bgColor.withOpacity(0.01),
          ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "طرد دریفر",
              style: TextStyle(
                  fontSize: 50.sp,
                  fontFamily: 'RadioCanada',
                  color: textcyanColor,
                  fontWeight: FontWeight.w600),
            ),
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
    );
  }
}
