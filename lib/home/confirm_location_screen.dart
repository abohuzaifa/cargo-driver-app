import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_constants.dart';
import '../api/auth_controller.dart';
import '../api/user_repo.dart';
import '../widgets/custom_button.dart';
import 'bottom_navbar.dart';
import 'controller/location_controller.dart';

// class LocationPage extends StatelessWidget {
//   const LocationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LocationController>(
//       builder: (controller) => Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               foregroundDecoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.center,
//                   colors: [
//                     bgColor,
//                     bgColor.withOpacity(0.5),
//                   ],
//                 ),
//               ),
//               child: GoogleMap(
//                 compassEnabled: false,
//                 markers: controller.markers,
//                 onCameraMove: controller.onCameraMove,
//                 initialCameraPosition:
//                     CameraPosition(target: controller.initialPos, zoom: 18),
//                 onMapCreated: controller.onCreated,
//                 onCameraIdle: () async {
//                   controller.getMoveCamera();
//                 },
//               ),
//             ),
//             Positioned(
//               top: 100.h,
//               left: 20.w,
//               right: 20.w,
//               child: TextField(
//                 readOnly: true,
//                 controller: controller.locationController,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: const InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.location_on_outlined,
//                       color: Colors.black,
//                     ),
//                     contentPadding: EdgeInsets.zero,
//                     fillColor: Colors.white12,
//                     filled: true,
//                     focusedBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     enabledBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     disabledBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     errorBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     focusedErrorBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none)),
//               ),
//             ),
//           ],
//         ),
//         extendBody: true,
//         bottomNavigationBar: CustomButton(
//             buttonText: 'Confirm Location',
//             onPress: () {
//               controller.setLocation(
//                   userId:
//                       '${Get.find<AuthController>().getLoginUserData()?.user?.id}',
//                   address: controller.locationController.text,
//                   city: controller.city,
//                   lat: '${controller.initialPos.latitude}',
//                   lang: '${controller.initialPos.longitude}');
//             }),
//       ),
//     );
//   }
// }

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final userRepo = UserRepo(); // Initialize directly in the constructor

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _pickedLocation;
  TextEditingController locationController = TextEditingController();
  LatLng _initialPosition = const LatLng(-12.122711, -77.027475);

  LatLng get initialPos => _initialPosition;
  String? cityA;

  getCity() async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
        _pickedLocation!.latitude,
        _pickedLocation!.longitude,
      );
      cityA = placemark[0].locality!;
      locationController.text = placemark[0].name!;
    } finally {}
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  Future _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Location services enabled: $serviceEnabled'); // Print service status
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    print(
        'Current permission status: $permission'); // Print current permission status
    if (permission == LocationPermission.denied) {
      print('Location permission denied, requesting permission...');
      permission = await Geolocator.requestPermission();
      print(
          'Requested permission status: $permission'); // Print requested permission status
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    print(
        'Current position: Latitude: ${position.latitude}, Longitude: ${position.longitude}'); // Print current location coordinates

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _pickedLocation = _currentLocation;
    });
    await getCity();

    print(
        'Updated _currentLocation: $_currentLocation'); // Print updated location
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation!, zoom: 14),
      ));
    }
  }

  void setLocation({
    required String userId,
    required String address,
    required String lat,
    required String lang,
    required String city,
  }) async {
    // isLoading.value = true; // Start loader
    try {
      var response = await userRepo!.confirmLocation(
        userId: userId,
        address: address,
        lat: lat,
        lang: lang,
        city: city,
      );
      if (response.containsKey(APIRESPONSE.SUCCESS)) {
        Get.offAll(() => const BottomBarScreen());
      } else {
        showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoAlertDialog(
            content: const Text('Something went wrong'),
            actions: [
              CupertinoDialogAction(
                onPressed: Get.back,
                child: const Text('Ok'),
              )
            ],
          ),
        );
      }
    } finally {
      // isLoading.value = false; // Stop loader
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onCameraMove: (position) {
                    setState(() {
                      _pickedLocation = position.target;
                    });
                  },
                  // Disable default controls
                  myLocationButtonEnabled: false,
                  // Disable the default location button
                  myLocationEnabled: false,
                  // Disable the default location layer
                  zoomControlsEnabled: false,
                  // Disable zoom controls
                  compassEnabled: false, // Disable the compass
                ),

                // Custom Pin in the center of the map
                Center(
                  child: Image.asset(
                    'assets/images/locationIcon.png',
                    height: 75,
                    width: 75,
                    color: Colors.red,
                  ),
                ),

                Positioned(
                  top: 100.h,
                  left: 20.w,
                  right: 20.w,
                  child: Container(
                    color: Colors.black,
                    child: TextField(
                      readOnly: true,
                      controller: locationController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.white12,
                        filled: true,
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        errorBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedErrorBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),

                //  Confirmation button at the bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffBCA37F),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_pickedLocation != null) {
                        final userId =
                            '${Get.find<AuthController>().getLoginUserData()?.user?.id}';
                        final address = locationController.text;
                        final city = cityA;
                        final latitude = '${_pickedLocation!.latitude}';
                        final longitude = '${_pickedLocation!.longitude}';

                        // Print all values
                        print('User ID: $userId');
                        print('Address: $address');
                        print('City: $city');
                        print('Latitude: $latitude');
                        print('Longitude: $longitude');

                        setLocation(
                          userId: userId,
                          address: address,
                          city: cityA!,
                          lat: latitude,
                          lang: longitude,
                        );
                      }
                    },
                    child: Text(
                      'Confirm Location'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
