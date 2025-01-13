import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/routes/app_pages.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';
import 'package:roomrounds/module/push_notification/push_notification.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataStorageHelper.init();
  _initControllers();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await PushNotificationController.initialize();
  runApp(MyApp());
}

void _initControllers() {
  profileController = Get.put(ProfileController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeDark().theme,
      initialRoute: AppRoutes.SPLASH_SCREEN,
      getPages: AppPages.routes,
      builder: (context, child) {
        final scale = MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.6,
              maxScaleFactor: 0.8,
            );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child!,
        );
      },
    );
  }
}
