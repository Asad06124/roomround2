import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

enum RoomType { allRooms, complete, incomplete }

class TaskListController extends GetxController {
  final List<YesNo> _tasks = [];

  List<YesNo> get tasks => _tasks;

  final List<String> _tasksTitle = [
    'Arrange audit findings?',
    'Manange audit findings?'
  ];

  List<String> get tasksTitle => _tasksTitle;

  @override
  void onInit() {
    super.onInit();
    _createTaskaList();
  }

  void _createTaskaList() {
    for (var i = 0; i < 2; i++) {
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

  bool hasData = false;

  List<Room> roomsList = [];

  void changeRoomType(String text) {
    if (text == 'All Rooms') {
      _roomType = RoomType.allRooms;
    } else if (text == 'Completed') {
      _roomType = RoomType.complete;
    } else {
      _roomType = RoomType.incomplete;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchRoomsList();
  }

  void _fetchRoomsList() async {
    int? managerId = profileController.userId;

    Map<String, dynamic> data = {
      "managerId": 3,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
    };
    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllRooms,
      dataMap: data,
      fromJson: Room.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    _updateLoader(true);

    if (resp != null  && resp is List && resp.isNotEmpty) {
      roomsList = List.from(resp);
      update();
    }
  }

  void _updateLoader(bool value) {
    hasData = value;
    update();
  }
}
