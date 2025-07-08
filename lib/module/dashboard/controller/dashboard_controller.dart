import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/services/badge_counter.dart';
import 'package:roomrounds/module/emloyee_directory/controller/departments_controller.dart';
import 'package:roomrounds/module/profile/views/profile_view.dart';

import '../../../firebase_options.dart';
import '../../notificatin/controller/notification_controller.dart';
import '../../push_notification/push_notification.dart';

class DashBoardController extends GetxController {
  int _curruntIndex = 0;

  int get curruntIndex => _curruntIndex;
  final List<Widget> _screenList = [
    const MainFeaturesView(),
    const SettingsView(),
    const ProfileView()
  ];

  final activeIcons = [
    Assets.icons.home.svg(
        colorFilter:
            const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
    Assets.icons.settings.svg(
        colorFilter:
            const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
    Assets.icons.personFill.svg(
        colorFilter:
            const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
  ];
  final inactiveIcons = [
    Assets.icons.home.svg(
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
    Assets.icons.settings.svg(
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
    Assets.icons.personFill.svg(
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
  ];
  final labels = [AppStrings.home, AppStrings.settings, AppStrings.profile];

  Widget get curruntScreen => _screenList[_curruntIndex];

  @override
  void onInit() {
    super.onInit();
    initnotification();
    _initDepartments();
    Get.put(NotificationController());
  }

  void _initDepartments() async {
    departmentsController = Get.put(DepartmentsController());
  }

  buttumButtunClick(int indx) {
    _curruntIndex = indx;
    update();
  }
}

// Background handler - iOS will handle badge natively
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // BadgeCountService.incrementBadgeCount();
  print('[Background] Received notification: ${message.notification?.title}');
  
  // Badge is handled natively on iOS, just handle the data
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
      print('Error updating isDelivered in background: $error');
    }
  }
}

Future<void> initnotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  await PushNotificationController.initialize();
}