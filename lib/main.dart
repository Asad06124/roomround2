import 'package:permission_handler/permission_handler.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/routes/app_pages.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

void main() async {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
      Permission.photos,
      Permission.storage
    ].request();

    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      CustomOverlays.showToastMessage(
        message:
            "Permissions are required to use this app. Please enable them in the settings.",
      );
      await openAppSettings();
    }
  }

  WidgetsFlutterBinding.ensureInitialized();
  await DataStorageHelper.init();
  await requestPermissions();
  _initControllers();

  runApp(const MyApp());
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
