import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:roomrounds/core/apis/models/base_model/base_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class APIFunction {
  static Future<dynamic> call(
    APIMethods method,
    String endPoint, {
    var dataMap,
    // var model,
    File? file,
    String? fileKey,
    String? audioKey,
    String? imageKey,
    List<File>? imageListFile,
    List<File>? audioListFile,
    bool showLoader = true,
    bool showErrorMessage = true,
    bool showSuccessMessage = false,
    bool getOnlyStatusCode = false,
    bool getStatusOnly = false,
    Map<String, String>? customHeaders,
    Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final String url = Urls.apiBaseUrl + endPoint;
      final Uri uri = Uri.parse(url);
      final String apiMethod = method.name.toUpperCase();
      if (showLoader) CustomOverlays.showLoader();
      // log(userData.token);
      bool isConnected = await Utilities.hasConnection();

      if (isConnected == false) {
        // No Internet connection
        if (showLoader) CustomOverlays.dismissLoader();
        // CustomOverlays.showSnackBar(AppStrings.noInternetConnection);
        CustomOverlays.showToastMessage(
            message: AppStrings.noInternetConnection);

        return null;
      }

      Map<String, String> headers = _apiHeaders(customHeaders: customHeaders);
      // customLogger("Headers: $headers");

      http.BaseRequest request;
      String encodedData = jsonEncode(dataMap);
      log("datamap Data $encodedData");

      if (file != null) {
        // Multipart request for file upload
        var multipartRequest = http.MultipartRequest(apiMethod, uri);
        multipartRequest.fields.addAll(dataMap);
        multipartRequest.files.add(
          await http.MultipartFile.fromPath(fileKey ?? "", file.path),
        );
        request = multipartRequest;
      } else if (imageListFile != null || audioListFile != null) {
        // Multipart request for file upload
        var multipartRequest = http.MultipartRequest(apiMethod, uri);
        multipartRequest.fields.addAll(dataMap);
        if (imageListFile != null) {
          for (var element in imageListFile) {
            multipartRequest.files.add(
              await http.MultipartFile.fromPath(imageKey ?? "", element.path),
            );
          }
        }
        if (audioListFile != null) {
          for (var element in audioListFile) {
            multipartRequest.files.add(
              await http.MultipartFile.fromPath(audioKey ?? "", element.path),
            );
          }
        }
        request = multipartRequest;
      } else {
        // Standard request for non-file data
        var normalRequest = http.Request(apiMethod, uri);
        normalRequest.body = encodedData;
        request = normalRequest;
      }

      request.headers.addAll(headers);

      customLogger(
        "Url: $url"
        "\nPayload: $encodedData",
      );

      http.StreamedResponse response = await request.send();

      if (getOnlyStatusCode) {
        return response.statusCode;
      }

      String? data = await response.stream.bytesToString();

      customLogger(
        "Url: $url \nResponse (${response.statusCode}): $data",
        type: LoggerType.info,
      );

      if (showLoader) CustomOverlays.dismissLoader();

      String? errorMessage;

      if (data.isNotEmpty) {
        final decodedResponse = json.decode(data);
        final BaseModel baseModel = BaseModel.fromJson(decodedResponse);

        var result;
        if (response.statusCode == 200 && (baseModel.succeeded ?? false)) {
          // log(baseModel.result.toString());

          var respData = baseModel.data;
          if (respData != null && fromJson != null) {
            if (respData is List) {
              result = [];
              for (final data in respData) {
                result.add(fromJson(data));
              }
              customLogger("$endPoint Results: ${result.length}");
            } else {
              // if (respData is Map) {
              // Logger().e(baseModel.data);
              result = fromJson(respData);
              // customLogger("Result: $result");
              // }
            }
          }

          if (showSuccessMessage) {
            CustomOverlays.showToastMessage(
                message: baseModel.message, isSuccess: true);
          }
          return result ?? respData ?? baseModel.succeeded ?? false;
        } else if (response.statusCode == 401 &&
            profileController.userToken?.isNotEmpty == true) {
          // Logout
          profileController.logout();
          // In case ShowError = false
          CustomOverlays.showToastMessage(message: baseModel.message);
          return null;
        }
        errorMessage = baseModel.message;
      }

      if (showErrorMessage) {
        CustomOverlays.showToastMessage(message: errorMessage);
      }
      // Utilities.showErrorMessage(error: baseModel.message);

      return null; // Change return false to null for handle error
    } catch (e) {
      if (showLoader) CustomOverlays.dismissLoader();
      if (showErrorMessage) {
        CustomOverlays.showToastMessage(message: e.toString());
      }

      customLogger(
        e.toString(),
        error: 'APIFunction Call',
        type: LoggerType.error,
      );

      return null;
    }
  }

  static Map<String, String> _apiHeaders({Map<String, String>? customHeaders}) {
    String? token = profileController.userToken;
    Map<String, String> headers = {
      "Authorization": "Bearer ${token ?? ''}",
      "Content-Type": "application/json",
    };
    if (customHeaders != null && customHeaders.isNotEmpty) {
      headers.addAll(customHeaders);
    }
    // customLogger("Headers: $headers");
    return headers;
  }
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


// Future<bool> _checkInternetConnectivity() async {
//   bool hasInternet = false;
//   final connectivityResult = await Connectivity().checkConnectivity();
//   if (connectivityResult == ConnectivityResult.none) {
//     return hasInternet;
//   }
//   // return await InternetConnectionChecker().hasConnection;
//   return Future.value(true);
// }
