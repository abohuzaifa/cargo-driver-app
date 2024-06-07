import 'dart:developer';

import 'package:cargo_driver_app/api/auth_controller.dart';
import 'package:cargo_driver_app/widgets/contact_field.dart';
import '../../auth_screen/login_screen.dart';
import '../../constant/colors_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _nameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _phoneController = TextEditingController(),
      _emailController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _addressController = TextEditingController(),
      _drivingLicenseController = TextEditingController(),
      _accountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _code = Rx<String>('+996');
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 3) {
                              return 'Enter valid name';
                            }
                            return null;
                          },
                          controller: _nameController,
                          maxLines: 1,
                          hintText: "Full Name",
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 3) {
                              return 'Enter valid address';
                            }
                            return null;
                          },
                          controller: _addressController,
                          maxLines: 1,
                          hintText: "Address",
                        ),
                        SizedBox(height: 20.h),
                        DropdownButtonFormField<String>(
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
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
                                .map((e) => DropdownMenuItem<String>(
                                    value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) {}),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 6) {
                              return 'Enter valid license';
                            }
                            return null;
                          },
                          controller: _drivingLicenseController,
                          maxLines: 1,
                          hintText: "Driving License",
                        ),
                        SizedBox(height: 20.h),
                        DropdownButtonFormField<String>(
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
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
                                .map((e) => DropdownMenuItem<String>(
                                    value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) {}),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 10) {
                              return 'Enter valid account';
                            }
                            return null;
                          },
                          controller: _accountController,
                          maxLines: 1,
                          hintText: "Bank Account",
                        ),
                        SizedBox(height: 20.h),
                        ContactField(
                          onChanged: (p0) {
                            _code(p0.toString());
                            log(_code.toString());
                          },
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 9) {
                              return 'Enter valid phone without country code';
                            }
                            return null;
                          },
                          controller: _phoneController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || !p0.contains('@')) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                          controller: _emailController,
                          maxLines: 1,
                          hintText: "Email",
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 6) {
                              return 'Enter valid password minimum 6 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          hintText: "Password",
                          maxLines: 1,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0 != _passwordController.text) {
                              return 'password don\'t match';
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          obscureText: true,
                          hintText: "Confirm Password",
                          maxLines: 1,
                        ),
                        SizedBox(height: 55.h),
                        CustomButton(
                            buttonText: "Next",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                Get.find<AuthController>().registerUser(
                                    confirmPass:
                                        _confirmPasswordController.text,
                                    drivingLicence:
                                        _drivingLicenseController.text,
                                    vehicleType: 1,
                                    bankAccount: _accountController.text,
                                    bankId: 2,
                                    address: _addressController.text,
                                    fullName: _nameController.text,
                                    mobileNumber:
                                        _code.value + _phoneController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text);
                              }
                            }),
                      ],
                    )),
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
