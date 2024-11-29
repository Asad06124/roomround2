class Ticket {
  int? ticketId;
  int? statusId;
  String? ticketName;
  String? assignDate;
  String? comment;
  String? roomName;
  String? floorName;
  bool? isUrgent;
  int? assignTo;
  int? assignTemplateRoomId;
  String? assignTemplateName;
  String? completionDate;
  int? assignBy;
  String? assignByName;
  String? assignToName;
  String? status;

  Ticket(
      {this.ticketId,
      this.statusId,
      this.ticketName,
      this.assignDate,
      this.comment,
      this.roomName,
      this.floorName,
      this.isUrgent,
      this.assignTo,
      this.assignTemplateRoomId,
      this.assignTemplateName,
      this.completionDate,
      this.assignBy,
      this.assignByName,
      this.assignToName,
      this.status});

  Ticket.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticketId'];
    statusId = json['statusId'];
    ticketName = json['ticketName'];
    assignDate = json['assignDate'];
    comment = json['comment'];
    roomName = json['roomName'];
    floorName = json['floorName'];
    isUrgent = json['isUrgent'];
    assignTo = json['assignTo'];
    assignTemplateRoomId = json['assignTemplateRoomId'];
    assignTemplateName = json['assignTemplateName'];
    completionDate = json['completionDate'];
    assignBy = json['assignBy'];
    assignByName = json['assignByName'];
    assignToName = json['assignToName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticketId'] = ticketId;
    data['statusId'] = statusId;
    data['ticketName'] = ticketName;
    data['assignDate'] = assignDate;
    data['comment'] = comment;
    data['roomName'] = roomName;
    data['floorName'] = floorName;
    data['isUrgent'] = isUrgent;
    data['assignTo'] = assignTo;
    data['assignTemplateRoomId'] = assignTemplateRoomId;
    data['assignTemplateName'] = assignTemplateName;
    data['completionDate'] = completionDate;
    data['assignBy'] = assignBy;
    data['assignByName'] = assignByName;
    data['assignToName'] = assignToName;
    data['status'] = status;
    return data;
  }
}
