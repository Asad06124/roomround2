import 'package:roomrounds/core/constants/app_enum.dart';

class AppGlobals {
  static const String appName = "RoomRounds";
  static const String packageName = "com.roomrounds.llc";
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

  // static const String playStoreLink =
  //     "https://play.google.com/store/apps/details?id=$packageName";
  // static const String appStoreLink =
  //     "https://play.google.com/store/apps/details?id=$packageName";
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
