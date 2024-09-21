import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/user_data/user_model.dart';
import 'package:roomrounds/core/constants/controllers.dart';
import 'package:roomrounds/core/constants/imports.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> _loginKey = GlobalKey();

  GlobalKey<FormState> get loginKey => _loginKey;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (loginKey.validateFields) {
      String username = usernameController.text.trim().toLowerCase();
      String password = passwordController.text.trim();

      var response = await APIFunction.call(
        APIMethods.POST,
        Urls.login,
        dataMap: {
          "usernameOrEmail": username,
          "password": password,
        },
        fromJson: User.fromJson,
      );

      if (response != null) {
        Get.offNamed(AppRoutes.HOME);
        profileController.setUser(response, saveUser: true);
      }

      // if (username.text == 'employee@gmail.com') {
      //   userData = UserData(
      //     id: '0',
      //     name: 'Robert Brown',
      //     username: 'employee@gmail.com',
      //     password: '12345678',
      //     type: UserType.employee,
      //   );
      // } else if (username.text == 'manager@gmail.com') {
      //   userData = UserData(
      //     id: '1 ',
      //     name: 'Veronica Park',
      //     username: 'manager@gmail.com',
      //     password: '12345678',
      //     type: UserType.manager,
      //   );
      // } else {
      //   // CustomToast.showToast("Invalid username or password.");
      //   return;
      // }
    }
  }
}
