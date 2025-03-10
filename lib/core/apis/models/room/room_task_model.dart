import 'package:roomrounds/core/apis/models/room/room_task_ticket_model.dart';
import 'package:roomrounds/core/constants/app_enum.dart';

class RoomTask {
  // int? assignTemplateRoomId;
  int? assignTemplateTaskId;
  int? roomId;
  int? managerId;
  bool? isDeleted;
  bool? isCompleted;
  bool? taskCompletion;
  String? roomName;
  String? taskName;
  bool? roomStatus;
  bool? isNA;
  bool? taskStatus;
  TicketData? ticketData;
  YesNo? userSelection;

  RoomTask({
    // this.assignTemplateRoomId,
    this.assignTemplateTaskId,
    this.roomId,
    this.managerId,
    this.isDeleted,
    this.isCompleted,
    this.taskCompletion,
    this.roomName,
    this.taskName,
    this.roomStatus,
    this.isNA,
    this.taskStatus,
    this.userSelection,
    this.ticketData,
  });

  RoomTask.fromJson(Map<String, dynamic> json) {
    // assignTemplateRoomId = json['assignTemplateRoomId'];
    assignTemplateTaskId = json['assignTemplateTaskId'];
    roomId = json['roomId'];
    managerId = json['managerId'];
    isDeleted = json['isDeleted'];
    isCompleted = json['isCompleted'];
    taskCompletion = json['taskCompletion'];
    roomName = json['roomName'];
    taskName = json['taskName'];
    roomStatus = json['roomStatus'];
    isNA = json['isNA'];
    taskStatus = json['taskStatus'];
    if (json['ticketData'] != null) {
      ticketData = TicketData.fromJson(json['ticketData']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assignTemplateTaskId'] = assignTemplateTaskId;
    data['roomId'] = roomId;
    data['managerId'] = managerId;
    data['isDeleted'] = isDeleted;
    data['isCompleted'] = isCompleted;
    data['taskCompletion'] = taskCompletion;
    data['roomName'] = roomName;
    data['taskName'] = taskName;
    data['roomStatus'] = roomStatus;
    data['isNA'] = isNA;
    data['taskStatus'] = taskStatus;
    if (ticketData != null) {
      data['ticketData'] = ticketData!.toJson();
    }
    return data;
  }
}
