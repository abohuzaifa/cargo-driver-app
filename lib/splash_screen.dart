import 'dart:async';
import '../../constant/colors_utils.dart';
import '../../welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => const WelcomeScreen());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          bgColor,
          bgColor.withOpacity(0.01),
        ])),
        child: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundColor: bgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'طرد دریفر',
                  style: TextStyle(fontFamily: 'RadioCanada'),
                ),
                Text(
                  'Tarud Driver',
                  style: TextStyle(color: Colors.white, fontSize: 22.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
