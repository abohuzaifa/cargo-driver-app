import 'dart:async';
import 'dart:convert';
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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_controller.dart';
import '../api/user_repo.dart';
import '../main.dart';
import '../models/MDGetRequestData.dart';
import '../widgets/custom_button.dart';
import 'bottom_navbar.dart';
import 'controller/ridetrcaking_controller.dart';
import 'package:http/http.dart' as http;

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
  MDGetRequestData? mdGetRequestData;
  String? formattedDate;

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
  RxBool _isLoading = false.obs;

  Future<void> getRequestData() async {
    _isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var requestId = await prefs.getString('request_id');
    const String apiUrl = 'https://thardi.com/api/getRequest';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization":
              "Bearer ${Get.find<AuthController>().authRepo.getAuthToken()}"
        },
        body: {
          'id': requestId ?? '', // Avoid sending null value
        },
      );

      if (response.statusCode == 200) {
        // API call was successful
        _isLoading.value = false;

        print('API call successful');
        final jsonResponse = json.decode(response.body);

        mdGetRequestData = MDGetRequestData.fromJson(jsonResponse);

        // Check for null values before accessing
        if (mdGetRequestData?.requestData?.createdAt != null) {
          String createdAt = mdGetRequestData!.requestData!.createdAt!;
          DateTime parsedDate = DateTime.parse(createdAt);
          formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        } else {
          print('CreatedAt is null');
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Check if the data exists before setting
        if (mdGetRequestData?.requestData?.parcelLat != null) {
          await prefs.setString(
              'parcel_lat', mdGetRequestData!.requestData!.parcelLat!);
        }
        if (mdGetRequestData?.requestData?.parcelLong != null) {
          await prefs.setString(
              'parcel_long', mdGetRequestData!.requestData!.parcelLong!);
        }
        if (mdGetRequestData?.requestData?.receiverLat != null) {
          await prefs.setString(
              'receiver_lat', mdGetRequestData!.requestData!.receiverLat!);
        }
        if (mdGetRequestData?.requestData?.receiverLong != null) {
          await prefs.setString(
              'receiver_long', mdGetRequestData!.requestData!.receiverLong!);
        }

        // Check for null before printing the values
        if (mdGetRequestData?.requestData?.receiverAddress != null) {
          print(
              'Receiver Address: ${mdGetRequestData!.requestData!.receiverAddress}');

          // Call _getCurrentLocation function when receiverAddress is not null
          _getCurrentLocation();
        } else {
          print('Receiver Address is null');
        }

        if (mdGetRequestData?.requestData?.parcelAddress != null) {
          print(
              'Parcel Address: ${mdGetRequestData!.requestData!.parcelAddress}');
        } else {
          print('Parcel Address is null');
        }
      } else {
        // API call failed
        _isLoading.value = false;

        print('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      _isLoading.value = false;

      print('API call error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(RideTrackingController(userRepo: UserRepo()));
    _initializeState();
    _startLocationUpdates();
  }

  Future<void> _initializeState() async {
    await _getCurrentLocation();
    _animateToCurrentLocation();
    // No need to refresh here, GetX will automatically handle the state update
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return; // Ensure the widget is still mounted

    // Check if the receiver location is already reached
    if (controller.isReceiverLocationReached.value == false) {
      try {
        // Get the current position with high accuracy
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Load shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Retrieve values from shared preferences and ensure they are not null
        acceptOffer.value = prefs.getBool('acceptOffer') ?? false;
        isRideStarted.value = prefs.getBool('isRideStarted') ?? false;

        print('acceptOffer.value: ${acceptOffer.value}');
        print('isRideStarted.value: ${isRideStarted.value}');

        parcelLat = prefs.getString('parcel_lat');
        parcelLong = prefs.getString('parcel_long');
        receiverLat = prefs.getString('receiver_lat');
        receiverLong = prefs.getString('receiver_long');

        print('Parcel Latitude: $parcelLat');
        print('Parcel Longitude: $parcelLong');

        if (receiverLat != null && receiverLong != null) {
          print('Receiver Latitude: $receiverLat');
          print('Receiver Longitude: $receiverLong');
        }

        // Parse latitude and longitude values safely
        double? parcelLat1 = double.tryParse(parcelLat ?? '');
        double? parcelLong1 = double.tryParse(parcelLong ?? '');
        double? receiverLat1 =
            receiverLat != null ? double.tryParse(receiverLat ?? '') : null;
        double? receiverLong1 =
            receiverLong != null ? double.tryParse(receiverLong ?? '') : null;

        // Perform operations only if parcel coordinates are available
        if (parcelLat1 != null && parcelLong1 != null) {
          LatLng sourceLocation = LatLng(parcelLat1, parcelLong1);
          print('Source Location: $sourceLocation');

          // Optionally handle destination coordinates
          LatLng? destinationLocation;
          if (receiverLat1 != null && receiverLong1 != null) {
            destinationLocation = LatLng(receiverLat1, receiverLong1);
            print('Destination Location: $destinationLocation');
          }

          // Update markers and circles only if the widget is still mounted
          if (mounted) {
            setState(() {
              _currentPosition = position;

              _markers.add(
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: LatLng(position.latitude, position.longitude),
                  icon: controller.driverIcon,
                ),
              );

              _markers.add(
                Marker(
                  markerId: const MarkerId('source_location'),
                  position:
                      LatLng(sourceLocation.latitude, sourceLocation.longitude),
                  icon: controller.sourceIcon,
                ),
              );

              // Add destination marker if available
              if (destinationLocation != null) {
                _markers.add(
                  Marker(
                    markerId: const MarkerId('destination_location'),
                    position: LatLng(destinationLocation.latitude,
                        destinationLocation.longitude),
                    icon: controller.destinationIcon,
                  ),
                );
              }

              // Add a circle around the current location
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
          }
        } else {
          print('Parcel coordinates are missing or invalid.');
        }
      } catch (e) {
        print('Error in _getCurrentLocation: $e');
      }
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
            child: WillPopScope(
              onWillPop: () async {
                // Navigate to the home screen when the back button is pressed
                Get.offAll(() => const BottomBarScreen());
                return false;
              },
              child: Obx(
                () => Scaffold(
                  bottomSheet: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: controller.isRideStarted.value == true ||
                              isRideStarted.value == true
                          ? Container(child: Text('Ride Started'.tr))
                          : Obx(
                              () => acceptOffer.value == true
                                  ? CustomButton(
                                      buttonText: "Proceed".tr,
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
                                      'Waiting for User to accept your Offer'
                                          .tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            )),
                  backgroundColor: Colors.transparent,
                  body: Obx(
                    () => Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50.h),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            InkWell(
                              onTap: () {
                                getRequestData();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  // Light color background
                                  borderRadius: BorderRadius.circular(12),
                                  // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      // Shadow color with opacity
                                      blurRadius: 8,
                                      // Spread of the shadow
                                      offset: Offset(
                                          0, 4), // Shadow position (downward)
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Refresh',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 18, // Text size
                                      fontWeight:
                                          FontWeight.bold, // Text weight
                                      letterSpacing: 1.2, // Text letter spacing
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 45,
                            //   decoration: BoxDecoration(
                            //       color: isInternetConnected.value == true
                            //           ? Colors.black
                            //           : Colors.red),
                            //   child: Center(
                            //       child: isInternetConnected.value == true
                            //           ? Text(
                            //               'Connected to Internet'.tr,
                            //               style: TextStyle(
                            //                   fontSize: 16, color: Colors.white),
                            //             )
                            //           : Text(
                            //               'Not Connected to Internet'.tr,
                            //               style: TextStyle(
                            //                   fontSize: 16, color: Colors.white),
                            //             )),
                            // ),
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
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        if (!_controller.isCompleted) {
                                          // Complete the controller only if it hasn't been completed yet
                                          _controller.complete(controller);
                                        }
                                      },
                                      initialCameraPosition:
                                          initialCameraPosition,
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
                                        MediaQuery.of(context).size.width *
                                            0.1),
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Have you received the parcel?'.tr,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
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
                                                    await setPreferencesForParcelCollected();
                                                    parcelReceived.value = true;
                                                    controller.createHistory(
                                                        isProceed: '0',
                                                        isStart: '0',
                                                        isEnd: '0');
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  child: Text('YES'.tr,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blueGrey,
                                                  ),
                                                  child: Text(
                                                    'Waiting'.tr,
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
                                          MediaQuery.of(context).size.width *
                                              0.1),
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: controller.cashOnDelivery.value == true
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                'Request Status Successfully Updated'
                                                    .tr,
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
                                                controller.cashOnDelivery
                                                    .value = false;
                                                controller
                                                    .isReceiverLocationReached
                                                    .value = false;
                                                controller
                                                    .isReceiverLocationReached
                                                    .value = false;
                                                Get.offAll(
                                                    const BottomBarScreen());
                                              },
                                              child: Text(
                                                'Back to Home'.tr,
                                                textAlign: TextAlign.center,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
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
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  'Have you reached the destination?'
                                                      .tr,
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                // Handle yes action
                                                                if (controller
                                                                    .codeController
                                                                    .text
                                                                    .isEmpty) {
                                                                  Get.snackbar(
                                                                      'Alert'
                                                                          .tr,
                                                                      'Please Enter Code'
                                                                          .tr,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red);
                                                                } else {
                                                                  controller
                                                                      .message
                                                                      .value = '';

                                                                  await controller.markCompleteRequest(
                                                                      code: controller
                                                                          .codeController
                                                                          .text);
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.grey,
                                                              ),
                                                              child: Text(
                                                                  'YES'.tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                // Handle reject action
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .blueGrey,
                                                              ),
                                                              child: Text(
                                                                'NO'.tr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                      'Enter Code'.tr,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  controller.isLoading.value ==
                                                          true
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                Colors.blueGrey,
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
                                                                  EdgeInsets
                                                                      .all(10),
                                                            ),
                                                            maxLines: 1,
                                                            // Allow multiple lines if needed
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            // Show the done button
                                                            onSubmitted:
                                                                (String value) {
                                                              // Close the keyboard when text input is complete
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            },
                                                          ),
                                                        ),
                                                  controller.message.value ==
                                                          'Code does not match'
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20),
                                                          child: Text(
                                                            controller
                                                                .message.value,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                'Did you received payment, If received then press YES otherwise NO'
                                    .tr
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.1),
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Have you received the payment?'.tr,
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
                                                        controller
                                                            .updatePaymentStatus();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.grey,
                                                      ),
                                                      child: controller
                                                                  .isLoading
                                                                  .value ==
                                                              true
                                                          ? Container(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  const CircularProgressIndicator(
                                                                color: Colors
                                                                    .blueGrey,
                                                              ))
                                                          : Text('YES'.tr,
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
                                                            Colors.red,
                                                      ),
                                                      child: Text(
                                                        'NO'.tr,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container())
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: _animateToCurrentLocation,
                    child: Icon(Icons.my_location),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
