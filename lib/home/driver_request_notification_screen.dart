import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../api/user_repo.dart';
import '../main.dart';
import '../widgets/custom_button.dart';
import 'controller/ridetrcaking_controller.dart';

class DriverRequestNotificationScreen extends StatefulWidget {
  const DriverRequestNotificationScreen({
    Key? key,
    this.message,
  }) : super(key: key);

  final RemoteMessage? message;

  @override
  _DriverRequestNotificationScreenState createState() =>
      _DriverRequestNotificationScreenState();
}

class _DriverRequestNotificationScreenState
    extends State<DriverRequestNotificationScreen> {
  late RideTrackingController controller;
  final StreamController<RemoteMessage?> _messageStreamController =
      StreamController<RemoteMessage?>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(RideTrackingController(userRepo: UserRepo()));
  }

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideTrackingController>(
      init: controller,
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
                child: controller.isOfferAccepted.value == true
                    ? CustomButton(
                        buttonText: "Proceed",
                        onPress: () {
                          controller.createHistory(isStart: '1', isEnd: '0');
                          controller.startLocationCheckIfNearByHundredMeters();
                          // Get.to(() => const BottomBarScreen());
                        },
                      )
                    : Text(
                        'Waiting for User to accpet your Offer',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      )),
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
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
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
                              const Color(0xff113946),
                              const Color(0xff113946).withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: GetBuilder<RideTrackingController>(
                          init: controller,
                          builder: (controller) {
                            return GoogleMap(
                              markers: controller.markers,
                              polylines: controller.polylines,
                              compassEnabled: false,
                              onCameraMove: controller.onCameraMove,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(controller.latitude.value,
                                    controller.longitude.value),
                                zoom: 14,
                              ),
                              onMapCreated: controller.onCreated,
                              onCameraIdle: () async {},
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                controller.isParcelLocationReached.value
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
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
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // Handle yes action
                                            setPreferences();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                          ),
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle reject action
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: Text(
                                            'No',
                                            style:
                                                TextStyle(color: Colors.white),
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
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
