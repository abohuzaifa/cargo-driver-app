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
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth_controller.dart';
import '../../api/user_repo.dart';
import '../driver_request_notification_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RideTrackingController extends GetxController implements GetxService {
  RxBool isRideStarted = false.obs;
  RxBool isLoading = false.obs;
  RxBool isParcelLocationReached = false.obs;
  RxBool isReceiverLocationReached = false.obs;
  late Timer _locationCheckTimer;
  late Timer _historyTimer;
  RxString message = ''.obs;
  RxBool paymentStatusDone = false.obs;
  RxBool cashOnDelivery = false.obs; // Initialize the variable

  TextEditingController codeController = TextEditingController();

  LatLng parcelLocation = LatLng(31.4926, 74.3925); // Example parcel location

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
  DateTime? lastPositionTime;
  LatLng? lastDriverLocation;
  List<LatLng> pathPoints = [];
  final Set<Polyline> polylines = {};
  late PolylinePoints polylinePoints;
  RxBool isOfferAccepted = false.obs;
  Position? currentPosition;
  LatLng? currentLocation;

  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isOfferAccepted.value = prefs.getBool('acceptOffer') ?? false;
    init();
    // initClient();
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
    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = currentPosition!.latitude;
      longitude.value = currentPosition!.longitude;
      update();
      log('Current Location: $currentPosition');
      updatePolyLinesAndMarkers(currentPosition!);
    } catch (e) {
      log('Failed to get current location: '
          '$e');
      return;
    }
  }

  void startLocationCheckIfNearByHundredMeters() {
    print('In startLocationCheckIfNearByHundredMeters');

    _locationCheckTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      print('latitude.value in startLocationCheck ======${latitude.value}');
      print('longitude.value in startLocationCheck ${longitude.value}');

      LatLng currentLocation = LatLng(latitude.value, longitude.value);

      double distance = _calculateDistance(currentLocation, parcelLocation);
      print('Distance to parcel location: $distance meters');

      if (distance <= 100) {
        isParcelLocationReached.value = true;
        _historyTimer.cancel();
        _locationCheckTimer.cancel();

        timer.cancel(); // Stop the timer after showing the dialog
      }
    });
  }

  void setParcelLocationToCurrent() {
    print(' In setParcelLocationToCurrent');
    print(
        'latitude.value in setParcelLocationToCurrent======${latitude.value}');
    print('longitude.value in setParcelLocationToCurrent ${longitude.value}');
    parcelLocation = LatLng(latitude.value, longitude.value);
    print('parcelLocation======${parcelLocation}');
    if (latitude.value == parcelLocation.latitude &&
        longitude.value == parcelLocation.longitude) {
      isParcelLocationReached.value = true;
    }
    update();
  }

  void setParcelLocationToReceiver() {
    print(' In setParcelLocationToReceiver');
    parcelLocation = LatLng(latitude.value, longitude.value);
    print('parcelLocation======${parcelLocation}');
    if (latitude.value == parcelLocation.latitude &&
        longitude.value == parcelLocation.longitude) {
      isReceiverLocationReached.value = true;
    }
    update();
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> places =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = places.first;
      address.value = 'Address: ${place.locality}, ${place.country}';
    } catch (e) {
      print('Error occurred while getting address: $e');
    }
    return address.value;
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
    required LatLng currentLocation,
  }) async {
    String apiKey = "AIzaSyDdwlGhZKKQqYyw9f9iME40MzMgC9RL4ko";

    try {
      // Request route from current location to source
      var currentToSourceResponse = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${sourceLocation.latitude},${sourceLocation.longitude}&key=$apiKey'));
      var currentToSourceData = jsonDecode(currentToSourceResponse.body);
      if (currentToSourceData['routes'].isEmpty) {
        throw Exception('No routes found from current location to source.');
      }
      var currentToSourceEncodedPoints =
          currentToSourceData['routes'][0]['overview_polyline']['points'];
      var currentToSourcePoints =
          decodeEncodedPolyline(currentToSourceEncodedPoints);

      // Request route from source to destination
      var sourceToDestinationResponse = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${sourceLocation.latitude},${sourceLocation.longitude}&destination=${destinationLocation.latitude},${destinationLocation.longitude}&key=$apiKey'));
      var sourceToDestinationData =
          jsonDecode(sourceToDestinationResponse.body);
      if (sourceToDestinationData['routes'].isEmpty) {
        throw Exception('No routes found from source to destination.');
      }
      var sourceToDestinationEncodedPoints =
          sourceToDestinationData['routes'][0]['overview_polyline']['points'];
      var sourceToDestinationPoints =
          decodeEncodedPolyline(sourceToDestinationEncodedPoints);

      // Add current location to pathPoints
      pathPoints.add(currentLocation);

      // Add points from current to source
      pathPoints.addAll(currentToSourcePoints);

      // Add points from source to destination
      pathPoints.addAll(sourceToDestinationPoints);

      polylines.add(Polyline(
        polylineId: const PolylineId('poly'),
        color: const Color.fromARGB(255, 198, 40, 98),
        points: pathPoints,
        width: 8,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ));

      log('Polylines added successfully');
      update();
    } catch (e) {
      log('Error setting polylines: $e');
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void addMarkers(LatLng sourceLatLng, LatLng destinationLatLng) {
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('Driver'),
      position: LatLng(latitude.value, longitude.value),
      icon: driverIcon,
    ));

    markers.add(Marker(
      markerId: const MarkerId('Destination'),
      position: destinationLatLng,
      icon: destinationIcon,
    ));
    markers.add(Marker(
      markerId: const MarkerId('Source'),
      position: sourceLatLng,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parcelLat = prefs.getString('parcel_lat');
    var parcelLong = prefs.getString('parcel_long');
    var receiverLat = prefs.getString('receiver_lat');
    var receiverLong = prefs.getString('receiver_long');

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

    await setPolyLines(
      currentLocation: LatLng(latitude.value, longitude.value),
      sourceLocation: sourceLocation,
      destinationLocation: destinationLocation,
    );
    update();
    updateDriverMarker(LatLng(latitude.value, longitude.value));
    addMarkers(sourceLocation, destinationLocation);

    update();
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

  Future<void> bidOnUserRequests({
    required String requestId,
    required String amount,
  }) async {
    var response =
        await userRepo.bidOnUserRequest(requestId: requestId, amount: amount);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      Get.offAll(() => const DriverRequestNotificationScreen());
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

  double _calculateDistance(LatLng start, LatLng end) {
    const R = 6371000; // Radius of the Earth in meters
    double lat1 = _toRadians(start.latitude);
    double lon1 = _toRadians(start.longitude);
    double lat2 = _toRadians(end.latitude);
    double lon2 = _toRadians(end.longitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c;
  }

  Future<void> updatePaymentStatus() async {
    // Initialize SharedPreferences and AuthRepo
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? requestId = sharedPreferences.getString('request_id');
    print('Retrieved request_id: $requestId');
    isLoading.value = true;
    final url = Uri.parse('http://delivershipment.com/api/paymentStatus');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization":
          "Bearer ${Get.find<AuthController>().authRepo.getAuthToken()}"
    };
    final body = jsonEncode({
      'request_id': requestId,
    });
    print('body=${body}');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully markCompleteRequest
        isLoading.value = false;
        print('Successful to markCompleteRequest');
        print('Response body: ${response.body}');
        Map<String, dynamic> responseBody = json.decode(response.body);
        // Access a specific field in the JSON map and store it in the message variable
        if (responseBody.containsKey('msg')) {
          message.value = responseBody['msg'];
          if (message.value == 'Payent status update succesfully') {}
          paymentStatusDone.value = true;
          markCompleteRequest(code: codeController.text);
        }
      } else {
        // Error markCompleteRequest
        isLoading.value = false;

        print('Failed to paymentStatus. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Exception handling
      isLoading.value = false;

      print('Exception caught: $e');
    }
  }

  Future<void> markCompleteRequest({
    required String code,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    isLoading.value = true;
    codeController.clear();
    final url = Uri.parse('http://delivershipment.com/api/markCompleteRequest');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization":
          "Bearer ${Get.find<AuthController>().authRepo.getAuthToken()}"
    };
    final body = jsonEncode({
      'code': code,
    });
    print('body=${body}');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully markCompleteRequest
        isLoading.value = false;
        print('Successful to markCompleteRequest');
        print('Response body: ${response.body}');
        Map<String, dynamic> responseBody = json.decode(response.body);
        // Access a specific field in the JSON map and store it in the message variable
        if (responseBody.containsKey('msg')) {
          message.value = responseBody['msg'];
          if (message.value ==
              'Did you received payment, If received then press YES Or NOT') {
            cashOnDelivery.value = true; // Set the variable to true
          }
          if (message.value == 'Request status update successfully') {
            sharedPreferences.setString('request_id', '');
            sharedPreferences.setBool('acceptOffer', false);
            sharedPreferences.setBool('hasBidAndWaiting', false);
          }
        } else {
          message.value == 'Code Does not Match';
        }
      } else {
        // Error markCompleteRequest
        isLoading.value = false;

        print(
            'Failed to markCompleteRequest. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Exception handling
      isLoading.value = false;

      print('Exception caught: $e');
    }

    print(
        'cashOnDelivery: $cashOnDelivery'); // Debug print to check the variable's value
  }

  Future<void> createHistory({
    required String isStart,
    required String isEnd,
    required String isProceed,
  }) async {
    final requestId = await getRequestId(); // Retrieve the request_id
    address.value = await getAddress(latitude.value, longitude.value);

    final url = Uri.parse('http://delivershipment.com/api/createHistory');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization":
          "Bearer ${Get.find<AuthController>().authRepo.getAuthToken()}"
    };
    final body = jsonEncode({
      'request_id': requestId,
      'lat': latitude.value,
      'long': longitude.value,
      'address': address.value,
      'is_start': isStart,
      'is_end': isEnd,
      'is_proceed': isProceed,
    });
    print('body=${body}');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successfully created history
        print('Successful to create history');
        print('Response body: ${response.body}');
        isRideStarted.value = true;
        update();
        _startPeriodicHistoryUpdates(isProceed);
      } else {
        // Error creating history
        print('Failed to create history. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Exception handling
      print('Exception caught: $e');
    }
  }

  // Function to retrieve the request_id from SharedPreferences
  Future<String?> getRequestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('request_id');
  }

  void _startPeriodicHistoryUpdates(String isProceed) {
    print('In _startPeriodicHistoryUpdates');
    const duration = Duration(minutes: 5); // Adjust the interval as needed
    _historyTimer = Timer.periodic(duration, (timer) {
      if (isRideStarted.value == true) {
        createHistory(isStart: '1', isEnd: '0', isProceed: isProceed);
        print('In _startPeriodicHistoryUpdates Ping done');
      } else {
        timer.cancel();
      }
    });
  }
}
