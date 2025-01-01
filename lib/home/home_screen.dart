import 'package:cargo_driver_app/alltrips/find_trip_page.dart';
import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:cargo_driver_app/home/controller/user_controler.dart';
import '../../constant/colors_utils.dart';
import '../alltrips/add_trip/add_trip_view.dart';
import 'driver_request_notification_screen.dart';
import 'find_trip_online.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: GetX<UserContorller>(
          init: UserContorller(userRepo: UserRepo()),
          builder: (contoroller) {
            return Scaffold(
                body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [bgColor, bgColor.withOpacity(0.01)])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.backspace_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          3,
                          (index) => Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 10),
                                // height: 156.h,
                                width: 327.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Earn More Money with Tarrud".tr,
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                          color: textBrownColor),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => FindTripOnline());
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 36.h,
                                              width: 103.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                "Online".tr,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Image.asset(
                                            "assets/images/redTruk.png",
                                            height: 72.h,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        growable: false,
                        contoroller.currenTRideModel.value?.data?.length ?? 0,
                        (index) => Center(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            height: 156.h,
                            width: 327.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff667F91),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Current Ride".tr,
                                          style: TextStyle(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                              color: textBrownColor),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          "ID: ${contoroller.currenTRideModel.value?.data?[index].id}",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          // Get.to(() => FindTripOnline());
                                          Get.to(()=>DriverRequestNotificationScreen());
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 36.h,
                                            width: 102.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff9DADB8),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                              "Track".tr,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 12.h,
                                      width: 12.w,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1.h,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff4F4956)),
                                      ),
                                    ),
                                    Container(
                                      height: 12.h,
                                      width: 12.w,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1.h,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff4F4956)),
                                      ),
                                    ),
                                    Container(
                                      height: 12.h,
                                      width: 12.w,
                                      decoration: BoxDecoration(
                                          color: textBrownColor,
                                          shape: BoxShape.circle),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1.h,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff4F4956)),
                                      ),
                                    ),
                                    Container(
                                      height: 12.h,
                                      width: 12.w,
                                      decoration: BoxDecoration(
                                          color: textBrownColor,
                                          shape: BoxShape.circle),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        maxLines: 1,
                                        "${contoroller.currenTRideModel.value?.data?[index].request?.parcelAddress}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      child: Text(
                                        maxLines: 1,
                                        "${contoroller.currenTRideModel.value?.data?[index].request?.receiverAddress}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: textcyanColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                           Text('ADD YOUR TRIP'.tr),
                          InkWell(
                            onTap: () => Get.to(() => AddTripView()),
                            child: Container(
                              padding: EdgeInsets.all(20.h),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.white)]),
                              child: Image.asset('assets/images/addtrip.png'),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                           Text('FIND YOUR TRIP'.tr),
                          InkWell(
                            onTap: () => Get.to(() => FindTripPage()),
                            child: Container(
                              padding: EdgeInsets.all(20.h),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.white)]),
                              child: Image.asset('assets/images/findtrip.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(20.h),
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        colors: [textcyanColor, textcyanColor.withOpacity(0.5)],
                      ),
                    ),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(text: 'SAR '),
                            TextSpan(
                                text: contoroller.walletData.value?.earnings
                                        .toString() ??
                                    '',
                                style: TextStyle(
                                    fontSize: 20.sp, color: Colors.white))
                          ]),
                        ),
                         Text(
                          'Total Earning'.tr,
                          style: TextStyle(color: Color(0xff9DADB8)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text('Current Earning'.tr,
                                style: TextStyle(color: Color(0xff9DADB8))),
                            Text(
                                'SAR ${contoroller.walletData.value?.currentEarning?.amount ?? ''}',
                                style: const TextStyle(color: Colors.white))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              'Total Withdrawl'.tr,
                              style: TextStyle(color: Color(0xff9DADB8)),
                            ),
                            Text(
                              'SAR ${contoroller.walletData.value?.withdral ?? ''}',
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
          }),
    );
  }
}
