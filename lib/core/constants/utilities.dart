import 'dart:ui';
import 'package:get/get.dart';
import 'app_colors.dart';


class Utilities {
  static setTextStyle(double size, FontWeight fontWeight,
          {Color color = AppColors.textGrey}) =>
      TextStyle(
          fontSize: size, fontWeight: fontWeight, color: color);

  static showErrorMessage(
      {String title = 'Error', String? error, int? miliSecond = 800}) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    return Get.snackbar(title, error ?? "Something went wrong, Try again",
        colorText: AppColors.red,
        backgroundColor: AppColors.white,
        animationDuration: Duration(milliseconds: miliSecond ?? 0));
  }

  static showSuccessMessage(
      {String title = 'Success', String? message, int? miliSecond = 800}) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    return Get.snackbar(title, message ?? "Successfully done",
        colorText: AppColors.primary,
        backgroundColor: AppColors.white,
        animationDuration: Duration(milliseconds: miliSecond ?? 0));
  }


  // static String formatIntoCompleteDate(String? dateTime) {
  //   DateFormat formatter = DateFormat('dd/MM/yyyy');
  //   if (dateTime != null) {
  //     return formatter.format(DateTime.parse(dateTime)).toString();
  //   }
  //   return "";
  // }

}
