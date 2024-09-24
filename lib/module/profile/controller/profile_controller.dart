import 'package:roomrounds/core/apis/models/user_data/user_model.dart';
import 'package:roomrounds/core/constants/app_keys.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class ProfileController extends GetxController {
  User? _user;

  User? get user => _user;
  int? get userId => _user?.userId;
  String? get userRole => _user?.role;
  String? get userToken => _user?.token;
  String? get userName => _user?.username;
  UserType get userType {
    String? userRole = _user?.role?.trim();
    if (userRole != null && userRole.isNotEmpty) {
      String? role = userRole.camelCase;

      if (role != null && role.isNotEmpty) {
        if (UserType.organizationAdmin.name == role) {
          return UserType.organizationAdmin;
        } else if (UserType.manager.name == role) {
          return UserType.manager;
        } else if (UserType.employee.name == role) {
          return UserType.employee;
        }
      }
    }
    return UserType.employee;
  }

  void logout() {
    _user = null;
    DataStorageHelper.removeAll();
    CustomOverlays.dismissLoader();
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void setUser(User user, {bool saveUser = false}) {
    _user = user;
    refresh();

    if (saveUser) {
      DataStorageHelper.saveModel(AppKeys.userData, user);
    }
  }
}
