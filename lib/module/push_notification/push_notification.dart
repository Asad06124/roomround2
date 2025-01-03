import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationController {
  static final FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
  static String fcmToken = '';
  static bool isPermissionGranted = false;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    await grantNotificationPermission();
    await localNotificationByFirebase();
  }

  static Future<void> grantNotificationPermission() async {
    NotificationSettings settings = await fcmMessage.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await fcmMessage.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await fcmMessage.setAutoInitEnabled(true);
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    isPermissionGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  static Future<void> localNotificationByFirebase() async {
    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message?.notification?.title != null) {
        showNotification(
          title: message?.notification?.title,
          body: message?.notification?.body,
        );
      }
    });

    // Listen for messages when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      if (message?.notification?.title != null) {
        showNotification(
          title: message?.notification?.title,
          body: message?.notification?.body,
        );
      }
    });

    // Listen for initial messages when the app is launched from a terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message?.notification?.title != null) {
        showNotification(
          title: message?.notification?.title,
          body: message?.notification?.body,
        );
      }
    });
  }

  static Future<void> showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      id ?? 0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // static clicksForNotification(Map<String, dynamic> notification) {
  //   switch (notification["screen"]) {
  //     case notification:
  //       break;
  //     case FireBaseMessageType.simpleChatMessage:
  //       break;
  //     case FireBaseMessageType.groupChatMessage:
  //       break;
  //   }
  // }
}
