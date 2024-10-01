import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  GlobalKey<FormState> get formKey => _formKey;

  void onChangePassword() async {
    if (formKey.validateFields) {
      String currentPassword = oldPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();

      if (currentPassword != newPassword) {
        var resp = await APIFunction.call(
          APIMethods.post,
          Urls.updatePassword,
          dataMap: {
            "currentPassword": currentPassword,
            "newPassword": newPassword,
          },
          showLoader: true,
          showErrorMessage: true,
          showSuccessMessage: true,
        );

        if (resp != null && resp is bool && resp == true) {
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          Get.back();
        }
      } else {
        CustomOverlays.showToastMessage(
            message: AppStrings.newAndOldPasswordShouldNotSame);
      }
    }
  }
}
