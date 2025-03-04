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
  bool? isCompleted;
  String? assignByName;
  String? assignByFCMToken;
  String? assignToFCMToken;
  String? assignByImage;
  String? assignToName;
  String? assignToImage;
  String? status;
  int? statusId;
  String? roomName;
  String? floorName;
  String? ticketName;
  List<TicketMedia>? ticketMedia;

  Ticket({
    this.ticketId,
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
    this.isCompleted,
    this.assignByName,
    this.assignToFCMToken,
    this.assignByFCMToken,
    this.assignByImage,
    this.assignToName,
    this.assignToImage,
    this.status,
    this.statusId,
    this.roomName,
    this.floorName,
    this.ticketName,
    this.ticketMedia,
  });

  // CopyWith Method
  Ticket copyWith({
    int? ticketId,
    String? assignDate,
    String? comment,
    bool? isUrgent,
    int? assignTo,
    bool? isClosed,
    String? reply,
    int? assignTemplateRoomId,
    String? assignTemplateName,
    String? completionDate,
    int? assignBy,
    bool? isCompleted,
    String? assignByName,
    String? assignByFCMToken,
    String? assignToFCMToken,
    String? assignByImage,
    String? assignToName,
    String? assignToImage,
    String? status,
    int? statusId,
    String? roomName,
    String? floorName,
    String? ticketName,
    List<TicketMedia>? ticketMedia,
  }) {
    return Ticket(
      ticketId: ticketId ?? this.ticketId,
      assignDate: assignDate ?? this.assignDate,
      comment: comment ?? this.comment,
      isUrgent: isUrgent ?? this.isUrgent,
      assignTo: assignTo ?? this.assignTo,
      isClosed: isClosed ?? this.isClosed,
      reply: reply ?? this.reply,
      assignTemplateRoomId: assignTemplateRoomId ?? this.assignTemplateRoomId,
      assignTemplateName: assignTemplateName ?? this.assignTemplateName,
      completionDate: completionDate ?? this.completionDate,
      assignBy: assignBy ?? this.assignBy,
      isCompleted: isCompleted ?? this.isCompleted,
      assignByName: assignByName ?? this.assignByName,
      assignByFCMToken: assignByFCMToken ?? this.assignByFCMToken,
      assignToFCMToken: assignToFCMToken ?? this.assignToFCMToken,
      assignByImage: assignByImage ?? this.assignByImage,
      assignToName: assignToName ?? this.assignToName,
      assignToImage: assignToImage ?? this.assignToImage,
      status: status ?? this.status,
      statusId: statusId ?? this.statusId,
      roomName: roomName ?? this.roomName,
      floorName: floorName ?? this.floorName,
      ticketName: ticketName ?? this.ticketName,
      ticketMedia: ticketMedia ?? this.ticketMedia,
    );
  }

  // From JSON Constructor
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
    isCompleted = json['isCompleted'];
    assignByName = json['assignByName'];
    assignByFCMToken = json['assignByFCMToken'];
    assignToFCMToken = json['assignToFCMToken'];
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

  // To JSON Method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ticketId'] = ticketId;
    data['assignDate'] = assignDate;
    data['comment'] = comment;
    data['isUrgent'] = isUrgent;
    data['assignTo'] = assignTo;
    data['isClosed'] = isClosed;
    data['reply'] = reply;
    data['assignTemplateRoomId'] = assignTemplateRoomId;
    data['assignTemplateName'] = assignTemplateName;
    data['completionDate'] = completionDate;
    data['assignBy'] = assignBy;
    data['isCompleted'] = isCompleted;
    data['assignByName'] = assignByName;
    data['assignByFCMToken'] = assignByFCMToken;
    data['assignToFCMToken'] = assignToFCMToken;
    data['assignByImage'] = assignByImage;
    data['assignToName'] = assignToName;
    data['assignToImage'] = assignToImage;
    data['status'] = status;
    data['statusId'] = statusId;
    data['roomName'] = roomName;
    data['floorName'] = floorName;
    data['ticketName'] = ticketName;
    if (ticketMedia != null) {
      data['ticketMedia'] = ticketMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketMedia {
  int? ticketsMediaId;
  int? ticketId;
  String? imagekey;
  String? audioKey;

  TicketMedia({
    this.ticketsMediaId,
    this.ticketId,
    this.imagekey,
    this.audioKey,
  });

  // CopyWith Method
  TicketMedia copyWith({
    int? ticketsMediaId,
    int? ticketId,
    String? imagekey,
    String? audioKey,
  }) {
    return TicketMedia(
      ticketsMediaId: ticketsMediaId ?? this.ticketsMediaId,
      ticketId: ticketId ?? this.ticketId,
      imagekey: imagekey ?? this.imagekey,
      audioKey: audioKey ?? this.audioKey,
    );
  }

  // From JSON Constructor
  TicketMedia.fromJson(Map<String, dynamic> json) {
    ticketsMediaId = json['ticketsMediaId'];
    ticketId = json['ticketId'];
    imagekey = json['imagekey'];
    audioKey = json['audioKey'];
  }

  // To JSON Method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ticketsMediaId'] = ticketsMediaId;
    data['ticketId'] = ticketId;
    data['imagekey'] = imagekey;
    data['audioKey'] = audioKey;
    return data;
  }
}
