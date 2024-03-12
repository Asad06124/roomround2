// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:up_down_app/Widgets/custom_loader.dart';
// import 'package:up_down_app/core/constants/imports.dart';
// // import 'package:up_down_app/core/extensions/login_extension.dart';

// mixin SocialSignIn {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Widget socialButton(BuildContext context) => Column(
//         children: [
//           AppButton.primary(
//             background: context.scaffoldBackgroundColor,
//             onPressed: _signInWithGoogle,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Assets.icons.socials.google.svg(),
//                 Text(
//                   AppStrings.continueWithGoogle,
//                   style: context.titleMedium?.copyWith(
//                     color: context.onPrimary,
//                   ),
//                 ),
//                 const SizedBox(),
//               ],
//             ),
//           ),
//           if (Platform.isIOS) ...[
//             SB.h(10),
//             AppButton.primary(
//               background: context.scaffoldBackgroundColor,
//               onPressed: _signInWithApple,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Assets.icons.socials.apple.svg(),
//                   Text(
//                     AppStrings.continueWithApple,
//                     style: context.titleMedium?.copyWith(
//                       color: context.onPrimary,
//                     ),
//                   ),
//                   const SizedBox(),
//                 ],
//               ),
//             ),
//           ]
//         ],
//       );

//   Future<void> _signInWithGoogle() async {
//     Get.dialog(const CustomLoader());

//     try {
//       final GoogleSignInAccount? credential = await _googleSignIn.signIn();
//       if (credential != null) {
//         _signInWithAPIs(await _createDataMap(
//           name: credential.displayName,
//           email: credential.email,
//           type: 'google',
//         ));
//         _googleSignIn.signOut();
//       }
//       Get.back();

//       log(credential.toString());
//     } catch (error) {
//       print(error);
//       Get.back();
//     }
//   }

//   Future<void> _signInWithApple() async {
//     Get.dialog(const CustomLoader());
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       print(credential);

//       _signInWithAPIs(await _createDataMap(
//         id: credential.userIdentifier,
//         name: "${credential.givenName ?? ''} ${credential.familyName ?? ''}",
//         email: credential.email,
//         type: 'apple',
//       ));

//       Get.back();
//     } catch (error) {
//       print(error);
//       Get.back();
//     }
//   }

//   Future<void> _signInWithAPIs(Map<String, String?> data) async {
//     final LoginModel? loginResponse = await apiCall(
//       POST,
//       Urls.socialSignIn,
//       data,
//       model: LoginModel(),
//       showLoader: false,
//     );
//     loginResponse.handleLoginProcess();
//   }

//   Future<Map<String, String?>> _createDataMap(
//           {String? name,
//           String? email,
//           required String type,
//           String? id}) async =>
//       {
//         if (id != null) 'apple_id': id,
//         'name': name,
//         if (email != null) 'email': email,
//         'type': type,
//         'fcm_token': await _firebaseMessaging.getToken(),
//       };
// }
