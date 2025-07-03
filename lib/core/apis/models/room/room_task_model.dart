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
  // bool? isIssueResolved;
  String? action;
  TicketData? ticketData;
  YesNo? userSelection;
  TaskDepartmentManager? taskDepartmentManager;

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
    // this.isIssueResolved,
    this.action,
    this.taskStatus,
    this.userSelection,
    this.ticketData,
    this.taskDepartmentManager,
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
    // isIssueResolved = json['isIssueResolved'];
    action = json['action'];
    taskStatus = json['taskStatus'];
    if (json['ticketData'] != null) {
      ticketData = TicketData.fromJson(json['ticketData']);
    }
    if (json['taskDepartmentManager'] != null) {
      taskDepartmentManager =
          TaskDepartmentManager.fromJson(json['taskDepartmentManager']);
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
    data['action'] = action;
    data['taskName'] = taskName;
    data['roomStatus'] = roomStatus;
    data['isNA'] = isNA;
    // data['isIssueResolved'] = isIssueResolved;
    data['taskStatus'] = taskStatus;
    if (ticketData != null) {
      data['ticketData'] = ticketData!.toJson();
    }
    if (taskDepartmentManager != null) {
      data['taskDepartmentManager'] = taskDepartmentManager!.toJson();
    }
    return data;
  }
}

class TaskDepartmentManager {
  int? userId;
  String? userName;
  String? imageKey;

  TaskDepartmentManager({this.userId, this.userName, this.imageKey});

  TaskDepartmentManager.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    imageKey = json['imageKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['imageKey'] = imageKey;
    return data;
  }
}
