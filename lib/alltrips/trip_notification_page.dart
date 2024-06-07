import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:cargo_driver_app/widgets/build_dialog.dart';
import 'package:cargo_driver_app/widgets/custom_button.dart';
import 'package:cargo_driver_app/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../home/bottom_navbar.dart';

class NewTripNotificationPage extends StatelessWidget {
  const NewTripNotificationPage({super.key});

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
          children: [
            buildBackButton(context, isAction: true),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('User Accepted Your Request'),
                  SizedBox(
                    height: 50.h,
                  ),
                  const Text(
                      'You Receive a  Delivery Order\n  details are bellow:'),
                  SizedBox(
                    height: 30.h,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Text('From Madina To Al-Ryadh '),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Add Rate',
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomButton(
                      buttonText: 'Submit',
                      onPress: () {
                        buildDialog(
                            onPress1: () =>
                                Get.to(() => const BottomBarScreen()),
                            onPress2: () =>
                                Get.to(() => const BottomBarScreen()),
                            btntext1: 'Accept',
                            btntext2: 'Reject',
                            btnColor1: bgColor,
                            btnColor2: textBrownColor,
                            width: 80,
                            height: 40,
                            title: 'Receive New Order',
                            subtitle:
                                'You receive new order please response your delivery order');
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
