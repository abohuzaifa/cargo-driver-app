import 'dart:async';
import 'dart:ui';
import 'package:cargo_driver_app/models/current_ride_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/user_repo.dart';
import '../main.dart';
import '../widgets/custom_button.dart';
import 'bottom_navbar.dart';
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
  RideTrackingController controller =
      RideTrackingController(userRepo: UserRepo());
  final StreamController<RemoteMessage?> _messageStreamController =
      StreamController<RemoteMessage?>();
  late GoogleMapController mapController;
  LatLng? currentLocation;
  final double radiusInMeters = 1000;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(33.6943, 72.9743), zoom: 14);
  List<Marker> _markers = [];
  Set<Circle> _circles = {};
  Position? _currentPosition;
  RxBool acceptOffer = false.obs;
  RxBool parcelReceived = false.obs;
  RxBool isRideStarted = false.obs;
  var parcelLat;
  var parcelLong;
  var receiverLat;
  var receiverLong;
  Position? currentPosition; // Variable to store the latest position
  late Timer _locationTimer;
  RxBool isInternetConnected = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RideTrackingController(userRepo: UserRepo()));
    _initializeState();
    _startLocationUpdates();
  }

  Future<void> _initializeState() async {
    await _getCurrentLocation();
    // No need to refresh here, GetX will automatically handle the state update
  }

  Future<void> _getCurrentLocation() async {
    print(
        'controller!.isReceiverLocationReached.value ======${controller.isReceiverLocationReached.value}');
    if (controller.isReceiverLocationReached.value == false) {
      if (!mounted) return; // Check if the widget is still mounted

      // Check internet connectivity
      List<ConnectivityResult> connectivityResults =
          await Connectivity().checkConnectivity();
      print('Connectivity Results: $connectivityResults'); // Debug print

      // Check for specific types of connectivity
      bool isConnected =
          connectivityResults.contains(ConnectivityResult.mobile) ||
              connectivityResults.contains(ConnectivityResult.wifi) ||
              connectivityResults.contains(ConnectivityResult.ethernet) ||
              connectivityResults.contains(ConnectivityResult.vpn) ||
              connectivityResults.contains(ConnectivityResult.bluetooth) ||
              connectivityResults.contains(ConnectivityResult.other);

      print('Is Connected: $isConnected'); // Debug print
      Position position;
      if (isConnected) {
        print('In isConnected');
        isInternetConnected.value = true;
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } else {
        print('In NotConnected');
        isInternetConnected.value = false;
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      acceptOffer.value = prefs.getBool('acceptOffer') ?? false;
      isRideStarted.value = prefs.getBool('isRideStarted') ?? false;
      print('acceptOffer.value===${acceptOffer.value}');
      print('isRideStarted.value===${isRideStarted.value}');

      parcelLat = prefs.getString('parcel_lat');
      parcelLong = prefs.getString('parcel_long');
      receiverLat = prefs.getString('receiver_lat');
      receiverLong = prefs.getString('receiver_long');

      print('Parcel Latitude: $parcelLat');
      print('Parcel Longitude: $parcelLong');
      print('Receiver Latitude: $receiverLat');
      print('Receiver Longitude: $receiverLong');
      double? parcelLat1 = double.tryParse(parcelLat ?? '');
      double? parcelLong1 = double.tryParse(parcelLong ?? '');
      double? receiverLat1 = double.tryParse(receiverLat ?? '');
      double? receiverLong1 = double.tryParse(receiverLong ?? '');

      LatLng sourceLocation = LatLng(parcelLat1!, parcelLong1!);
      LatLng destinationLocation = LatLng(receiverLat1!, receiverLong1!);
      // userLatitude.value = destinationLocation.latitude;
      // userLongitude.value = destinationLocation.longitude;

      // Print source and destination locations
      print('Source Location: $sourceLocation');
      print('Destination Location: $destinationLocation');

      // Load custom marker icon
      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            icon: controller!.driverIcon,
          ),
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('source_location'),
            position: LatLng(sourceLocation.latitude, sourceLocation.longitude),
            icon: controller!.sourceIcon,
          ),
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('destination_location'),
            position: LatLng(
                destinationLocation.latitude, destinationLocation.longitude),
            icon: controller!.destinationIcon,
          ),
        );

        _circles.add(
          Circle(
            circleId: const CircleId('current_location_circle'),
            center: LatLng(position.latitude, position.longitude),
            radius: 1000,
            // Radius in meters
            fillColor: Colors.blue.withOpacity(0.5),
            strokeColor: Colors.blue,
            strokeWidth: 1,
          ),
        );
      });

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (controller!.isReceiverLocationReached.value == false) {
        _getCurrentLocation();
      }
    });
  }

  Future<void> _animateToCurrentLocation() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 14,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageStreamController.close();
    _locationTimer.cancel(); // Cancel the timer when the widget is disposed
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
                  child: controller.isRideStarted.value == true ||
                          isRideStarted.value == true
                      ? Container(child: const Text('Ride Started'))
                      : Obx(
                          () => acceptOffer.value == true
                              ? CustomButton(
                                  buttonText: "Proceed",
                                  onPress: () {
                                    setPreferencesForProceed();
                                    // controller.setParcelLocationToCurrent();
                                    controller.createHistory(
                                        isProceed: '1',
                                        isStart: '1',
                                        isEnd: '0');
                                  },
                                )
                              : Text(
                                  'Waiting for User to accept your Offer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            color: isInternetConnected.value == true
                                ? Colors.black
                                : Colors.red),
                        child: Center(
                            child: isInternetConnected.value == true
                                ? Text(
                                    'Connected to Internet',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )
                                : Text(
                                    'Not Connected to Internet',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )),
                      ),
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
                                markers: Set<Marker>.of(_markers),
                                circles: _circles,
                                polylines: controller.polylines,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                initialCameraPosition: initialCameraPosition,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  controller.isParcelLocationReached.value &&
                          parcelReceived.value == false
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // Handle yes action
                                              await setPreferencesForParcelCollected();
                                              parcelReceived.value = true;
                                              controller.createHistory(
                                                  isProceed: '0',
                                                  isStart: '0',
                                                  isEnd: '0');
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Handle reject action
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueGrey,
                                            ),
                                            child: Text(
                                              'Waiting',
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
                      : Container(),
                  Obx(
                    () => controller.isReceiverLocationReached.value
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: controller.cashOnDelivery.value == true
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Request Status Successfully Updated',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign
                                              .center, // Align text to the center
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Image.asset(
                                        'assets/images/checkMark.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add your onPressed code here!
                                          controller.cashOnDelivery.value =
                                              false;
                                          controller.isReceiverLocationReached
                                              .value = false;
                                          controller.isReceiverLocationReached
                                              .value = false;
                                          Get.offAll(const BottomBarScreen());
                                        },
                                        child: const Text(
                                          'Back to Home',
                                          textAlign: TextAlign.center,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                        ),
                                      )
                                    ],
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Have you reached the destination?',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          // Handle yes action
                                                          if (controller
                                                              .codeController
                                                              .text
                                                              .isEmpty) {
                                                            Get.snackbar(
                                                                'Alert',
                                                                'Please Enter Code',
                                                                backgroundColor:
                                                                    Colors.red);
                                                          } else {
                                                            controller.message
                                                                .value = '';

                                                            await controller
                                                                .markCompleteRequest(
                                                                    code: controller
                                                                        .codeController
                                                                        .text);
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.grey,
                                                        ),
                                                        child: Text('Yes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          // Handle reject action
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                        ),
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Text(
                                                'Enter Code',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            controller.isLoading.value == true
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.blueGrey,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 100,
                                                    width: 200,
                                                    child: TextField(
                                                      controller: controller
                                                          .codeController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                      maxLines: 1,
                                                      // Allow multiple lines if needed
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      // Show the done button
                                                      onSubmitted:
                                                          (String value) {
                                                        // Close the keyboard when text input is complete
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                    ),
                                                  ),
                                            controller.message.value ==
                                                    'Code does not match'
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                    child: Text(
                                                      controller.message.value,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          )
                        : Container(),
                  ),
                  Obx(() => controller.message.value ==
                          'Did you received payment, If received then press YES Or NOT'
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
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'Have you received the payment?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Column(
                                  children: [
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
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // Handle yes action
                                                  controller
                                                      .updatePaymentStatus();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey,
                                                ),
                                                child: controller
                                                            .isLoading.value ==
                                                        true
                                                    ? Container(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color:
                                                              Colors.blueGrey,
                                                        ))
                                                    : const Text('Yes',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          Expanded(
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Handle reject action
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text(
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
                              ],
                            ),
                          ),
                        )
                      : Container())
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _animateToCurrentLocation,
                child: Icon(Icons.my_location),
              ),
            ));
      },
    );
  }
}
