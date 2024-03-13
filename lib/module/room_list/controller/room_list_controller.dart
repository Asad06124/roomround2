import 'package:roomrounds/core/constants/imports.dart';

enum RoomType { allRooms, complete, incomplete }

class TaskListController extends GetxController {
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

class RoomListController extends GetxController {
  RoomType _roomType = RoomType.allRooms;
  RoomType get roomType => _roomType;

  chnageRoomType(String text) {
    if (text == 'All Rooms') {
      _roomType = RoomType.allRooms;
    } else if (text == 'Completed') {
      _roomType = RoomType.complete;
    } else {
      _roomType = RoomType.incomplete;
    }
    update();
  }
}
