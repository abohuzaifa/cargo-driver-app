import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:cargo_driver_app/widgets/custom_button.dart';
import 'package:cargo_driver_app/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddTripPage extends StatelessWidget {
  const AddTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [bgColor, bgColor.withOpacity(0.01)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBackButton(context, isAction: true, onTap: Get.back),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.h),
              child: const Text('Add Your Trip'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'From',
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'To',
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Date',
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Time',
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomButton(
                    buttonText: 'Submit',
                    onPress: () {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
