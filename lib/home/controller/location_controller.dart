import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cargo_driver_app/auth_screen/login_screen.dart';
import 'package:cargo_driver_app/home/controller/user_controler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points_plus/flutter_polyline_points_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../api/api_constants.dart';
import '../../api/user_repo.dart';
import '../bottom_navbar.dart';

class LocationController extends GetxController implements GetxService {
  final UserRepo userRepo;
  LocationController({required this.userRepo});
  late LatLng _gpsActual;

  LatLng _initialPosition = const LatLng(-12.122711, -77.027475);
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  final Set<Polyline> polyline = {};
  late PolylinePoints polylinePoints;
  Future<void> setPolyLines(
      {required LatLng sourceLocation,
      required LatLng destinationLocation,
      LatLng? driverLocation}) async {
    polylinePoints = PolylinePoints();
    polyline.clear();
    polylineCoordinates.clear();
    var result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDdwlGhZKKQqYyw9f9iME40MzMgC9RL4ko",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var element in result.points) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
      polyline.add(Polyline(
        startCap: Cap.buttCap,
        endCap: Cap.buttCap,
        visible: true,
        width: 8,
        polylineId: const PolylineId('poly'),
        color: const Color.fromARGB(255, 40, 122, 198),
        points: polylineCoordinates,
      ));
      update();
    }
  }

  var activeGps = true.obs;
  TextEditingController locationController = TextEditingController();
  late GoogleMapController _mapController;
  late String city;

  LatLng get gpsPosition => _gpsActual;

  LatLng get initialPos => _initialPosition;
  final Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  GoogleMapController get mapController => _mapController;

  @override
  void onReady() async {
    Future.wait([getUserLocation(), getUserPendingRequests()]);

    super.onReady();
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      _initialPosition.latitude,
      _initialPosition.longitude,
    );
    city = placemark[0].locality!;
    locationController.text = placemark[0].name!;
  }

  Future<void> getUserLocation() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      activeGps.value = false;
    } else {
      activeGps.value = true;
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _initialPosition = LatLng(position.latitude, position.longitude);
      _gpsActual = LatLng(position.latitude, position.longitude);
      log("the latitude is: ${position.latitude} and the longitude is: ${position.longitude} ");
      locationController.text = placemark[0].name!;
      log("initial position is : ${placemark[0].name}");
      _addMarker(_initialPosition, placemark[0].name!);
      _mapController.animateCamera(CameraUpdate.newLatLng(_initialPosition));
      update();
    }
  }

  void onCreated(GoogleMapController controller) async {
    _mapController = controller;

    _addMarker(_initialPosition, locationController.text);
    setPolyLines(
        sourceLocation: _initialPosition,
        destinationLocation: const LatLng(33.6376, 73.0664));
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Current Location"),
        icon: BitmapDescriptor.defaultMarker));
  }

  void onCameraMove(CameraPosition position) async {
    position = CameraPosition(target: initialPos, zoom: 18.0);
    _initialPosition = position.target;
  }

  void setLocation({
    required String userId,
    required String address,
    required String lat,
    required String lang,
    required String city,
  }) async {
    var response = await userRepo.confirmLocation(
      userId: userId,
      address: address,
      lat: lat,
      lang: lang,
      city: city,
    );
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      Get.to(() => const BottomBarScreen());
    } else {
      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => CupertinoAlertDialog(
          content: Text(response['message']),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                if (response['message'] == "Unauthenticated.") {
                  Get.delete<UserContorller>();
                  Get.to(() => LoginScreen());
                }
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  Future getUserPendingRequests() async {
    var resposne = await userRepo.getAllUsersTrips();
    log(resposne.toString());
  }

  void addDriverMarker(LatLng location, Uint8List icon) async {
    if (_markers.length == 1) {
      _markers.toList().removeAt(1);
    }
    _markers.add(Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      icon: BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/driver_way.png', 100),
      ),
    ));
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 14.4746),
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
