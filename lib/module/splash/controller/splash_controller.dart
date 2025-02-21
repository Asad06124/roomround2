import 'dart:async';

import 'package:roomrounds/core/constants/app_keys.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkSavedUser();
  }

  void _checkSavedUser() async {
    bool isLoggedIn = false;
    var data = await DataStorageHelper.getModel(AppKeys.userData);
    if (data != null) {
      User user = User.fromJson(data);
      profileController.setUser(user);
      isLoggedIn = true;
    }

    await Future.delayed(const Duration(seconds: 2));

    isLoggedIn
        ? Get.offAllNamed(AppRoutes.HOME)
        : Get.offAllNamed(AppRoutes.LOGIN);
  }
}
