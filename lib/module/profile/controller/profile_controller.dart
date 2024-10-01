import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/user_data/user_model.dart';
import 'package:roomrounds/core/constants/app_keys.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class ProfileController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> get formKey => _formKey;

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

  void setUser(User? user, {bool saveUser = false}) {
    if (user != null) {
      _user = user;
      update();

      if (saveUser) {
        DataStorageHelper.saveModel(AppKeys.userData, user);
      }
    }
  }

  void setTextFieldsData() {
    userNameController.text = user?.username ?? '';
    emailController.text = user?.email ?? '';
  }

  void updateUserName() async {
    if (formKey.validateFields) {
      String userName = userNameController.text.trim();
      String email = emailController.text.trim();

      var resp = await APIFunction.call(
        APIMethods.post,
        Urls.updateUser,
        dataMap: {"userName": userName, "email": email},
        showLoader: true,
        showErrorMessage: true,
        showSuccessMessage: true,
      );

      if (resp != null && resp is bool && resp == true) {
        User? newUser = _user;
        newUser?.username = userName;
        setUser(newUser);
        Get.back();
      }
    }
  }

  void onEditImage() async {}

  void logout() {
    _user = null;
    DataStorageHelper.removeAll();
    CustomOverlays.dismissLoader();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
