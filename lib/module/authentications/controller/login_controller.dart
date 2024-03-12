import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/constants/imports.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> _loginKey = GlobalKey();

  GlobalKey<FormState> get loginKey => _loginKey;

  final username = TextEditingController();
  final passsword = TextEditingController();
  login() {
    if (loginKey.validateFields) {
      if (username.text == 'employee@gmail.com') {
        userData = UserData(
          id: '0',
          name: 'Robert Brown',
          username: 'employee@gmail.com',
          password: '12345678',
          type: UserType.employee,
        );
      } else if (username.text == 'manager@gmail.com') {
        userData = UserData(
          id: '1 ',
          name: 'Veronica Park',
          username: 'manager@gmail.com',
          password: '12345678',
          type: UserType.manager,
        );
      } else {
        showSnackBar("Invalid username or password.");
        return;
      }
      Get.offNamed(AppRoutes.HOME);
    }
  }
}
