import 'package:cargo_driver_app/firebase_options.dart';
import 'package:cargo_driver_app/splash_screen.dart';
import 'package:cargo_driver_app/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'api/auth_controller.dart';
import 'bindings/contorller_binding.dart';
import 'fcm_handle.dart';
import 'home/bottom_navbar.dart';
import 'home/confirm_location_screen.dart';
import 'home/driver_request_notification_screen.dart';
import 'home/find_trip_online.dart';

RxBool receivedReq = false.obs;
String? fcmToken;

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class _CargoDeleiveryAppState extends State<CargoDeleiveryApp> {
  final _messagingService = MessagingService();
  RemoteMessage? _initialMessage;
  bool _isSplashDone = false;

  @override
  void initState() {
    _messagingService.init(context);

    super.initState();
    _setupInteractedMessage();
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
          ],
        );
      },
    );
  }
}
