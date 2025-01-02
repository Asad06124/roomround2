import 'package:roomrounds/core/constants/controllers.dart';

class GV {
  static String userName = '';
  static String accountName = '';
  static int? id;
  static String password = "";
  static String bearerToken = "";
  static String fcmToken = "";
  static String userUniqueId = '';

  Future<void> initializeVariables() async {
    userName = profileController.userNameController.value.text;
    id = profileController.departmentId;
    // password = PreferenceManager.getString(PreferencesKeys.password);
  }
}
