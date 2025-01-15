import 'dart:developer';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/push_notification/push_notification.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> _loginKey = GlobalKey();
  GlobalKey<FormState> get loginKey => _loginKey;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (loginKey.validateFields) {
      String username = usernameController.text.trim().toLowerCase();
      String password = passwordController.text.trim();

      var response = await APIFunction.call(
        APIMethods.post,
        Urls.login,
        dataMap: {
          "usernameOrEmail": username,
          "password": password,
        },
        customHeaders: {"platform": "mobile"},
        fromJson: User.fromJson,
      );

      if (response != null && response is User) {
        profileController.setUser(response, saveUser: true);
        await saveFcmToken();
      }
    }
  }

  Future<void> saveFcmToken() async {
    String? token = await PushNotificationController.fcm.getToken();
    if (token != null && token.isNotEmpty) {
      var response = await APIFunction.call(
        APIMethods.post,
        '${Urls.fcmToken}=$token',
        customHeaders: {"platform": "mobile"},
      );

      if (response != null) {
        debugPrint('FCM token saved successfully');
        Get.offNamed(AppRoutes.HOME);
        log('Fcm Token=$token');
      } else {
        Get.offNamed(AppRoutes.HOME);
        debugPrint('Failed to save FCM token');
      }
    } else {
      Get.offNamed(AppRoutes.HOME);
      debugPrint('No FCM token available');
    }
  }
}
