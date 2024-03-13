import 'package:roomrounds/core/constants/imports.dart';

class RoomMapController extends GetxController {
  YesNo _urgent = YesNo.no;

  YesNo get isUrgent => _urgent;

  void onUrgentChange(YesNo urgent) {
    _urgent = urgent;
    update();
  }
}
