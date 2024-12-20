import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:cargo_driver_app/home/find_trip_online.dart';
import 'package:cargo_driver_app/home/home_screen.dart';
import 'package:cargo_driver_app/profile/profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home/bottom_navbar.dart';
import 'home/driver_request_notification_screen.dart';
import 'main.dart';

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token
  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Permission Allowed');
    } else {
      _fcm.requestPermission(alert: true, sound: true, criticalAlert: true);
    }

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');
    // Retrieving the FCM token
    // fcmToken = await _fcm.getToken();

    _fcm.getAPNSToken();
    log('fcmToken: $fcmToken');
    // Save FcmToken

    if (Platform.isIOS) {
      String? apnsToken = await _fcm.getAPNSToken();
      if (apnsToken != null) {
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await _fcm.getAPNSToken();
        if (apnsToken != null) {}
      }
    } else {}
    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');

      // Check if the message contains a notification
      if (message.notification != null) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Print notification title and body
        debugPrint('Notification title: ${notification?.title}');
        debugPrint('Notification body: ${notification?.body}');
        print('Notification Title: ${notification?.title}');
        print('Notification Body: ${notification?.body}');

        // Set foreground notification presentation options
        await _fcm.setForegroundNotificationPresentationOptions(
            alert: true, sound: true, badge: true);

        // Create notification channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description: 'This channel is used for important notifications.',
          // description
          importance: Importance.max,
          playSound: true,
        );

        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        // Show notification if Android specific notification is available
        if (android != null) {
          _notificationsPlugin.show(
              notification.hashCode,
              notification!.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: android.smallIcon,
                  // other properties...
                ),
              ));
        }
      } else {
        debugPrint('Notification is null');
      }

      // Check if the message contains data
      if (message.data.isNotEmpty) {
        debugPrint('Message data: ${message.data}');
        print('Message Data: ${message.data}');
      } else {
        debugPrint('Message data is empty');
      }
      _handleNotificationClick(context, message);
    });

    LocalNoticationsService(_notificationsPlugin).init();
    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      // Print notification title and body
      debugPrint('Notification body: ${message.notification!.body}');

      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  Future<void> _handleNotificationClick(
      BuildContext context, RemoteMessage message) async {
    // Check if the message contains data
    if (message.notification?.title == 'New request') {
      Get.offAll(() => const BottomBarScreen());
      Get.to(() => FindTripOnline(message: message));
    } else if (message.notification?.title == 'Accept Offer') {
      Get.offAll(() => const BottomBarScreen());
      Get.offAll(() => DriverRequestNotificationScreen(message: message));
    }
    if (message.data.isNotEmpty) {
      debugPrint('Message data: ${message.data}');
      print('Message Data: ${message.data}');
      if (message.notification?.title == 'New request') {
        Get.to(() => FindTripOnline(message: message));
      } else if (message.notification?.title == 'Accept Offer') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('acceptOffer', true);
        Get.offAll(() => DriverRequestNotificationScreen(message: message));
      }
    } else {
      debugPrint('Message data is empty');
    }
    // final notificationData = message.data;
    // if (notificationData.containsKey('screen')) {
    //   final screen = notificationData['screen'];
    //   Navigator.of(context).pushNamed(screen);
    // }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if necessary

  debugPrint('Handling a background message: ${message.messageId}');

  // Check if the message contains a notification
  if (message.notification != null) {
    RemoteNotification? notification = message.notification;

    // Print the original notification title and body
    debugPrint('Notification title: ${notification?.title}');
    debugPrint('Notification body: ${notification?.body}');
    print('Notification Title: ${notification?.title}');
    print('Notification Body: ${notification?.body}');

    // Translate title and body to Arabic
    String translatedTitle = _translateToArabic(notification?.title ?? '');
    String translatedBody = _translateToArabic(notification?.body ?? '');

    // Print the translated title and body
    print('Translated Title: $translatedTitle');
    print('Translated Body: $translatedBody');
  } else {
    debugPrint('Notification is null');
  }

  // Check if the message contains data
  if (message.data.isNotEmpty) {
    debugPrint('Message data: ${message.data}');
    print('Message Data: ${message.data}');
  } else {
    debugPrint('Message data is empty');
  }
}

// Dummy function for translation
String _translateToArabic(String text) {
  // Define a simple mapping of known strings
  Map<String, String> translations = {
    "New Offer": "عرض جديد",
    "Payment Received": "تم استلام الدفعة",
    "Request Updated": "تم تحديث الطلب",
  };

  // Check if the text exists in the predefined translations
  if (translations.containsKey(text)) {
    return translations[text]!;
  }

  // If not in the map, return the original text
  return text;
}

class LocalNoticationsService {
  LocalNoticationsService(
    this._notificationsPlugin,
  );

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher', // path to notification icon
    );

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'category',
          options: {
            DarwinNotificationCategoryOption.allowAnnouncement,
          },
          actions: [
            DarwinNotificationAction.plain(
              'snoozeAction',
              'snooze',
            ),
            DarwinNotificationAction.plain(
              'confirmAction',
              'confirm',
              options: {
                DarwinNotificationActionOption.authenticationRequired,
              },
            ),
          ],
        ),
      ],
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectedNotification,
      onDidReceiveBackgroundNotificationResponse: onSelectNotificationAction,
    );
    final notificationOnLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationOnLaunchDetails?.didNotificationLaunchApp ?? false) {
      _onSelectedNotification(const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification));
    }
  }

  void _onSelectedNotification(NotificationResponse payload) {}
}

// Top level function
Future onSelectNotificationAction(details) async {
  final localNotificationsService =
      LocalNoticationsService(FlutterLocalNotificationsPlugin());
  await localNotificationsService.init();
}
