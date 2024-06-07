import 'package:cargo_driver_app/firebase_options.dart';
import 'package:cargo_driver_app/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'bindings/contorller_binding.dart';
import 'fcm_handle.dart';

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

  @override
  void initState() {
    _messagingService.init(context);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (_, child) {
          return GetMaterialApp(
            initialBinding: Binding(),
            initialRoute: '/',
            themeMode: ThemeMode.light,
            theme: ThemeData(
              fontFamily: 'RadioCanada',
            ),
            debugShowCheckedModeBanner: false,
            title: 'Cargo App',
            home: const SplashScreen(),
          );
        });
  }
}
