import 'package:roomrounds/core/constants/imports.dart';

UserData userData = UserData();

class UserData {
  UserType type;
  String name;
  String password;
  String username;
  String id;
  UserData(
      {this.id = '',
      this.name = '',
      this.username = '',
      this.password = '',
      this.type = UserType.employee});
}
