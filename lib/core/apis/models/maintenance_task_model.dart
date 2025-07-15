// maintenance_task_model.dart
// Model for Maintenance Task API response

import 'package:roomrounds/core/apis/models/room/room_task_ticket_model.dart';

class MaintenanceTask {
  int? maintenanceTaskId;
  String? maintenanceTaskName;
  String? maintenanceTaskDescription;
  int? recurrencePatternId;
  String? recurrencePatternName;
  String? occurrenceDate;
  MaintenanceTaskComplete? maintenanceTaskCompletes;
  TicketData? ticketData;
  MaintenanceTaskAssigns? maintenanceTaskAssigns;
  MaintenanceTaskDocuments? maintenanceTaskDocuments;

  MaintenanceTask({
    this.maintenanceTaskId,
    this.maintenanceTaskName,
    this.maintenanceTaskDescription,
    this.recurrencePatternId,
    this.recurrencePatternName,
    this.occurrenceDate,
    this.maintenanceTaskCompletes,
    this.ticketData,
    this.maintenanceTaskAssigns,
    this.maintenanceTaskDocuments,
  });

  MaintenanceTask.fromJson(Map<String, dynamic> json) {
    maintenanceTaskId = json['maintenanceTaskId'];
    maintenanceTaskName = json['maintenanceTaskName'];
    maintenanceTaskDescription = json['maintenanceTaskDescription'];
    recurrencePatternId = json['recurrencePatternId'];
    recurrencePatternName = json['recurrencePatternName'];
    occurrenceDate = json['occurrenceDate'];
    maintenanceTaskCompletes = json['maintenanceTaskCompletes'] != null
        ? MaintenanceTaskComplete.fromJson(json['maintenanceTaskCompletes'])
        : null;
    ticketData = json['ticketData'] != null
        ? TicketData.fromJson(json['ticketData'])
        : null;
    maintenanceTaskAssigns = json['maintenanceTaskAssigns'] != null
        ? MaintenanceTaskAssigns.fromJson(json['maintenanceTaskAssigns'])
        : null;
    maintenanceTaskDocuments = json['maintenanceTaskDocuments'] != null
        ? MaintenanceTaskDocuments.fromJson(json['maintenanceTaskDocuments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenanceTaskId'] = maintenanceTaskId;
    data['maintenanceTaskName'] = maintenanceTaskName;
    data['maintenanceTaskDescription'] = maintenanceTaskDescription;
    data['recurrencePatternId'] = recurrencePatternId;
    data['recurrencePatternName'] = recurrencePatternName;
    data['occurrenceDate'] = occurrenceDate;
    data['maintenanceTaskCompletes'] = maintenanceTaskCompletes?.toJson();
    data['ticketData'] = ticketData?.toJson();
    data['maintenanceTaskAssigns'] = maintenanceTaskAssigns?.toJson();
    data['maintenanceTaskDocuments'] = maintenanceTaskDocuments?.toJson();
    return data;
  }
}

class MaintenanceTaskComplete {
  int? maintenanceTaskCompleteId;
  int? maintenanceTaskId;
  String? maintenanceOccurrenceDate;
  bool? isCompleted;
  String? completedDate;
  String? comment;
  List<MaintenanceTaskMedia>? maintenanceTaskMedias;

  MaintenanceTaskComplete({
    this.maintenanceTaskCompleteId,
    this.maintenanceTaskId,
    this.maintenanceOccurrenceDate,
    this.isCompleted,
    this.completedDate,
    this.comment,
    this.maintenanceTaskMedias,
  });

  MaintenanceTaskComplete.fromJson(Map<String, dynamic> json) {
    maintenanceTaskCompleteId = json['maintenanceTaskCompleteId'];
    maintenanceTaskId = json['maintenanceTaskId'];
    maintenanceOccurrenceDate = json['maintenanceOccurrenceDate'];
    isCompleted = json['isCompleted'];
    completedDate = json['completedDate'];
    comment = json['comment'];
    maintenanceTaskMedias = json['maintenanceTaskMedias'] != null
        ? List<MaintenanceTaskMedia>.from(json['maintenanceTaskMedias']
            .map((x) => MaintenanceTaskMedia.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenanceTaskCompleteId'] = maintenanceTaskCompleteId;
    data['maintenanceTaskId'] = maintenanceTaskId;
    data['maintenanceOccurrenceDate'] = maintenanceOccurrenceDate;
    data['isCompleted'] = isCompleted;
    data['completedDate'] = completedDate;
    data['comment'] = comment;
    data['maintenanceTaskMedias'] = maintenanceTaskMedias != null
        ? List<dynamic>.from(maintenanceTaskMedias!.map((x) => x.toJson()))
        : null;
    return data;
  }
}

class MaintenanceTaskMedia {
  int? maintenanceTaskMediaId;
  int? maintenanceTaskCompleteId;
  String? imageKey;
  String? audioKey;
  String? documentPath;

  MaintenanceTaskMedia({
    this.maintenanceTaskMediaId,
    this.maintenanceTaskCompleteId,
    this.imageKey,
    this.audioKey,
    this.documentPath,
  });

  MaintenanceTaskMedia.fromJson(Map<String, dynamic> json) {
    maintenanceTaskMediaId = json['maintenanceTaskMediaId'];
    maintenanceTaskCompleteId = json['maintenanceTaskCompleteId'];
    imageKey = json['imageKey'];
    audioKey = json['audioKey'];
    documentPath = json['documentPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenanceTaskMediaId'] = maintenanceTaskMediaId;
    data['maintenanceTaskCompleteId'] = maintenanceTaskCompleteId;
    data['imageKey'] = imageKey;
    data['audioKey'] = audioKey;
    data['documentPath'] = documentPath;
    return data;
  }
}

class MaintenanceTaskAssigns {
  int? maintenanceTaskAssignId;
  int? maintenanceTaskId;
  int? departmentId;
  String? departmentName;
  int? userId;
  String? userName;
  String? imagekey;

  MaintenanceTaskAssigns({
    this.maintenanceTaskAssignId,
    this.maintenanceTaskId,
    this.departmentId,
    this.departmentName,
    this.userId,
    this.userName,
    this.imagekey,
  });

  MaintenanceTaskAssigns.fromJson(Map<String, dynamic> json) {
    maintenanceTaskAssignId = json['maintenanceTaskAssignId'];
    maintenanceTaskId = json['maintenanceTaskId'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    userId = json['userId'];
    userName = json['userName'];
    imagekey = json['imagekey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenanceTaskAssignId'] = maintenanceTaskAssignId;
    data['maintenanceTaskId'] = maintenanceTaskId;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['userId'] = userId;
    data['userName'] = userName;
    data['imagekey'] = imagekey;
    return data;
  }
}

class MaintenanceTaskDocuments {
  int? maintenanceTaskDocumentId;
  int? maintenanceTaskId;
  String? documentPath;
  String? uploadDatetime;

  MaintenanceTaskDocuments({
    this.maintenanceTaskDocumentId,
    this.maintenanceTaskId,
    this.documentPath,
    this.uploadDatetime,
  });

  MaintenanceTaskDocuments.fromJson(Map<String, dynamic> json) {
    maintenanceTaskDocumentId = json['maintenanceTaskDocumentId'];
    maintenanceTaskId = json['maintenanceTaskId'];
    documentPath = json['documentPath'];
    uploadDatetime = json['uploadDatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenanceTaskDocumentId'] = maintenanceTaskDocumentId;
    data['maintenanceTaskId'] = maintenanceTaskId;
    data['documentPath'] = documentPath;
    data['uploadDatetime'] = uploadDatetime;
    return data;
  }
}
