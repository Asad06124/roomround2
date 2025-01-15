import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';

import '../../core/services/get_server_key.dart';

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
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    await grantNotificationPermission();
    await setupFirebaseMessagingListeners();
  }

  static onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      if (notificationResponse.payload != null) {
        final payload = jsonDecode(notificationResponse.payload!);
        clicksForNotification(payload);
      }
    }
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

  static Future<void> setupFirebaseMessagingListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null) {
        showNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body,
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      if (message != null) {
        clicksForNotification(message.data);
      }
    });
  }

  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    print("notification server key => ${serverKey}");
    String url =
        "https://fcm.googleapis.com/v1/projects/roomround-34b5f/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    //mesaage
    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data,
      }
    };

    //hit api
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification Send Successfully!");
    } else {
      print(
          "Notification not send! reason: ${response.body}\n ${response.statusCode}\n ${response.reasonPhrase}");
    }
  }

  static Future<void> showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
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

  static Future<void> clicksForNotification(Map<String, dynamic> notification,
      {bool fromTerminationState = false}) async {
    final action = notification['Screen'];
    switch (action) {
      case 'Chat':

        Get.toNamed(AppRoutes.DASHBOARD);

        Future.delayed(Duration(milliseconds: 500), () {
          Get.toNamed(AppRoutes.MESSAGE);
        });


        Future.delayed(Duration(milliseconds: 500), () {
          Get.toNamed(
            AppRoutes.CHAT,
            preventDuplicates: false,
            arguments: {
              'receiverId': notification['senderId'],
              'receiverImgUrl': notification['receiverImgUrl'],
              'receiverDeviceToken': notification['receiverDeviceToken'],
              'name': notification['senderName'],
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
        break;
    }
  }
}
