import 'dart:async';

import 'package:roomrounds/core/constants/imports.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Timer(const Duration(seconds: 3), () => Get.offAllNamed(AppRoutes.LOGIN));
  }
}
