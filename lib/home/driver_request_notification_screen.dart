import 'dart:async';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../api/user_repo.dart';
import '../main.dart';
import '../main.dart';
import '../widgets/custom_button.dart';
import 'controller/ridetrcaking_controller.dart';

// class DriverRequestNotificationScreen extends StatefulWidget {
//   const DriverRequestNotificationScreen({
//     Key? key,
//     this.message,
//   }) : super(key: key);
//
//   final RemoteMessage? message;
//
//   @override
//   _DriverRequestNotificationScreenState createState() =>
//       _DriverRequestNotificationScreenState();
// }
//
// class _DriverRequestNotificationScreenState
//     extends State<DriverRequestNotificationScreen> {
//   late RideTrackingController controller;
//   final StreamController<RemoteMessage?> _messageStreamController =
//       StreamController<RemoteMessage?>();
//   late GoogleMapController mapController;
//   LatLng? currentLocation;
//   final double radiusInMeters = 1000; // Change this value as needed
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(RideTrackingController(userRepo: UserRepo()));
//   }
//
//   @override
//   void dispose() {
//     _messageStreamController.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<RideTrackingController>(
//       init: controller,
//       builder: (controller) {
//         return Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.center,
//               colors: [
//                 const Color(0xff113946),
//                 const Color(0xff113946).withOpacity(0.01),
//               ],
//             ),
//           ),
//           child: Scaffold(
//             bottomSheet: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Obx(
//                   () => controller.isOfferAccepted.value
//                       ? CustomButton(
//                           buttonText: "Proceed",
//                           onPress: () {
//                             controller.createHistory(isStart: '1', isEnd: '0');
//                             controller
//                                 .startLocationCheckIfNearByHundredMeters();
//                             // Get.to(() => const BottomBarScreen());
//                           },
//                         )
//                       : Text(
//                           'Waiting for User to accept your Offer',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 )),
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 50.h),
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {},
//                             child: const Icon(
//                               Icons.menu,
//                               color: Colors.white,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {},
//                             child: const Icon(
//                               Icons.search,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     Expanded(
//                       child: Container(
//                         foregroundDecoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.center,
//                             colors: [
//                               const Color(0xff113946),
//                               const Color(0xff113946).withOpacity(0.5),
//                             ],
//                           ),
//                         ),
//                         child: GetBuilder<RideTrackingController>(
//                           init: controller,
//                           builder: (controller) {
//                             return GoogleMap(
//                               markers: controller.markers,
//                               polylines: controller.polylines,
//                               compassEnabled: true,
//                               onCameraMove: controller.onCameraMove,
//                               initialCameraPosition: CameraPosition(
//                                 target: LatLng(controller.latitude.value,
//                                     controller.longitude.value),
//                                 zoom: 12,
//                               ),
//                               myLocationEnabled: true,
//                               myLocationButtonEnabled: true,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 controller.isParcelLocationReached.value
//                     ? Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         margin: EdgeInsets.symmetric(
//                             horizontal:
//                                 MediaQuery.of(context).size.width * 0.1),
//                         height: MediaQuery.of(context).size.height * 0.4,
//                         width: MediaQuery.of(context).size.width * 0.8,
//                         child: Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 'Have you received the parcel?',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               Container(
//                                 margin: EdgeInsets.only(left: 20, right: 20),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: SizedBox(
//                                         height:
//                                             MediaQuery.of(context).size.height *
//                                                 0.06,
//                                         child: ElevatedButton(
//                                           onPressed: () async {
//                                             // Handle yes action
//                                             setPreferences();
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.grey,
//                                           ),
//                                           child: Text('Yes',
//                                               style: TextStyle(
//                                                   color: Colors.white)),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.05),
//                                     Expanded(
//                                       child: SizedBox(
//                                         height:
//                                             MediaQuery.of(context).size.height *
//                                                 0.06,
//                                         child: ElevatedButton(
//                                           onPressed: () {
//                                             // Handle reject action
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.blueGrey,
//                                           ),
//                                           child: Text(
//                                             'No',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




class DriverRequestNotificationScreen extends StatefulWidget {
  const DriverRequestNotificationScreen({
    Key? key,
    this.message,
  }) : super(key: key);

  final RemoteMessage? message;

  @override
  State<DriverRequestNotificationScreen> createState() =>
      _DriverRequestNotificationScreenState();
}

class _DriverRequestNotificationScreenState
    extends State<DriverRequestNotificationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition initialCameraPosition =
  CameraPosition(target: LatLng(33.6943, 72.9743), zoom: 14);
  List<Marker> _markers = [];
  Set<Circle> _circles = {};
  Position? _currentPosition;
  List<LatLng> _nearbyLocations = [
    LatLng(33.6953, 72.9753),
    LatLng(33.6963, 72.9763),
    LatLng(33.6973, 72.9773),
  ];
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );

      _circles.add(
        Circle(
          circleId: CircleId('current_location_circle'),
          center: LatLng(position.latitude, position.longitude),
          radius: 1000, // Radius in meters
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );

      // Add nearby locations as markers with highlighting circles
      for (var i = 0; i < _nearbyLocations.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('nearby_location_$i'),
            position: _nearbyLocations[i],
          ),
        );

        _circles.add(
          Circle(
            circleId: CircleId('nearby_location_circle_$i'),
            center: _nearbyLocations[i],
            radius: 100, // Radius in meters
            fillColor: Colors.red.withOpacity(0.5),
            strokeColor: Colors.red,
            strokeWidth: 1,
          ),
        );
      }

      // Create zigzagging polyline coordinates
      _polylineCoordinates = [
        LatLng(position.latitude, position.longitude),
        ..._nearbyLocations,
      ];
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
    );
  }

  Future<void> _animateToCurrentLocation() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 14,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          markers: Set<Marker>.of(_markers),
          circles: _circles,
          polylines: {
            Polyline(
              polylineId: PolylineId('route'),
              points: _polylineCoordinates,
              color: Colors.red,
              width: 3,
              patterns: [PatternItem.dash(10), PatternItem.gap(10)],
            ),
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: initialCameraPosition,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateToCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}

