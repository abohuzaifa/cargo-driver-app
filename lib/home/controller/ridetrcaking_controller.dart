import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cargo_driver_app/api/api_constants.dart';
import 'package:cargo_driver_app/util/apputils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points_plus/flutter_polyline_points_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../api/auth_controller.dart';
import '../../api/user_repo.dart';
import '../../mqtt_service.dart';
import '../driver_request_notification_screen.dart';

class RideTrackingController extends GetxController implements GetxService {
  final UserRepo userRepo;

  RideTrackingController({required this.userRepo});

  late GoogleMapController _mapController;

  GoogleMapController get mapController => _mapController;
  late StreamSubscription<Position> streamSubscription;
  var latitude = Rx<double>(0.0);
  var longitude = Rx<double>(0.0);
  var userLatitude = Rx<double>(30.1744);
  var userLongitude = Rx<double>(71.4789);
  var _initialPosition = const CameraPosition(target: LatLng(23.8859, 45.0792));
  var address = Rx<String>('');
  Set<Marker> markers = <Marker>{};
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor driverIcon;

  LatLng? lastDriverLocation;

  List<LatLng> pathPoints = [];
  final Set<Polyline> polylines = {};
  late PolylinePoints polylinePoints;

  @override
  void onInit() {
    super.onInit();
    init();
    initClient();
  }

  @override
  void onReady() {
    super.onReady();
    streamSubscription =
        Geolocator.getPositionStream().listen((position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      log('Location Listen==?$position');
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latitude.value, longitude.value), zoom: 14.4746),
      ));

      if (userLatitude.value != 0.0 && userLongitude.value != 0.0) {
        updatePolyLinesAndMarkers(position);
      }

      final location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (MQTTClient.client.connectionStatus?.state ==
          MqttConnectionState.connected) {
        MQTTClient.emitLocation(location,
            '${Get.find<AuthController>().getLoginUserData()?.user?.id}');
      }
    });
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }

  Future<void> init() async {
    polylinePoints = PolylinePoints();

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 0.01),
        'assets/images/location_icon.png');
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1),
        'assets/images/sourceIcon.png');
    driverIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/driver_way.png');
  }

  Future<void> getAddress(Position position) async {
    List<Placemark> places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = places.first;
    address.value = 'Address: ${place.locality}, ${place.country}';
  }

  Future createRideHistory(
      {required String requestId,
      required String lat,
      required String long,
      String? address,
      required String isStart,
      required String isEnd}) async {
    var response = await userRepo.createRideHistory(
        requestId: requestId,
        lat: lat,
        long: long,
        isEnd: isEnd,
        isStart: isStart,
        address: address);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      AppUtils.showDialog(
          'Updated Success',
          () => () {
                Get.back();
              });
    }
  }

  Future<void> startLocationTracking(
      String sourceLat, String sourceLong) async {
    Map req = {
      "status": "active",
      "latitude": sourceLat,
      "longitude": sourceLong,
    };

    await updateStatus(req).then((value) {
      // Handle success
    }).catchError((error) {
      log(error.toString());
    });
  }

  Future updateStatus(Map<dynamic, dynamic> req) async {
    // Implementation for updating status
  }

  Future<void> setPolyLines({
    required LatLng sourceLocation,
    required LatLng destinationLocation,
  }) async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
      optimizeWaypoints: true,
      "AIzaSyDdwlGhZKKQqYyw9f9iME40MzMgC9RL4ko",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      pathPoints.clear();
      for (var point in result.points) {
        pathPoints.add(LatLng(point.latitude, point.longitude));
      }

      polylines.clear();
      polylines.add(Polyline(
        polylineId: const PolylineId('poly'),
        color: const Color.fromARGB(255, 198, 40, 98),
        points: pathPoints,
        width: 8,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ));
      log('Polylines added successfully');
    } else {
      log('No points found in the polyline result');
    }
    update();
  }

  void addMarkers() {
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('Driver'),
      position: LatLng(latitude.value, longitude.value),
      icon: driverIcon,
    ));

    markers.add(Marker(
      markerId: const MarkerId('Destination'),
      position: LatLng(userLatitude.value, userLongitude.value),
      icon: destinationIcon,
    ));
    markers.add(Marker(
      markerId: const MarkerId('Source'),
      position: LatLng(31.4835, 74.3782),
      icon: sourceIcon,
    ));
    log('Markers added successfully');
    update();
  }

  void updateDriverMarker(LatLng position) {
    double bearing = 0.0;
    if (lastDriverLocation != null) {
      bearing = _calculateBearing(
          lastDriverLocation!, LatLng(position.latitude, position.longitude));
    }
    lastDriverLocation = LatLng(position.latitude, position.longitude);

    markers.removeWhere((marker) => marker.markerId.value == 'Driver');
    markers.add(Marker(
      markerId: const MarkerId('Driver'),
      position: LatLng(position.latitude, position.longitude),
      icon: driverIcon,
      rotation: bearing,
    ));
    update();
  }

  void updatePolyLinesAndMarkers(Position position) async {
    LatLng sourceLocation = LatLng(31.4835, 74.3782);
    LatLng destinationLocation = LatLng(31.4926, 74.3925);
    userLatitude.value = destinationLocation.latitude;
    userLongitude.value = destinationLocation.longitude;

    // Print source and destination locations
    print('Source Location: $sourceLocation');
    print('Destination Location: $destinationLocation');

    await setPolyLines(
      sourceLocation: sourceLocation,
      destinationLocation: destinationLocation,
    );
    updateDriverMarker(LatLng(31.4926, 74.3925));
    addMarkers();
  }

  void onCreated(GoogleMapController controller) async {
    _mapController = controller;
    if (userLatitude.value != 0.0 && userLongitude.value != 0.0) {
      updatePolyLinesAndMarkers(Position(
        latitude: latitude.value,
        longitude: longitude.value,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 1.0,
        heading: 1.0,
        speed: 1.0,
        speedAccuracy: 1.0,
        altitudeAccuracy: 1.0,
        headingAccuracy: 1.0,
      ));
    }
  }

  void addMarker(LatLng location, String address) {
    markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Current Location"),
        icon: BitmapDescriptor.defaultMarker));
    update();
  }

  void onCameraMove(CameraPosition position) async {
    position = CameraPosition(
        target: LatLng(latitude.value, longitude.value), zoom: 18.0);
    _initialPosition = position;
  }

  void initClient() {
    MQTTClient.mqttForUser(
        '${Get.find<AuthController>().getLoginUserData()?.user?.id}');
  }

  Future<void> bidOnUserRequests({
    required String requestId,
    required String amount,
  }) async {
    var response =
        await userRepo.bidOnUserRequest(requestId: requestId, amount: amount);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      Get.to(() => const DriverRequestNotificationScreen());
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = _toRadians(start.latitude);
    double lon1 = _toRadians(start.longitude);
    double lat2 = _toRadians(end.latitude);
    double lon2 = _toRadians(end.longitude);

    double dLon = lon2 - lon1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double bearing = math.atan2(y, x);

    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  double _toDegrees(double radian) {
    return radian * 180 / math.pi;
  }
}
