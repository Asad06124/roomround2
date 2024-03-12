// // ignore_for_file: constant_identifier_names

// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// // import 'package:logger/logger.dart';
// import 'dart:io';

// import 'package:roomrounds/core/constants/imports.dart';

// const String GET = "GET";
// const String POST = "POST";
// const String PUT = "PUT";
// const String UPDATE = "UPDATE";
// const String DELETE = "DELETE";
// const String PATCH = "PATCH";

// Future<dynamic> apiCall(
//   String method,
//   String endPoint,
//   var dataMap, {
//   var model,
//   bool showLoader = true,
//   File? file,
//   String? fileKey,
//   bool showSuccessMessage = false,
//   bool showErrorMessage = true,
//   bool getOnlyStatusCode = false,
// }) async {
//   final String url = "${Urls.baseUrl}$endPoint";

//   log(userData.token);

//   if (!await _checkInternetConnectivity()) {
//     showSnackBar('No internet connection');
//     // Get.back();
//     return false;
//   }
//   if (showLoader) Get.dialog(const CustomLoader());

//   try {
//     var headers = {
//       "Authorization": "token ${userData.token}",
//       "Content-Type": "application/json"
//     };

//     var request;

//     if (file != null) {
//       request = http.MultipartRequest(method, Uri.parse(url));
//       request.fields.addAll(dataMap);
//       request.files.add(
//         await http.MultipartFile.fromPath(fileKey ?? "", file.path),
//       );
//     } else {
//       request = http.Request(method, Uri.parse(url));
//       request.body = jsonEncode(dataMap);
//     }
//     request.headers.addAll(headers);
//     log("Url: $url"
//         "\nInput Data: ${json.encode(dataMap)}");
//     http.StreamedResponse response = await request.send();

//     if (getOnlyStatusCode) {
//       return response.statusCode;
//     }

//     String? data = await response.stream.bytesToString();
//     log("Response Data $data");

//     if (response.statusCode == 401 && userData.token.isNotEmpty) {
//       Get.back();
//       Get.offAll(() => WelcomeScreen());
//       storageBox.erase();
//       userData = LoginModel();
//       return null;
//     }
//     final decodedResponse = json.decode(data);

//     final BaseModel baseModel = BaseModel.fromJson(decodedResponse);

//     var result;
//     if (response.statusCode == 200 && (baseModel.status ?? false)) {
//       // log(baseModel.result.toString());

//       if (baseModel.data != null) {
//         if (model != null) {
//           if (baseModel.data is List) {
//             result = [];
//             for (final data in baseModel.data) {
//               result.add(model.fromJson(data));
//             }
//             log(result.length.toString());
//           } else {
//             // Logger().e(baseModel.data);
//             result = model.fromJson(baseModel.data);
//             log("result");
//             log(result.toString());
//           }
//         }
//       }

//       if (showLoader) Get.back();
//       if (showSuccessMessage) showSnackBar(baseModel.message);
//       return result ?? baseModel.data ?? baseModel.status ?? false;
//     }
//     if (showLoader) Get.back();
//     if (showErrorMessage) {
//       showSnackBar(baseModel.message, backgroundColor: AppColors.red);
//     }
//     // Utilities.showErrorMessage(error: baseModel.message);

//     return null; // chnage return false to null for handle error
//   } catch (e) {
//     if (showLoader) Get.back();
//     if (showErrorMessage) showSnackBar(e.toString());
//     return null;
//   }
// }

// dynamic get apiHeader => {
//       "Authorization": "token ${userData.token}",
//       "Content-Type": "application/json"
//     };

import 'package:roomrounds/core/constants/imports.dart';

void showSnackBar(String? message,
    {Color backgroundColor = AppColors.primary}) {
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  final snackBar = SnackBar(
    content: Text(
      message ?? "",
      style: const TextStyle(color: AppColors.white),
    ),
    backgroundColor: backgroundColor,
    // showCloseIcon: true,
    // closeIconColor: AppColors.white,
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}

// Future<bool> _checkInternetConnectivity() async {
//   bool hasInternet = false;
//   final connectivityResult = await Connectivity().checkConnectivity();
//   if (connectivityResult == ConnectivityResult.none) {
//     return hasInternet;
//   }
//   // return await InternetConnectionChecker().hasConnection;
//   return Future.value(true);
// }
