// class Ticket {
//   int? ticketId;
//   int? statusId;
//   String? ticketName;
//   String? assignDate;
//   String? comment;
//   String? roomName;
//   String? floorName;
//   bool? isUrgent;
//   int? assignTo;
//   int? assignTemplateRoomId;
//   String? assignTemplateName;
//   String? completionDate;
//   int? assignBy;
//   String? assignByName;
//   String? assignToName;
//   String? status;

//   Ticket(
//       {this.ticketId,
//       this.statusId,
//       this.ticketName,
//       this.assignDate,
//       this.comment,
//       this.roomName,
//       this.floorName,
//       this.isUrgent,
//       this.assignTo,
//       this.assignTemplateRoomId,
//       this.assignTemplateName,
//       this.completionDate,
//       this.assignBy,
//       this.assignByName,
//       this.assignToName,
//       this.status});

//   Ticket.fromJson(Map<String, dynamic> json) {
//     ticketId = json['ticketId'];
//     statusId = json['statusId'];
//     ticketName = json['ticketName'];
//     assignDate = json['assignDate'];
//     comment = json['comment'];
//     roomName = json['roomName'];
//     floorName = json['floorName'];
//     isUrgent = json['isUrgent'];
//     assignTo = json['assignTo'];
//     assignTemplateRoomId = json['assignTemplateRoomId'];
//     assignTemplateName = json['assignTemplateName'];
//     completionDate = json['completionDate'];
//     assignBy = json['assignBy'];
//     assignByName = json['assignByName'];
//     assignToName = json['assignToName'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ticketId'] = ticketId;
//     data['statusId'] = statusId;
//     data['ticketName'] = ticketName;
//     data['assignDate'] = assignDate;
//     data['comment'] = comment;
//     data['roomName'] = roomName;
//     data['floorName'] = floorName;
//     data['isUrgent'] = isUrgent;
//     data['assignTo'] = assignTo;
//     data['assignTemplateRoomId'] = assignTemplateRoomId;
//     data['assignTemplateName'] = assignTemplateName;
//     data['completionDate'] = completionDate;
//     data['assignBy'] = assignBy;
//     data['assignByName'] = assignByName;
//     data['assignToName'] = assignToName;
//     data['status'] = status;
//     return data;
//   }
// }

class Ticket {
  int? assignTemplateRoomId;
  String? assignTemplateName;
  String? completionDate;
  int? assignBy;
  String? assignByName;
  String? assignToName;
  String? status;
  int? statusId;
  String? roomName;
  String? floorName;
  String? ticketName;
  List<TicketMedia>? ticketMedia;
  int? ticketId;
  String? assignDate;
  String? comment;
  bool? isUrgent;
  int? assignTo;

  Ticket(
      {this.assignTemplateRoomId,
      this.assignTemplateName,
      this.completionDate,
      this.assignBy,
      this.assignByName,
      this.assignToName,
      this.status,
      this.statusId,
      this.roomName,
      this.floorName,
      this.ticketName,
      this.ticketMedia,
      this.ticketId,
      this.assignDate,
      this.comment,
      this.isUrgent,
      this.assignTo});

  Ticket.fromJson(Map<String, dynamic> json) {
    assignTemplateRoomId = json['assignTemplateRoomId'];
    assignTemplateName = json['assignTemplateName'];
    completionDate = json['completionDate'];
    assignBy = json['assignBy'];
    assignByName = json['assignByName'];
    assignToName = json['assignToName'];
    status = json['status'];
    statusId = json['statusId'];
    roomName = json['roomName'];
    floorName = json['floorName'];
    ticketName = json['ticketName'];
    if (json['ticketMedia'] != null) {
      ticketMedia = <TicketMedia>[];
      json['ticketMedia'].forEach((v) {
        ticketMedia!.add(new TicketMedia.fromJson(v));
      });
    }
    ticketId = json['ticketId'];
    assignDate = json['assignDate'];
    comment = json['comment'];
    isUrgent = json['isUrgent'];
    assignTo = json['assignTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assignTemplateRoomId'] = this.assignTemplateRoomId;
    data['assignTemplateName'] = this.assignTemplateName;
    data['completionDate'] = this.completionDate;
    data['assignBy'] = this.assignBy;
    data['assignByName'] = this.assignByName;
    data['assignToName'] = this.assignToName;
    data['status'] = this.status;
    data['statusId'] = this.statusId;
    data['roomName'] = this.roomName;
    data['floorName'] = this.floorName;
    data['ticketName'] = this.ticketName;
    if (this.ticketMedia != null) {
      data['ticketMedia'] = this.ticketMedia!.map((v) => v.toJson()).toList();
    }
    data['ticketId'] = this.ticketId;
    data['assignDate'] = this.assignDate;
    data['comment'] = this.comment;
    data['isUrgent'] = this.isUrgent;
    data['assignTo'] = this.assignTo;
    return data;
  }
}

class TicketMedia {
  String? imagekey;
  String? audioKey;
  int? ticketsMediaId;
  int? ticketId;

  TicketMedia(
      {this.imagekey, this.audioKey, this.ticketsMediaId, this.ticketId});

  TicketMedia.fromJson(Map<String, dynamic> json) {
    imagekey = json['imagekey'];
    audioKey = json['audioKey'];
    ticketsMediaId = json['ticketsMediaId'];
    ticketId = json['ticketId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagekey'] = this.imagekey;
    data['audioKey'] = this.audioKey;
    data['ticketsMediaId'] = this.ticketsMediaId;
    data['ticketId'] = this.ticketId;
    return data;
  }
}
