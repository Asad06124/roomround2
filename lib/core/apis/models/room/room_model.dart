class Room {
  int? roomId;
  int? managerId;
  int? assignTemplateRoomId;
  String? roomName;
  String? floorName;
  String? templateName;
  String? comment;
  String? latitude;
  String? longitude;
  String? managerName;
  String? imageKey;
  bool? roomStatus;
  TaskProgress? taskProgress;

  Room({
    this.roomId,
    this.managerId,
    this.assignTemplateRoomId,
    this.roomName,
    this.floorName,
    this.templateName,
    this.comment,
    this.latitude,
    this.longitude,
    this.managerName,
    this.imageKey,
    this.roomStatus,
    this.taskProgress,
  });

  Room.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    managerId = json['managerId'];
    assignTemplateRoomId = json['assignTemplateRoomId'];
    roomName = json['roomName'];
    floorName = json['floorName'];
    templateName = json['templateName'];
    comment = json['comment'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    managerName = json['managerName'];
    imageKey = json['imageKey'];
    roomStatus = json['roomStatus'];
    taskProgress = json['taskProgress'] != null
        ? TaskProgress.fromJson(json['taskProgress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomId'] = roomId;
    data['managerId'] = managerId;
    data['assignTemplateRoomId'] = assignTemplateRoomId;
    data['roomName'] = roomName;
    data['floorName'] = floorName;
    data['templateName'] = templateName;
    data['comment'] = comment;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['managerName'] = managerName;
    data['imageKey'] = imageKey;
    data['roomStatus'] = roomStatus;
    if (taskProgress != null) {
      data['taskProgress'] = taskProgress!.toJson();
    }
    return data;
  }
}

class TaskProgress {
  int? totalTasksCount;
  int? completedTasksCount;
  int? totalTicketCount;

  TaskProgress({
    this.totalTasksCount,
    this.completedTasksCount,
    this.totalTicketCount,
  });

  TaskProgress.fromJson(Map<String, dynamic> json) {
    totalTasksCount = json['totalTasksCount'];
    completedTasksCount = json['completedTasksCount'];
    totalTicketCount = json['totalTicketCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTasksCount'] = totalTasksCount;
    data['completedTasksCount'] = completedTasksCount;
    data['totalTicketCount'] = totalTicketCount;
    return data;
  }
}
