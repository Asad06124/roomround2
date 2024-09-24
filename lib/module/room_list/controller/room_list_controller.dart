import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/apis/models/room/room_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';

class TaskListController extends GetxController {
  // TaskListController({this.roomId});
  int? roomId;
  String? roomName;

  bool hasData = false;

  List<RoomTask> _tasks = [];

  List<RoomTask> get tasks => _tasks;

  // final List<YesNo> _tasks = [];

  // List<YesNo> get tasks => _tasks;

  final List<String> _tasksTitle = [
    'Arrange audit findings?',
    'Manange audit findings?'
  ];

  List<String> get tasksTitle => _tasksTitle;

  @override
  void onInit() {
    super.onInit();
    _getRoomIdAndTasks();
  }

  void _getRoomIdAndTasks() {
    try {
      roomId = Get.arguments['roomId'] as int?;
      roomName = Get.arguments['roomName'] as String?;

      // if (roomId != null) {
      _fetchTasksList(roomId);
      // }
    } catch (e) {
      customLogger(
        e.toString(),
        type: LoggerType.error,
        error: '_getRoomIdAndTasks',
      );
    }
  }

  void _fetchTasksList(int? roomId) async {
    int? managerId = profileController.userId;

    _updateHasData(false);

    Map<String, dynamic> data = {
      "managerId": managerId,
      "roomId": roomId,
      // "roomId": 32, // Testing
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllTasks,
      dataMap: data,
      fromJson: RoomTask.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is List && resp.isNotEmpty) {
      _tasks = List.from(resp);
      // update();
    }

    _updateHasData(true);

    // for (var i = 0; i < 2; i++) {
    //   _tasks.add(YesNo.no);
    // }
  }

  changeTaskStatus(YesNo value, int index) {
    // _tasks[index] = value;
    // update();
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}

class RoomListController extends GetxController {
  RoomType _roomType = RoomType.allRooms;
  RoomType get roomType => _roomType;

  bool hasData = false;

  List<Room> _roomsList = [];

  List<Room> get roomsList => _roomsList;

  @override
  void onInit() {
    super.onInit();
    _fetchRoomsList();
  }

  void _fetchRoomsList() async {
    int? managerId = profileController.userId;
    bool? roomStatus = getRoomStatus();
    _updateHasData(false);

    Map<String, dynamic> data = {
      // "managerId": managerId,
      // "managerId": 3, // Testing
      "roomStatus": roomStatus,
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

    if (resp != null && resp is List && resp.isNotEmpty) {
      _roomsList = List.from(resp);
    } else {
      _roomsList = [];
    }
    _updateHasData(true);
  }

  void changeRoomType(String text) {
    if (text == AppStrings.inProgress) {
      _roomType = RoomType.inProgress;
    } else if (text == AppStrings.complete) {
      _roomType = RoomType.complete;
    } else {
      _roomType = RoomType.allRooms;
    }
    update();
    _fetchRoomsList();
  }

  bool? getRoomStatus() {
    bool? status;

    if (_roomType == RoomType.complete) {
      status = true;
    } else if (_roomType == RoomType.inProgress) {
      status = false;
    }

    return status;
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
