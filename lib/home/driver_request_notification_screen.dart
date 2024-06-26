import 'package:cargo_driver_app/api/user_repo.dart';

import 'package:cargo_driver_app/home/controller/ridetrcaking_controller.dart';
import 'package:firebase_messaging_platform_interface/src/remote_message.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constant/colors_utils.dart';

import '../../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'bottom_navbar.dart';

class DriverRequestNotificationScreen extends StatelessWidget {
  const DriverRequestNotificationScreen({
    super.key,
    RemoteMessage? message,
  });

// "AIzaSyDdwlGhZKKQqYyw9f9iME40MzMgC9RL4ko",
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RideTrackingController(userRepo: UserRepo()),
        builder: (controller) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    const Color(0xff113946),
                    const Color(0xff113946).withOpacity(0.01),
                  ],
                ),
              ),
              child: Scaffold(
                  bottomSheet: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CustomButton(
                        buttonText: "Proceed",
                        onPress: () {
                          controller.createHistory(isStart: '1', isEnd: '0');
                          // controller.setParcelLocationToCurrent();
                          //   Get.to(() => const BottomBarScreen());
                        }),
                  ),
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50.h),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                    )),
                                GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: Container(
                                foregroundDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.center,
                                    colors: [
                                      bgColor,
                                      bgColor.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                                child: GetBuilder(
                                    init: RideTrackingController(
                                        userRepo: UserRepo()),
                                    builder: (controller) {
                                      return GoogleMap(
                                        markers: controller.markers,
                                        polylines: controller.polylines,
                                        compassEnabled: false,
                                        onCameraMove: controller.onCameraMove,
                                        initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                controller.latitude.value,
                                                controller.longitude.value),
                                            zoom: 14),
                                        onMapCreated: controller.onCreated,
                                        onCameraIdle: () async {},
                                      );
                                    })),
                          )
                        ],
                      ),
                      controller.isParcelLocationReached.value == true
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.1),
                              // Margin adjusted for mobile devices
                              height: MediaQuery.of(context).size.height * 0.4,
                              // Height adjusted for mobile devices
                              width: MediaQuery.of(context).size.width * 0.8,
                              // Width adjusted for mobile devices
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Have you received the parcel?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              // Height adjusted for mobile devices
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // Handle accept action
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .grey, // Set the button color here
                                                ),
                                                child: Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          // Width adjusted for mobile devices
                                          Expanded(
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              // Height adjusted for mobile devices
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Handle reject action
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .blueGrey, // Set the button color here
                                                ),
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  )));
        });
  }
}
