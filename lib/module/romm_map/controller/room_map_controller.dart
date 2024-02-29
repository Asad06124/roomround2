import 'package:roomrounds/core/constants/imports.dart';

enum Urgent { yes, no }

class RoomMapController extends GetxController {
  Urgent _urgent = Urgent.no;

  Urgent get isUrgent => _urgent;

  void onUrgentChange(Urgent urgent) {
    _urgent = urgent;
    update();
  }
}
