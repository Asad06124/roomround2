import 'package:roomrounds/core/constants/app_enum.dart';

class RoomTask {
  int? assignTemplateRoomId;
  int? assignTemplateTaskId;
  int? roomId;
  int? managerId;
  bool? isDeleted;
  bool? isCompleted;
  String? roomName;
  String? taskName;
  bool? roomStatus;
  bool? taskStatus;

  YesNo? userSelection;

  RoomTask({
    this.assignTemplateRoomId,
    this.assignTemplateTaskId,
    this.roomId,
    this.managerId,
    this.isDeleted,
    this.isCompleted,
    this.roomName,
    this.taskName,
    this.roomStatus,
    this.taskStatus,
    this.userSelection,
  });

  RoomTask.fromJson(Map<String, dynamic> json) {
    assignTemplateRoomId = json['assignTemplateRoomId'];
    assignTemplateTaskId = json['assignTemplateTaskId'];
    roomId = json['roomId'];
    managerId = json['managerId'];
    isDeleted = json['isDeleted'];
    isCompleted = json['isCompleted'];
    roomName = json['roomName'];
    taskName = json['taskName'];
    roomStatus = json['roomStatus'];
    taskStatus = json['taskStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assignTemplateRoomId'] = assignTemplateRoomId;
    data['assignTemplateTaskId'] = assignTemplateTaskId;
    data['roomId'] = roomId;
    data['managerId'] = managerId;
    data['isDeleted'] = isDeleted;
    data['isCompleted'] = isCompleted;
    data['roomName'] = roomName;
    data['taskName'] = taskName;
    data['roomStatus'] = roomStatus;
    data['taskStatus'] = taskStatus;
    return data;
  }
}
