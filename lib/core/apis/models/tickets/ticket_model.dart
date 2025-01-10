// class Ticket {
//   int? assignTemplateRoomId;
//   String? assignTemplateName;
//   String? completionDate;
//   int? assignBy;
//   String? assignByName;
//   String? assignToName;
//   String? status;
//   int? statusId;
//   String? roomName;
//   String? floorName;
//   String? ticketName;
//   List<TicketMedia>? ticketMedia;
//   int? ticketId;
//   String? assignDate;
//   String? comment;
//   bool? isUrgent;
//   int? assignTo;

//   Ticket(
//       {this.assignTemplateRoomId,
//       this.assignTemplateName,
//       this.completionDate,
//       this.assignBy,
//       this.assignByName,
//       this.assignToName,
//       this.status,
//       this.statusId,
//       this.roomName,
//       this.floorName,
//       this.ticketName,
//       this.ticketMedia,
//       this.ticketId,
//       this.assignDate,
//       this.comment,
//       this.isUrgent,
//       this.assignTo});

//   Ticket.fromJson(Map<String, dynamic> json) {
//     assignTemplateRoomId = json['assignTemplateRoomId'];
//     assignTemplateName = json['assignTemplateName'];
//     completionDate = json['completionDate'];
//     assignBy = json['assignBy'];
//     assignByName = json['assignByName'];
//     assignToName = json['assignToName'];
//     status = json['status'];
//     statusId = json['statusId'];
//     roomName = json['roomName'];
//     floorName = json['floorName'];
//     ticketName = json['ticketName'];
//     if (json['ticketMedia'] != null) {
//       ticketMedia = <TicketMedia>[];
//       json['ticketMedia'].forEach((v) {
//         ticketMedia!.add(TicketMedia.fromJson(v));
//       });
//     }
//     ticketId = json['ticketId'];
//     assignDate = json['assignDate'];
//     comment = json['comment'];
//     isUrgent = json['isUrgent'];
//     assignTo = json['assignTo'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['assignTemplateRoomId'] = assignTemplateRoomId;
//     data['assignTemplateName'] = assignTemplateName;
//     data['completionDate'] = completionDate;
//     data['assignBy'] = assignBy;
//     data['assignByName'] = assignByName;
//     data['assignToName'] = assignToName;
//     data['status'] = status;
//     data['statusId'] = statusId;
//     data['roomName'] = roomName;
//     data['floorName'] = floorName;
//     data['ticketName'] = ticketName;
//     if (ticketMedia != null) {
//       data['ticketMedia'] = ticketMedia!.map((v) => v.toJson()).toList();
//     }
//     data['ticketId'] = ticketId;
//     data['assignDate'] = assignDate;
//     data['comment'] = comment;
//     data['isUrgent'] = isUrgent;
//     data['assignTo'] = assignTo;
//     return data;
//   }
// }

// class TicketMedia {
//   String? imagekey;
//   String? audioKey;
//   int? ticketsMediaId;
//   int? ticketId;

//   TicketMedia(
//       {this.imagekey, this.audioKey, this.ticketsMediaId, this.ticketId});

//   TicketMedia.fromJson(Map<String, dynamic> json) {
//     imagekey = json['imagekey'];
//     audioKey = json['audioKey'];
//     ticketsMediaId = json['ticketsMediaId'];
//     ticketId = json['ticketId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['imagekey'] = imagekey;
//     data['audioKey'] = audioKey;
//     data['ticketsMediaId'] = ticketsMediaId;
//     data['ticketId'] = ticketId;
//     return data;
//   }
// }

// class Ticket {
//   int? ticketId;
//   String? assignDate;
//   String? comment;
//   bool? isUrgent;
//   int? assignTo;
//   int? assignTemplateRoomId;
//   String? assignTemplateName;
//   String? completionDate;
//   int? assignBy;
//   String? assignByName;
//   String? assignByImage;
//   String? assignToName;
//   String? assignToImage;
//   String? status;
//   int? statusId;
//   String? roomName;
//   String? floorName;
//   String? ticketName;
//   List<TicketMedia>? ticketMedia;

//   Ticket(
//       {this.ticketId,
//       this.assignDate,
//       this.comment,
//       this.isUrgent,
//       this.assignTo,
//       this.assignTemplateRoomId,
//       this.assignTemplateName,
//       this.completionDate,
//       this.assignBy,
//       this.assignByName,
//       this.assignByImage,
//       this.assignToName,
//       this.assignToImage,
//       this.status,
//       this.statusId,
//       this.roomName,
//       this.floorName,
//       this.ticketName,
//       this.ticketMedia});

//   Ticket.fromJson(Map<String, dynamic> json) {
//     ticketId = json['ticketId'];
//     assignDate = json['assignDate'];
//     comment = json['comment'];
//     isUrgent = json['isUrgent'];
//     assignTo = json['assignTo'];
//     assignTemplateRoomId = json['assignTemplateRoomId'];
//     assignTemplateName = json['assignTemplateName'];
//     completionDate = json['completionDate'];
//     assignBy = json['assignBy'];
//     assignByName = json['assignByName'];
//     assignByImage = json['assignByImage'];
//     assignToName = json['assignToName'];
//     assignToImage = json['assignToImage'];
//     status = json['status'];
//     statusId = json['statusId'];
//     roomName = json['roomName'];
//     floorName = json['floorName'];
//     ticketName = json['ticketName'];
//     if (json['ticketMedia'] != null) {
//       ticketMedia = <TicketMedia>[];
//       json['ticketMedia'].forEach((v) {
//         ticketMedia!.add(TicketMedia.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ticketId'] = ticketId;
//     data['assignDate'] = assignDate;
//     data['comment'] = comment;
//     data['isUrgent'] = isUrgent;
//     data['assignTo'] = assignTo;
//     data['assignTemplateRoomId'] = assignTemplateRoomId;
//     data['assignTemplateName'] = assignTemplateName;
//     data['completionDate'] = completionDate;
//     data['assignBy'] = assignBy;
//     data['assignByName'] = assignByName;
//     data['assignByImage'] = assignByImage;
//     data['assignToName'] = assignToName;
//     data['assignToImage'] = assignToImage;
//     data['status'] = status;
//     data['statusId'] = statusId;
//     data['roomName'] = roomName;
//     data['floorName'] = floorName;
//     data['ticketName'] = ticketName;
//     if (ticketMedia != null) {
//       data['ticketMedia'] = ticketMedia!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class TicketMedia {
//   int? ticketsMediaId;
//   int? ticketId;
//   String? imagekey;
//   String? audioKey;

//   TicketMedia(
//       {this.ticketsMediaId, this.ticketId, this.imagekey, this.audioKey});

//   TicketMedia.fromJson(Map<String, dynamic> json) {
//     ticketsMediaId = json['ticketsMediaId'];
//     ticketId = json['ticketId'];
//     imagekey = json['imagekey'];
//     audioKey = json['audioKey'];
//   }

// ignore_for_file: prefer_collection_literals, unnecessary_this

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ticketsMediaId'] = ticketsMediaId;
//     data['ticketId'] = ticketId;
//     data['imagekey'] = imagekey;
//     data['audioKey'] = audioKey;
//     return data;
//   }
// }
class Ticket {
  int? ticketId;
  String? assignDate;
  String? comment;
  bool? isUrgent;
  int? assignTo;
  bool? isClosed;
  String? reply;
  int? assignTemplateRoomId;
  String? assignTemplateName;
  String? completionDate;
  int? assignBy;
  String? assignByName;
  String? assignByImage;
  String? assignToName;
  String? assignToImage;
  String? status;
  int? statusId;
  String? roomName;
  String? floorName;
  String? ticketName;
  List<TicketMedia>? ticketMedia;

  Ticket(
      {this.ticketId,
      this.assignDate,
      this.comment,
      this.isUrgent,
      this.assignTo,
      this.isClosed,
      this.reply,
      this.assignTemplateRoomId,
      this.assignTemplateName,
      this.completionDate,
      this.assignBy,
      this.assignByName,
      this.assignByImage,
      this.assignToName,
      this.assignToImage,
      this.status,
      this.statusId,
      this.roomName,
      this.floorName,
      this.ticketName,
      this.ticketMedia});

  Ticket.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticketId'];
    assignDate = json['assignDate'];
    comment = json['comment'];
    isUrgent = json['isUrgent'];
    assignTo = json['assignTo'];
    isClosed = json['isClosed'];
    reply = json['reply'];
    assignTemplateRoomId = json['assignTemplateRoomId'];
    assignTemplateName = json['assignTemplateName'];
    completionDate = json['completionDate'];
    assignBy = json['assignBy'];
    assignByName = json['assignByName'];
    assignByImage = json['assignByImage'];
    assignToName = json['assignToName'];
    assignToImage = json['assignToImage'];
    status = json['status'];
    statusId = json['statusId'];
    roomName = json['roomName'];
    floorName = json['floorName'];
    ticketName = json['ticketName'];
    if (json['ticketMedia'] != null) {
      ticketMedia = <TicketMedia>[];
      json['ticketMedia'].forEach((v) {
        ticketMedia!.add(TicketMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ticketId'] = this.ticketId;
    data['assignDate'] = this.assignDate;
    data['comment'] = this.comment;
    data['isUrgent'] = this.isUrgent;
    data['assignTo'] = this.assignTo;
    data['isClosed'] = this.isClosed;
    data['reply'] = this.reply;
    data['assignTemplateRoomId'] = this.assignTemplateRoomId;
    data['assignTemplateName'] = this.assignTemplateName;
    data['completionDate'] = this.completionDate;
    data['assignBy'] = this.assignBy;
    data['assignByName'] = this.assignByName;
    data['assignByImage'] = this.assignByImage;
    data['assignToName'] = this.assignToName;
    data['assignToImage'] = this.assignToImage;
    data['status'] = this.status;
    data['statusId'] = this.statusId;
    data['roomName'] = this.roomName;
    data['floorName'] = this.floorName;
    data['ticketName'] = this.ticketName;
    if (this.ticketMedia != null) {
      data['ticketMedia'] = this.ticketMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketMedia {
  int? ticketsMediaId;
  int? ticketId;
  String? imagekey;
  String? audioKey;

  TicketMedia(
      {this.ticketsMediaId, this.ticketId, this.imagekey, this.audioKey});

  TicketMedia.fromJson(Map<String, dynamic> json) {
    ticketsMediaId = json['ticketsMediaId'];
    ticketId = json['ticketId'];
    imagekey = json['imagekey'];
    audioKey = json['audioKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ticketsMediaId'] = this.ticketsMediaId;
    data['ticketId'] = this.ticketId;
    data['imagekey'] = this.imagekey;
    data['audioKey'] = this.audioKey;
    return data;
  }
}
