import 'dart:developer';

import 'package:cargo_driver_app/api/auth_controller.dart';
import 'package:cargo_driver_app/main.dart';

import '../../auth_screen/forgot_password.dart';
import '../../auth_screen/register_screen.dart';
import '../../constant/colors_utils.dart';

import '../../widgets/contact_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final passwordController = TextEditingController(),
      _phoneConteroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _code = Rx<String>('+996');

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
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
                  ContactField(
                    validator: (p0) {
                      if (p0!.isEmpty || p0.length < 9) {
                        return 'Enter valid phone mumber without country code';
                      }
                      return null;
                    },
                    controller: _phoneConteroller,
                    onChanged: (p0) {
                      _code(p0.toString());
                      log(_code.toString());
                    },
                  ),
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
                    validator: (p0) {
                      if (p0!.isEmpty || p0.length < 6) {
                        return 'Enter valid Password';
                      }
                      return null;
                    },
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
                        if (_formKey.currentState!.validate()) {
                          Get.find<AuthController>().login(
                            userType: '2',
                              fcmToken: fcmToken!,
                              password: passwordController.text,
                              mobileNumber:
                                  _code.value + _phoneConteroller.text);
                        }
                        return;
                        // Get.offAll(() => const LocationPage());
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
      ),
    );
  }
}
