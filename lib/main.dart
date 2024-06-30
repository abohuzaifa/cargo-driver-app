import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cargo_driver_app/api/auth_repo.dart';
import 'package:cargo_driver_app/splash_screen.dart';
import 'package:cargo_driver_app/welcome_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'api/auth_controller.dart';
import 'bindings/contorller_binding.dart';
import 'fcm_handle.dart';
import 'home/chat/chat_page.dart';
import 'home/confirm_location_screen.dart';
import 'home/driver_request_notification_screen.dart';
import 'home/find_trip_online.dart';
import 'package:http/http.dart' as http;

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case "locationUpdate":
//         try {
//           position = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.low,
//               // Adjust accuracy for battery usage
//               forceAndroidLocationManager:
//                   true); // May improve background reliability on Android
//           await createHistory(
//               isEnd: '0',
//               isStart: '1'); // Replace with your actual API call logic
//         } on PlatformException catch (error) {
//           debugPrint('Error getting location: $error');
//           // Handle platform-specific errors (e.g., permission denied)
//         } catch (error) {
//           debugPrint('General error: $error');
//           // Handle general errors (e.g., network issues)
//         }
//         break;
//       default:
//         print("Unknown task: $task");
//     }
//     return Future.value(true);
//   });
// }

Position? position; // Declare as nullable
RxBool receivedReq = false.obs;
String? fcmToken;
var address = Rx<String>('');
var latitude = Rx<double>(0.0);
var longitude = Rx<double>(0.0);

Future<String?> getFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission to receive notifications
  await messaging.requestPermission();

  // Get the token
  String? token = await messaging.getToken();
  fcmToken = token;
  print('fcmToken==${fcmToken}');
  return token;
}

final _firebaseMessaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> initNotifications() async {
  await _firebaseMessaging.requestPermission();
  final fcmToken = await _firebaseMessaging.getToken();
  print('token=====${fcmToken}');
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Initialize SharedPreferences and AuthRepo
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final AuthRepo authRepo = AuthRepo(sharedPreferences: sharedPreferences);

  // Register AuthController with GetX
  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController(authRepo: authRepo));
  }

  // Retrieve request_id from SharedPreferences
  String? requestId = sharedPreferences.getString('request_id');
  print('Retrieved request_id: $requestId');

  // Save a test value in SharedPreferences
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    // Set the service as a foreground service and display the initial notification
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "My App Service",
      content: "Fetching location periodically",
    );

    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 20), (timer) async {
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // Ensure the service is running in the foreground
    if (service is AndroidServiceInstance &&
        !await service.isForegroundService()) {
      print('Service is not in foreground, stopping task execution');
      return;
    }

    try {
      // Obtain the current position
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Position obtained: latitude=${position!.latitude}, longitude=${position!.longitude}');
      await createHistory(isStart: '1', isEnd:'0');
    } catch (e) {
      print('Error obtaining position: $e');
      return;
    }



    final deviceInfo = DeviceInfoPlugin();
    String? device;
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
        print('Device info obtained: model=$device');
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
        print('Device info obtained: model=$device');
      }
    } catch (e) {
      print('Error obtaining device info: $e');
    }

    // Invoke the update method with the current data
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
        "location": {
          "latitude": position!.latitude,
          "longitude": position!.longitude,
        },
      },
    );

    // Display a notification if the service is running in the foreground
    if (service is AndroidServiceInstance &&
        await service.isForegroundService()) {
      flutterLocalNotificationsPlugin.show(
        888,
        'COOL SERVICE',
        'Awesome ${DateTime.now()}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );

      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Location Fetching Time at ${DateTime.now()}",
      );
    }
  });
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

// Function to retrieve the request_id from SharedPreferences
Future<String?> getRequestId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Retrieve request_id from SharedPreferences
  return prefs.getString('request_id');
}

Future<bool> createHistory({
  required String isStart,
  required String isEnd,
}) async {
// Retrieve the request_id
  address.value = await getAddress(position!.latitude, position!.longitude);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? requestId = prefs.getString('request_id');
  final url = Uri.parse('http://delivershipment.com/api/createHistory');
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    "Authorization":
        "Bearer ${Get.find<AuthController>().authRepo.getAuthToken()}"
  };
  final body = jsonEncode({
    'request_id': requestId,
    'lat': position!.latitude,
    'long': position!.longitude,
    'address': address.value,
    'is_start': isStart,
    'is_end': isEnd,
  });
  print(
      'Get.find<AuthController>().authRepo.getAuthToken()======${Get.find<AuthController>().authRepo.getAuthToken()}');
  print('body=${body}');

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Successfully created history
      print('Successful to create history');
      print('Response body: ${response.body}');
      await saveLastRequestDetails(url.toString(), headers.toString(), body,
          response.statusCode, response.body);

      return true;
      // isRideStarted.value = true;
      // _startPeriodicHistoryUpdates();
    } else {
      // Error creating history
      print('Failed to create history. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Exception handling
    print('Exception caught: $e');
    await saveLastRequestException(
        url.toString(), headers.toString(), body, e.toString());

    return false;
  }
}

// Function to save last request details locally
Future<void> saveLastRequestDetails(String url, String headers, String body,
    int statusCode, String responseBody) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('last_request_url', url);
  prefs.setString('last_request_headers', headers);
  prefs.setString('last_request_body', body);
  prefs.setInt('last_response_status_code', statusCode);
  prefs.setString('last_response_body', responseBody);
}

// Function to save last request exception details locally
Future<void> saveLastRequestException(
    String url, String headers, String body, String exception) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('last_request_url', url);
  prefs.setString('last_request_headers', headers);
  prefs.setString('last_request_body', body);
  prefs.setString('last_request_exception', exception);
}

void startBackgroundService() {
  const platform = MethodChannel('com.tarudDriver.app/background_service');
  platform.invokeMethod('startService');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  startBackgroundService();
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerPeriodicTask(
  //   "locationUpdate",
  //   "fetchLocationAndHitAPI",
  //   frequency: Duration(minutes: 15),
  // );
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await getFCMToken();
  await initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    const CargoDeleiveryApp(),
  );
}

class CargoDeleiveryApp extends StatefulWidget {
  const CargoDeleiveryApp({super.key});

  @override
  State<CargoDeleiveryApp> createState() => _CargoDeleiveryAppState();
}

class _CargoDeleiveryAppState extends State<CargoDeleiveryApp>
    with WidgetsBindingObserver {
  final _messagingService = MessagingService();
  RemoteMessage? _initialMessage;
  bool _isSplashDone = false;

  @override
  void initState() {
    _messagingService.init(context);
    super.initState();
    _setupInteractedMessage();
    WidgetsBinding.instance.addObserver(this); // Add observer for lifecycle changes
    _startBackgroundService();
  }
  Future<void> _startBackgroundService() async {
    const MethodChannel('yourapp/background_service')
        .invokeMethod('startService');
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer to prevent memory leaks
    super.dispose();
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FlutterBackgroundService().startService();
    } else if (state == AppLifecycleState.resumed) {
      FlutterBackgroundService().invoke('stopService');
      printStoredLogs();
    }
  }

  Future<void> printStoredLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastRequestUrl = prefs.getString('last_request_url');
    String? lastRequestHeaders = prefs.getString('last_request_headers');
    String? lastRequestBody = prefs.getString('last_request_body');
    int? lastResponseStatusCode = prefs.getInt('last_response_status_code');
    String? lastResponseBody = prefs.getString('last_response_body');
    String? lastRequestException = prefs.getString('last_request_exception');

    print('Last Request URL: $lastRequestUrl');
    print('Last Request Headers: $lastRequestHeaders');
    print('Last Request Body: $lastRequestBody');
    if (lastResponseStatusCode != null) {
      print('Last Response Status Code: $lastResponseStatusCode');
      print('Last Response Body: $lastResponseBody');
    } else if (lastRequestException != null) {
      print('Last Request Exception: $lastRequestException');
    } else {
      print('No response or exception stored.');
    }
  }

  void _setupInteractedMessage() async {
    // Get the initial message
    _initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the initial message is not null, it means the app was opened via a notification
    if (_initialMessage != null) {
      _navigateToInitialRoute();
    }

    // Handle interaction when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    // Navigate to the desired screen with the message data
    if (message.notification?.title == 'New request') {
      Get.to(() => FindTripOnline(message: message));
    } else if (message.notification?.title == 'Accept Offer') {
      Get.to(() => DriverRequestNotificationScreen(message: message));
    } else if (message.notification?.title == 'New Message') {
      Get.to(() => ChatPage(message: message));
    }
  }

  void _navigateToInitialRoute() {
    if (_isSplashDone && _initialMessage != null) {
      _handleMessage(_initialMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          initialBinding: Binding(),
          themeMode: ThemeMode.light,
          theme: ThemeData(
            fontFamily: 'RadioCanada',
          ),
          debugShowCheckedModeBanner: false,
          title: 'Cargo App',
          home: SplashScreen(
            onInitializationComplete: () {
              _isSplashDone = true;
              _navigateToInitialRoute();
              if (_initialMessage == null) {
                Get.offAll(() => Get.find<AuthController>().isLogedIn()
                    ? const LocationPage()
                    : const WelcomeScreen());
              }
            },
          ),
          getPages: [
            GetPage(
                name: '/',
                page: () => SplashScreen(onInitializationComplete: () {})),
            GetPage(
                name: '/findTrip',
                page: () => FindTripOnline(message: _initialMessage)),
            GetPage(
                name: '/driverRequest',
                page: () =>
                    DriverRequestNotificationScreen(message: _initialMessage)),
            GetPage(
                name: '/chatPage',
                page: () => ChatPage(message: _initialMessage)),
          ],
        );
      },
    );
  }
}
