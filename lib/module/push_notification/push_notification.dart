import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart' show FlutterAppBadge;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/assigned_task/views/ticket_chat_view.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';

import '../../core/apis/models/tickets/ticket_model.dart';
import '../../core/services/badge_counter.dart';
import '../../core/services/get_server_key.dart';

class PushNotificationController {
  static final FirebaseMessaging fcm = FirebaseMessaging.instance;
  static String fcmToken = '';
  static bool isPermissionGranted = false;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Configure local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request notification permissions
    await _grantNotificationPermission();

    // Initialize badge count from shared preferences
    int badgeCount = await BadgeCounter.getBadgeCount();
    FlutterAppBadge.count(badgeCount);

    // Handle notifications from terminated state
    await _handleTerminatedState();

    // Set up listeners for foreground and background states
    await _setupFirebaseMessagingListeners();
  }

  static Future<void> _grantNotificationPermission() async {
    await [
      Permission.notification,
    ].request();
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
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
      // Increment badge count for terminated state notification
      await BadgeCounter.incrementBadgeCount();
      _handleNotificationClick(initialMessage.data, fromTerminationState: true);
    }
  }

  static Future<void> _setupFirebaseMessagingListeners() async {
    // Listen for notifications in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // Increment badge count
        await BadgeCounter.incrementBadgeCount();
        _showNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          payload: jsonEncode(message.data),
        );
      }

      final action = message.data['Screen'];

      if (action == 'Chat') {
        final String chatRoomId = message.data['chatRoomId'];
        final String msgId = message.data['msgId'];

        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .collection('messages')
            .doc(msgId)
            .update({'isDelivered': true}).catchError((error) {
          print('Error updating isDelivered: $error');
        });
      } else if (action == 'TicketCreate' || action == 'TicketStatus') {
        Get.find<NotificationController>()
            .fetchNotificationsList(forceRefresh: true);
      }
    });

    // Handle notifications when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Reset badge count when app is opened
      await BadgeCounter.resetBadgeCount();
      _handleNotificationClick(message.data);
    });
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      if (notificationResponse.payload != null) {
        final payload = jsonDecode(notificationResponse.payload!);
        // Reset badge count when notification is clicked
        await BadgeCounter.resetBadgeCount();
        _handleNotificationClick(payload);
      }
    }
  }

  static Future<void> _showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ));

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
      case 'ticketChat':
        Get.offAndToNamed(AppRoutes.DASHBOARD);
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(AppRoutes.ASSIGNED_TASKS);
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.to(
            TicketChatView(
              ticketId: data['chatRoomId'],
              receiverId: data['receiverId'],
              ticket: Ticket.fromJson(jsonDecode(data['ticket'])),
              senderId: data['senderId'],
              ticketTitle: data['ticketTitle'],
              isAssignedToMe: data['isAssignedToMe'] == "true",
            ),
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
    String serverKey = await GetServerKey().getServerKeyToken();
    debugPrint("FCM Server Key: $serverKey");

    const String url =
        "https://fcm.googleapis.com/v1/projects/roomround-34b5f/messages:send";

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    // Include badge count in the payload for iOS
    final Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": data,
        "apns": {
          // iOS-specific badge count
          "payload": {
            "aps": {
              "badge": await BadgeCounter.getBadgeCount() + 1,
            },
          },
        },
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
