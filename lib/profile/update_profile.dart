import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:cargo_driver_app/home/controller/user_controler.dart';
import 'package:cargo_driver_app/profile/controller/profile_controller.dart';

import '../../widgets/back_button_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constant/colors_utils.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<ProfileController>(
        init: ProfileController(userRepo: UserRepo()),
        builder: (controller) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0.5, 0.5),
              colors: [
                bgColor,
                bgColor.withOpacity(0.1),
                bgColor.withOpacity(0.1),
                bgColor.withOpacity(0.1)
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.h),
                child: buildBackButton(context, onTap: Get.back),
              ),
              CircleAvatar(
                backgroundColor: textBrownColor,
                radius: 80,
                child: Image.asset('assets/images/profile.png'),
              ),
              SizedBox(
                height: 30.h,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
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
                            controller: controller.nameController,
                            hintText: 'Abdullah',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextField(
                            validator: (p0) {
                              if (p0!.isEmpty || p0.length < 3) {
                                return 'Enter valid address';
                              }
                              return null;
                            },
                            controller: controller.addressController,
                            hintText: 'Address',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextField(
                            validator: (p0) {
                              if (p0!.isEmpty || p0.length < 9) {
                                return 'Enter valid phone';
                              }
                              return null;
                            },
                            controller: controller.phoneController,
                            hintText: 'Phone Number',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextField(
                            validator: (p0) {
                              if (!p0!.isEmail || p0.length < 5) {
                                return 'Enter valid email';
                              }
                              return null;
                            },
                            controller: controller.emailController,
                            hintText: 'Email',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextField(
                            // validator: (p0) {
                            //   if (p0!.isEmpty || p0.length < 6) {
                            //     return 'Enter valid password';
                            //   }
                            //   return null;
                            // },
                            controller: controller.passwordController,
                            hintText: 'Password',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextField(
                            // validator: (p0) {
                            //   if (p0!.isEmpty ||
                            //       p0 != controller.passwordController.text) {
                            //     return 'password don\'t match';
                            //   }
                            //   return null;
                            // },
                            controller: controller.confirmPassController,
                            hintText: 'Confirm Password',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0.h),
                child: CustomButton(
                    buttonText: 'Update',
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        Get.find<UserContorller>().updateUserInfo(
                            mobile: controller.phoneController.text,
                            name: controller.nameController.text,
                            email: controller.emailController.text,
                            streetAddress: controller.addressController.text,
                            city: '',
                            state: '',
                            postalCode: '',
                            lat: '12.900',
                            long: '-123.889');
                      }
                    }),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
