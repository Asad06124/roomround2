import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/notifications/notification_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class NotificationController extends GetxController {
  bool hasData = false;
  bool hasUnreadNotifications = false;
  List<NotificationModel> _notificationsList = [];

  List<NotificationModel> get notificationsList => _notificationsList;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationsList();
  }

  void fetchNotificationsList() async {
    _updateHasData(false);

    Map<String, dynamic> data = {
      "isRead": false,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
      "receiverId": profileController.userId,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllNotifications,
      dataMap: data,
      fromJson: NotificationModel.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is List && resp.isNotEmpty) {
      _notificationsList = List.from(resp);
      hasUnreadNotifications = _notificationsList.isNotEmpty;
    }
    _updateHasData(true);
  }

  void removeNotification(int? id) async {
    if (id != null) {
      String params = "?id=$id";
      var resp = await APIFunction.call(
        APIMethods.post,
        Urls.readNotification + params,
        showLoader: true,
        showErrorMessage: true,
      );

      if (resp != null && resp is bool && resp == true) {
        try {
          notificationsList.removeWhere((item) => item.notificationId == id);
          update();
        } catch (e) {
          customLogger(
            'Error: $e',
            error: 'removeNotification',
            type: LoggerType.error,
          );
        }
      }
    }
  }

  void clearAllNotifications() async {
    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.readAllNotifications,
      showLoader: true,
      showErrorMessage: true,
    );

    if (resp != null && resp is bool && resp == true) {
      _notificationsList.clear();
      update();
    }
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
