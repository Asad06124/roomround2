import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

import '../../../utils/custom_overlays.dart';

class RoomListController extends GetxController {
  RoomType _roomType = RoomType.allRooms;

  RoomType get roomType => _roomType;

  bool hasData = false;

  List<Room> _roomsList = [];

  List<Room> get roomsList => _roomsList;

  VoidCallback? onAllRoomsCompleted;

  // Flag to indicate if returning from task list view
  bool fromTaskList = false;

  @override
  void onInit() {
    super.onInit();
    fetchRoomsList();
  }

  Future<void> fetchRoomsList({bool hasData = false}) async {
    int? managerId = profileController.userId;
    bool? roomStatus = getRoomStatus();
    _updateHasData(hasData);

    Map<String, dynamic> data = {
      "managerId": managerId,
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
    bool allRoomsCompleted = roomsList.isNotEmpty &&
        roomsList.every((room) => room.roomStatus == true);
    if (allRoomsCompleted && fromTaskList) {
      onAllRoomsCompleted?.call();
      Get.back(closeOverlays: true);
      CustomOverlays.showToastMessage(
        message: 'Template complete',
        isSuccess: true,
        title: 'Success!',
      );
      fromTaskList = false; // Reset the flag
    }
    update();
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
    fetchRoomsList();
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
