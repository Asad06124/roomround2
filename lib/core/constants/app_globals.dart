// ignore_for_file: unused_field

import 'package:roomrounds/core/apis/models/user_data/user_model.dart';
import 'package:roomrounds/core/constants/app_enum.dart';
import 'package:roomrounds/core/constants/imports.dart';

class AppGlobals {
  User? _user;
  static int selectedIndex = -1;
  static TextEditingController? replyController;

  static List<DummyUser> dummyData = [
    DummyUser(
        name: 'Wahab Sohail',
        image: '',
        time: '3:24 am',
        type: UserType.manager),
    DummyUser(
        name: 'Sarfraz Yousaf',
        image: '',
        time: '5:24 pm',
        type: UserType.employee),
    DummyUser(
        name: 'Ahmad Shahzad',
        image: '',
        time: '2:10 pm',
        type: UserType.employee),
    DummyUser(
        name: 'Noman Ghalib',
        image: '',
        time: '1:20 pm',
        type: UserType.manager),
  ];
  // static Future<void> requestPermissions() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.microphone,
  //     Permission.camera,
  //     Permission.photos,
  //   ].request();

  //   // if (statuses.values.any((status) => status.isPermanentlyDenied)) {
  //   //   CustomOverlays.showToastMessage(
  //   //     message:
  //   //         "Permissions are required to use this app. Please enable them in the settings.",
  //   //   );
  //   //   await openAppSettings();
  //   // }
  // }
}

class DummyUser {
  String name;
  String time;
  String image;
  UserType type;

  DummyUser(
      {required this.name,
      required this.image,
      required this.time,
      required this.type});
}
