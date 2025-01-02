import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_notification/overlay_notification.dart';

class PushNotificationController {
  static FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
  static String fcmToken = '';
  static bool isPermissionGranted = false;
  // Grant Notification Permissions

  static grantNotificationPermission() async {
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

  static notificationValues() async {
    await grantNotificationPermission();
    await setupLocalNotifications();
  }

//Local Notification
  static setupLocalNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showOverlayNotification((context) {
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: ListTile(
            minVerticalPadding: 0,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            title: Text(message.notification!.title ?? ""),
            subtitle: Text(message.notification!.body ?? ""),
            trailing: IconButton(icon: Icon(Icons.close), onPressed: () {}),
          ),
        );
      }, duration: Duration(milliseconds: 4000));
    });
  }
}
