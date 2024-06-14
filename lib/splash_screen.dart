
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant/colors_utils.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({super.key, required this.onInitializationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), () {
        widget.onInitializationComplete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              bgColor,
              bgColor.withOpacity(0.01),
            ],
          ),
        ),
        child: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundColor: bgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'طرد دریفر',
                  style: TextStyle(
                    fontFamily: 'RadioCanada',
                    fontSize: 50,
                    color: textcyanColor,
                  ),
                ),
                Text(
                  'Tarud Driver',
                  style: TextStyle(color: textcyanColor, fontSize: 22.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}