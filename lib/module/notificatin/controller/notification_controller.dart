import 'package:roomrounds/core/constants/imports.dart';

class NotificationController extends GetxController {
  bool _isClearAll = false;
  bool get isClearAll => _isClearAll;

  clearAll() {
    _isClearAll = true;
    update();
  }
}
