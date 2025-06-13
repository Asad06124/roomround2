import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomrounds/core/constants/imports.dart'; // Assuming this includes your app's constants and components

class SettingsController extends GetxController {
  var tapCount = 0.obs;
  DateTime? firstTapTime;

  void handleTap() {
    tapCount.value++;

    if (tapCount.value == 1) {
      firstTapTime = DateTime.now();
    }

    if (tapCount.value >= 3) {
      if (firstTapTime != null &&
          DateTime.now().difference(firstTapTime!).inSeconds <= 3) {
        Get.snackbar(
          'Version Info',
          'Patch Version: 0.0.1',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        tapCount.value = 0;
        firstTapTime = null;
      } else {
        tapCount.value = 0;
        firstTapTime = DateTime.now();
      }
    }
  }
}
