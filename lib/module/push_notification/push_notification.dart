import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool isPermissionGranted = false;

  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();
  await BadgeCounter.initialize();

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

    // Reset badge count on app launch
    await BadgeCounter.resetBadgeCount();

    // Handle notifications from terminated state
    await _handleTerminatedState();

    // Set up listeners for foreground and background states
    await _setupFirebaseMessagingListeners();
  }

  static Future<void> _grantNotificationPermission() async {
    // Request permissions for notifications
    await [Permission.notification].request();
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Set foreground notification options
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
    // Handle notifications when app is opened from terminated state
    final RemoteMessage? initialMessage = await fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state with notification');
      await BadgeCounter.incrementBadgeCount();
      await _handleNotificationClick(initialMessage.data,
          fromTerminationState: true);
    }
  }

  static Future<void> _setupFirebaseMessagingListeners() async {
    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // Increment badge count for new notification
        await BadgeCounter.incrementBadgeCount();
        await _showNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          payload: jsonEncode(message.data),
        );
      }

      // Handle specific notification actions
      final action = message.data['Screen'];
      if (action == 'Chat') {
        final String chatRoomId = message.data['chatRoomId'];
        final String msgId = message.data['msgId'];
        try {
          await FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(chatRoomId)
              .collection('messages')
              .doc(msgId)
              .update({'isDelivered': true});
        } catch (error) {
          debugPrint('Error updating isDelivered: $error');
        }
      } else if (action == 'TicketCreate' || action == 'TicketStatus') {
        Get.find<NotificationController>()
            .fetchNotificationsList(forceRefresh: true);
      }
    });

    // Handle notifications when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Reset badge count when app is opened
      await BadgeCounter.resetBadgeCount();
      await _handleNotificationClick(message.data);
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
        await _handleNotificationClick(payload);
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
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
        badgeNumber: await BadgeCounter.getBadgeCount(),
      ),
    );

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
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(AppRoutes.MESSAGE);
        await Future.delayed(const Duration(milliseconds: 500));
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
        break;
      case 'ticketChat':
        Get.offAndToNamed(AppRoutes.DASHBOARD);
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(AppRoutes.ASSIGNED_TASKS);
        await Future.delayed(const Duration(milliseconds: 500));
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

    final Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": body},
        "data": data,
        "apns": {
          "payload": {
            "aps": {
              "sound": "default",
              "content-available": 1,
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
