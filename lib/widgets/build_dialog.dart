import '../../constant/colors_utils.dart';
import '../../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

buildDialog({
  bool? isDelete,
  String? title,
  String? subtitle,
  String? btntext1,
  String? btntext2,
  double? width,
  double? height,
  Color? btnColor1,
  Color? btnColor2,
  Function()? onPress1,
  final Function()? onPress2,
}) {
  return showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
            contentPadding: EdgeInsets.all(16.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            titleTextStyle: TextStyle(
                fontSize: 14.sp,
                color: isDelete == true ? Colors.red : textBrownColor),
            backgroundColor: Colors.white,
            title: Center(child: Text(title ?? '')),
            content: Text(
              '$subtitle',
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonColor: btnColor1,
                    borderRadius: 8,
                    height: height,
                    width: width,
                    buttonText: btntext1 ?? '',
                    onPress: onPress1!,
                  ),
                  CustomButton(
                    buttonColor: btnColor2,
                    borderRadius: 8,
                    height: height,
                    width: width,
                    buttonText: btntext2 ?? '',
                    onPress: onPress2!,
                  )
                ],
              ),
            ],
          ));
}
