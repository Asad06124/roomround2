import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/routes/app_pages.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';

import 'core/services/badge_counter.dart';
import 'firebase_options.dart';
import 'module/push_notification/push_notification.dart';
// main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataStorageHelper.init();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _initControllers();
  // await BadgeCounter.initialize();

  // Reset badge count on app launch
//  await BadgeCountService.resetBadgeCount();

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
      defaultTransition: Transition.zoom,
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
      navigatorObservers: [routeObserver],
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
