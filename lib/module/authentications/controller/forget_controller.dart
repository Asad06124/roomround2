import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/constants/imports.dart';

class ForgetController extends GetxController {
  final GlobalKey<FormState> _forgetKey = GlobalKey();

  GlobalKey<FormState> get forgetKey => _forgetKey;

  final usernameController = TextEditingController();

  void forget() async {
    if (forgetKey.validateFields) {
      String params = usernameController.text.trim().toLowerCase();
      var response = await APIFunction.call(
        APIMethods.post,
        Urls.forget + params,
        showLoader: true,
        showErrorMessage: true,
        showSuccessMessage: true,
      );
      if (kDebugMode) {
        print(response);
      }
    }
  }
}



//  String params = "?id=$id";
//       var resp = await APIFunction.call(
//         APIMethods.post,
//         Urls.readNotification + params,
        // showLoader: true,
        // showErrorMessage: true,
//       );

//       if (resp != null && resp is bool && resp == true) {
//         try {
//           notificationsList.removeWhere((item) => item.notificationId == id);
//           update();
//         } catch (e) {
          // customLogger(
          //   'Error: $e',
          //   error: 'removeNotification',
          //   type: LoggerType.error,
          // );
//         }
//       }
//     }