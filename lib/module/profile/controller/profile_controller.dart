import 'package:roomrounds/core/apis/models/user_data/user_model.dart';
import 'package:roomrounds/core/constants/app_keys.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class ProfileController extends GetxController {
  User? _user;

  User? get user => _user;

  void setUser(User user, {bool saveUser = false}) {
    _user = user;
    refresh();
    
    if (saveUser) {
      DataStorageHelper.saveModel(AppKeys.userData, user);
    }
  }

  void logout() {
    _user = null;
    DataStorageHelper.removeAll();
    CustomOverlays.dismissLoader();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
