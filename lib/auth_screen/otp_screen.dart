import '../../constant/colors_utils.dart';
import '../../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [bgColor, backGroundColor])),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: lightBrownColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text(
                        "OTP Verification",
                        style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: textcyanColor),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                        child: Text(
                      "Please Check Your Mobile \nto See The Verification Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: textcyanColor),
                    )),
                    SizedBox(height: 120.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "OTP Code",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: textBrownColor),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Pinput(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      length: 6,
                    ),
                    SizedBox(height: 40.h),
                    CustomButton(buttonText: "Verify", onPress: () {}),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Resend code",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff113946)),
                        ),
                        Text(
                          "00:35",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff113946)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
