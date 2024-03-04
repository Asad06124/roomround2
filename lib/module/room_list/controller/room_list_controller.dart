import 'package:roomrounds/core/constants/imports.dart';

class RoomListController extends GetxController {
  final List<YesNo> _tasks = [];

  List<YesNo> get tasks => _tasks;

  @override
  void onInit() {
    super.onInit();
    _createTaskaList();
  }

  void _createTaskaList() {
    for (var i = 0; i < 5; i++) {
      _tasks.add(YesNo.no);
    }
  }

  chnageTaskStatus(YesNo value, int index) {
    _tasks[index] = value;
    update();
  }
}
