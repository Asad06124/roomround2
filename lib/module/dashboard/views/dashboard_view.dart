import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/dashboard/controller/dashboard_controller.dart';

import '../../../firebase_options.dart';
import '../../push_notification/push_notification.dart';
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
Future<void> initnotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await PushNotificationController.initialize();
}
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    initnotification();
    return GetBuilder<DashBoardController>(
      init: DashBoardController(),
      builder: (controller) {
        return Container(
          color: AppColors.white,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: controller.curruntScreen,
            bottomNavigationBar: AppBottomBar(
              activeIcons: controller.activeIcons,
              inactiveIcons: controller.inactiveIcons,
              inactiveLabelStyle:
                  context.bodySmall!.copyWith(color: AppColors.white),
              activeLabelStyle:
                  context.bodySmall!.copyWith(color: AppColors.white),
              labels: controller.labels,
              color: AppColors.textPrimary,
              height: 65,
              circleWidth: 45,
              circleColor: Colors.white,
              activeIndex: controller.curruntIndex,
              onTap: (index) {
                controller.buttumButtunClick(index);
              },
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
              cornerRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(0),
              ),
              shadowColor: Colors.grey,
              elevation: 5,
            ),
          ),
        );
      },
    );
  }
}
