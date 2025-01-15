import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';

import '../../core/services/get_server_key.dart';

class PushNotificationController {
  static final FirebaseMessaging fcm = FirebaseMessaging.instance;
  static String fcmToken = '';
  static bool isPermissionGranted = false;

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Configure local notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request notification permissions
    await _grantNotificationPermission();

    // Handle notifications from terminated state
    await _handleTerminatedState();

    // Set up listeners for foreground and background states
    await _setupFirebaseMessagingListeners();
  }

  static Future<void> _grantNotificationPermission() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isPermissionGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;
    debugPrint('Notification permission granted: $isPermissionGranted');
  }

  static Future<void> _handleTerminatedState() async {
    final RemoteMessage? initialMessage = await fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state with notification');
      _handleNotificationClick(initialMessage.data, fromTerminationState: true);
    }
  }

  static Future<void> _setupFirebaseMessagingListeners() async {
    // Listen for notifications in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          payload: jsonEncode(message.data),
        );
      }
    });

    // Listen for notifications when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      if (notificationResponse.payload != null) {
        final payload = jsonDecode(notificationResponse.payload!);
        _handleNotificationClick(payload);
      }
    }
  }

  static Future<void> _showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> _handleNotificationClick(Map<String, dynamic> data,
      {bool fromTerminationState = false}) async {
    final action = data['Screen'];
    switch (action) {
      case 'Chat':
        Get.offAndToNamed(AppRoutes.DASHBOARD);
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(AppRoutes.MESSAGE);
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(
            AppRoutes.CHAT,
            preventDuplicates: false,
            arguments: {
              'receiverId': data['senderId'],
              'receiverImgUrl': data['receiverImgUrl'],
              'receiverDeviceToken': data['receiverDeviceToken'],
              'name': data['senderName'],
            },
          );
        });
        break;

      case 'TicketCreate':
        Get.find<NotificationController>().fetchNotificationsList();
        Get.toNamed(AppRoutes.NOTIFICATION);
        break;

      case 'TicketStatus':
        Get.toNamed(AppRoutes.NOTIFICATION);
        break;

      case 'AssignedTemplate':
        Get.toNamed(AppRoutes.ASSIGNED_TASKS);
        break;

      default:
        debugPrint('Unhandled notification action: $action');
        break;
    }
  }

  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    // Fetch the server key for sending FCM messages
    String serverKey = await GetServerKey().getServerKeyToken();
    debugPrint("FCM Server Key: $serverKey");

    const String url =
        "https://fcm.googleapis.com/v1/projects/roomround-34b5f/messages:send";

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    // Prepare the message payload
    final Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": data,
      }
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint("Notification sent successfully!");
      } else {
        debugPrint(
            "Failed to send notification: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("Error sending notification: $e");
    }
  }
}
