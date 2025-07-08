import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/notifications/notification_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

import '../../../core/services/badge_counter.dart';
import '../../push_notification/push_notification.dart';

class NotificationController extends GetxController
    with WidgetsBindingObserver {
  bool hasData = false;
  RxBool hasUnreadNotifications = false.obs;
  final List<NotificationModel> _notificationsList = [];

  List<NotificationModel> get notificationsList => _notificationsList;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchNotificationsList();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
       BadgeCountService.resetBadgeCount(profileController.user!.userId.toString());

      fetchNotificationsList(forceRefresh: true);
    }
  }

  Future<void> fetchNotificationsList({bool forceRefresh = false}) async {
    if (!forceRefresh && hasData) return;

    _updateHasData(false);

    Map<String, dynamic> data = {
      // "isRead": false,
      // "pageNo": 1,
      // "size": 20,
      // "isPagination": false,
      "receiverId": profileController.user?.userId,
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
      _notificationsList.clear();
      _notificationsList.addAll(List.from(resp));
      hasUnreadNotifications.value =
          _notificationsList.any((n) => n.isRead == false);
    } else {
      _notificationsList.clear();
      hasUnreadNotifications.value = false;
    }
    _updateHasData(true);
  }

  Future<void> removeNotification(int? id) async {
    if (id == null) return;

    String params = "?id=$id";
    var resp = await APIFunction.call(
      APIMethods.delete,
      Urls.deleteSingleNotification + params,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    if (resp != null && resp is bool && resp) {
      try {
        _notificationsList.removeWhere((item) => item.notificationId == id);
        hasUnreadNotifications.value =
            _notificationsList.any((n) => n.isRead == false);
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

  Future<void> clearAllNotifications() async {
    var resp = await APIFunction.call(
      APIMethods.delete,
      Urls.deleteAllNotifications,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    if (resp != null && resp is bool && resp) {
      _notificationsList.clear();
      hasUnreadNotifications.value = false;
      update();
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.readAllNotifications,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is bool && resp) {
      for (var notification in _notificationsList) {
        notification.isRead = true;
      }
      hasUnreadNotifications.value = false;
      update();
    }
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
