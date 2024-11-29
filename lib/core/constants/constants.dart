import 'package:get_storage/get_storage.dart';
// import 'package:up_down_app/models/login_model.dart';

// LoginModel userData = LoginModel();
GetStorage storageBox = GetStorage();

String appVersion = '';

class AppConstants {
  static const String appName = "RoomRounds";
  static const String appNameSpace = "Room Rounds";
  static const String packageName = "com.roomrounds.llc";

  static const String playStoreLink =
      "https://play.google.com/store/apps/details?id=$packageName";
  // static const String appStoreLink =
  //     "https://play.google.com/store/apps/details?id=$packageName";
}
