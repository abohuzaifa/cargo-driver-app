import '../../auth_screen/login_screen.dart';
import '../../auth_screen/otp_screen.dart';
import '../../constant/colors_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [bgColor, bgColor.withOpacity(0.01)])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
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
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: textcyanColor),
                ),
                SizedBox(height: 90.h),
                CustomTextField(
                  controller: nameController,
                  maxLines: 1,
                  hintText: "Full Name",
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: nameController,
                  maxLines: 1,
                  hintText: "Address",
                ),
                SizedBox(height: 20.h),
                DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 16.0, left: 15, right: 15),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13)),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13))),
                    hint: const Text('Vehicle Type'),
                    value: null,
                    items: ['Car', 'Bike', 'Truk']
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {}),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: nameController,
                  maxLines: 1,
                  hintText: "Driving License",
                ),
                SizedBox(height: 20.h),
                DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 16.0, left: 15, right: 15),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13)),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13))),
                    hint: const Text('Select Bank'),
                    value: null,
                    items: ['Samba', 'AlSaud', 'National']
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {}),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: nameController,
                  maxLines: 1,
                  hintText: "Bank Account",
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: phoneController,
                  maxLines: 1,
                  hintText: "Phone",
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: emailController,
                  maxLines: 1,
                  hintText: "Email",
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                  maxLines: 1,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirm Password",
                  maxLines: 1,
                ),
                SizedBox(height: 55.h),
                CustomButton(
                    buttonText: "Next",
                    onPress: () {
                      Get.to(() => const OtpScreen());
                    }),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have Account? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff113946)),
                    ),
                    InkWell(
                      onTap: () => Get.to(() => LoginScreen()),
                      child: Text(
                        "Log In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: textBrownColor),
                      ),
                    ),
                  ],
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
