import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/notifications/notification_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';

class NotificationController extends GetxController {
  // bool _isClearAll = false;
  // bool get isClearAll => _isClearAll;

  // final List<String> notifList = [
  //   'New task added in template',
  //   'Task assigned to you',
  //   'New task is removed',
  //   'Template task is completed',
  // ];

  bool hasData = false;
  bool hasUnreadNotifications = false;

  /* List<NotificationModel> _notificationsList = [
    NotificationModel(
      notificationId: 21,
      notificationTitle: 'New task added in template please update your task',
    ),
    NotificationModel(
      notificationId: 22,
      notificationTitle: 'Task assigned to you should complete it on time',
    ),
    NotificationModel(
      notificationId: 23,
      notificationTitle:
          'New task is removed. Another Task will be assigned to you',
    ),
    NotificationModel(
      notificationId: 24,
      notificationTitle:
          'Template task is completed. You can work on another task',
    ),
  ]; */

  List<NotificationModel> _notificationsList = [];

  List<NotificationModel> get notificationsList => _notificationsList;

  @override
  void onInit() {
    super.onInit();
    _fetchNotificationsList();
  }

  void _fetchNotificationsList() async {
    _updateHasData(false);

    Map<String, dynamic> data = {
      "isRead": false,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
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
        APIMethods.get,
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
      APIMethods.get,
      Urls.readAllNotifications,
      showLoader: true,
      showErrorMessage: true,
    );

    if (resp != null && resp is bool && resp == true) {
      _notificationsList.clear();
      update();
    }
    // _isClearAll = true;
    // update();
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
