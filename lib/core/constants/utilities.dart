import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:roomrounds/core/constants/imports.dart';

class Utilities {
  static setTextStyle(double size, FontWeight fontWeight,
          {Color color = AppColors.textGrey}) =>
      TextStyle(fontSize: size, fontWeight: fontWeight, color: color);

  static showErrorMessage(
      {String title = 'Error', String? error, int? miliSecond = 800}) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    return Get.snackbar(title, error ?? "Something went wrong, Try again",
        colorText: AppColors.red,
        backgroundColor: AppColors.white,
        animationDuration: Duration(milliseconds: miliSecond ?? 0));
  }

  static showSuccessMessage(
      {String title = 'Success', String? message, int? miliSecond = 800}) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    return Get.snackbar(title, message ?? "Successfully done",
        colorText: AppColors.primary,
        backgroundColor: AppColors.white,
        animationDuration: Duration(milliseconds: miliSecond ?? 0));
  }

  static Future<bool> hasConnection() async {
    bool isConnected = false;

    try {
      isConnected = await InternetConnection().hasInternetAccess;
    } catch (e) {
      customLogger(
        e.toString(),
        error: 'hasConnection',
        type: LoggerType.error,
      );
    }

    return isConnected;
  }

  // static String formatIntoCompleteDate(String? dateTime) {
  //   DateFormat formatter = DateFormat('dd/MM/yyyy');
  //   if (dateTime != null) {
  //     return formatter.format(DateTime.parse(dateTime)).toString();
  //   }
  //   return "";
  // }
}

Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // Number of method calls to be displayed
    errorMethodCount: 8, // Number of method calls if stacktrace is provided
    lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    // Should each log print contain a timestamp
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

void customLogger(String? message,
    {var error, LoggerType type = LoggerType.debug}) {
  if (!kReleaseMode) {
    switch (type) {
      case LoggerType.info:
        _logger.i(message);
        break;
      case LoggerType.warning:
        _logger.w(message);
        break;
      case LoggerType.error:
        _logger.e(message, error: error);
        break;
      default:
        _logger.d(message);
        break;
    }
  }
}
