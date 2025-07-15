import 'package:get/get.dart';
import 'package:roomrounds/core/constants/app_colors.dart';
import 'package:roomrounds/core/constants/app_strings.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';
import 'package:roomrounds/utils/custom_loader.dart';

class CustomOverlays {
  static void dismissLoader({bool? isGoBack}) {
    bool? isDialogOpen = Get.isDialogOpen;
    customLogger("IsDialogOpen: $isDialogOpen");

    if (isDialogOpen == true && isGoBack == true) {
      Get.back(closeOverlays: true);
    }
  }

  static void showLoaderOnScreen() {
    if (Get.isDialogOpen == true) {
      Get.until((route) => !Get.isDialogOpen!);
    }
  }

  static void dismissToast() {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
  }

  static void showLoader({bool barrierDismissible = false}) {
    dismissLoader();

    Get.dialog(
      const CustomLoader(isDialog: true),
      barrierDismissible: barrierDismissible,
    );
  }

  static void showSnackBar(String? message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    Get.showSnackbar(GetSnackBar(
      // title: 'Title',
      message: message,
      duration: const Duration(seconds: 2),
    ));
  }

  static void showToastMessage(
      {String? title, String? message, bool isSuccess = false}) async {
    dismissToast();

    !Get.isSnackbarOpen
        ? Get.snackbar(
            title ?? (isSuccess ? AppStrings.success : AppStrings.error),
            message ??
                (isSuccess
                    ? AppStrings.success
                    : AppStrings.somethingWentWrong),
            colorText: isSuccess ? AppColors.black : AppColors.white,
            backgroundColor: isSuccess ? AppColors.green : AppColors.red,
            // animationDuration: Duration(seconds: 2),
          )
        : null;
  }
}

// class CustomLoader extends StatelessWidget {
//   const CustomLoader({super.key, this.isDialog = false});

//   final bool isDialog;

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: CircularProgressIndicator(
//         strokeWidth: 2,
//         backgroundColor: AppColors.white,
//         valueColor: AlwaysStoppedAnimation<Color>(
//           AppColors.primary,
//         ),
//       ),
//     );
//   }
// }