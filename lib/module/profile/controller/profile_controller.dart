import 'dart:convert';
import 'dart:developer';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/user_update/user_update_model.dart';
import 'package:roomrounds/core/constants/app_keys.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/helpers/data_storage_helper.dart';
import 'package:roomrounds/utils/custom_overlays.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> get formKey => _formKey;

  User? _user;
  User? get user => _user;
  int? get userId => _user?.userId;
  String? get userRole => _user?.role;
  String? get userToken => _user?.token;
  String? get userName => _user?.username;
  String? get email => _user?.email;
  int? get departmentId => _user?.departmentId;
  String? get userImage => _user?.image;

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

  bool get isManager =>
      userType == UserType.manager || userType == UserType.organizationAdmin;

  bool get isEmployee => userType == UserType.employee;

  void setUser(User? user, {bool saveUser = false}) {
    if (user != null) {
      _user = user;
      log('data update=${_user!.toJson()}');
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

      bool hasChange =
          user?.username?.trim() != userName || user?.email?.trim() != email;

      if (hasChange) {
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
          setUser(newUser, saveUser: true);
        }
      } else {
        CustomOverlays.showToastMessage(
          message: AppStrings.userIsUpToDated,
          isSuccess: true,
        );
      }
    }
  }

  void updateUserImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();

        String base64Image = base64Encode(bytes);

        // Make API call to update image
        var resp = await APIFunction.call(
          APIMethods.post,
          Urls.updateUser,
          dataMap: {
            "userName": userName,
            "email": email,
            "image": base64Image,
          },
          showLoader: true,
          showErrorMessage: true,
          showSuccessMessage: true,
        );

        if (resp != null && resp is bool && resp == true) {
          fetchUserProfile();
        }
      } catch (e) {
        CustomOverlays.showToastMessage(
          message: "Failed to process the image. Error: $e",
          isSuccess: false,
        );
      }
    } else {
      CustomOverlays.showToastMessage(
        message: 'No image selected.',
        isSuccess: false,
      );
    }
  }

  void showLogoutDialog() {
    String description = AppStrings.areYouSureWantToLogout;
    Get.dialog(
      Dialog(
        child: YesNoDialog(
          title: description,
          onYesPressed: () {
            Get.back(); // Close Dialog
            logout();
          },
        ),
      ),
    );
  }

  void logout() {
    _user = null;
    DataStorageHelper.removeAll();
    CustomOverlays.dismissLoader();
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void fetchUserProfile() async {
    try {
      var resp = await APIFunction.call(
        APIMethods.post,
        Urls.getUserProfile,
        fromJson: (json) => UserUpdate.fromJson(json),
        showLoader: true,
        showErrorMessage: true,
      );

      if (resp != null && resp is UserUpdate) {
        User updatedUser = User(
          userId: _user?.userId,
          username: resp.userName ?? _user?.username,
          email: resp.email ?? _user?.email,
          rememberMe: _user?.rememberMe,
          roleId: _user?.roleId,
          role: _user?.role,
          organizationId: _user?.organizationId,
          image: resp.image ?? _user?.image,
          map: _user?.map,
          departmentId: _user?.departmentId,
          rgbColor: _user?.rgbColor,
          token: _user?.token,
        );

        setUser(updatedUser, saveUser: true);
        setTextFieldsData();
      }
    } catch (e) {
      CustomOverlays.showToastMessage(
        message: "Failed to fetch user profile: $e",
        isSuccess: false,
      );
    }
  }
}
