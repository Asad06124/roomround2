// import 'package:up_down_app/core/constants/imports.dart';
// import 'package:up_down_app/screens/profile/welcome_profile/welcome_profile.dart';

// extension LoginExtension on LoginModel? {
//   handleLoginProcess({bool shouldStoreData = true}) {
//     LoginModel? loginResponse = this;
//     if (loginResponse != null && loginResponse.token.isNotEmpty) {
//       userData = loginResponse;
//       if (shouldStoreData) {
//         this!.storeDataLocally(AppKeys.userData, userData.toJson());
//       }

//       Get.offAll(
//         () => userData.profileCompletion
//             ? const Dashboard()
//             : const WelcomeProfileScreen(),
//       );
//     }
//   }
// }
