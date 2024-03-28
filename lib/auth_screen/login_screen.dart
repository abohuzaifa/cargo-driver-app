import '../../auth_screen/forgot_password.dart';
import '../../auth_screen/register_screen.dart';
import '../../constant/colors_utils.dart';
import '../../home/confirm_location_screen.dart';
import '../../widgets/contact_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [bgColor, bgColor.withOpacity(0.01)]),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: Colors.white,
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    "Hello Again!",
                    style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: textcyanColor),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    "Fill Your Details or Continue with\n Social media",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: textcyanColor),
                  ),
                ),
                SizedBox(height: 100.h),
                Text(
                  "Mobile Number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: textBrownColor),
                ),
                SizedBox(height: 10.h),
                const ContactField(),
                SizedBox(height: 25.h),
                Text(
                  "Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: textBrownColor),
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  maxLines: 1,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    child: Text(
                      'ForgotPassword?',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: textBrownColor,
                          decorationColor: textBrownColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                CustomButton(
                    buttonText: "Login",
                    onPress: () {
                      Get.offAll(() => const LocationPage());
                    }),
                SizedBox(height: 45.h),
                InkWell(
                  onTap: () {
                    Get.to(() => RegisterScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New User?  ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: textBrownColor),
                      ),
                      Text(
                        "Create Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff113946)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
