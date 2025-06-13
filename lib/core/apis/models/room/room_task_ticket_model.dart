import '../tickets/ticket_model.dart';

class TicketData {
  int? ticketId;
  int? taskId;
  String? taskName;
  String? comment;
  bool? isUrgent;
  bool? isIssueResolved;
  int? assignedBy;
  String? assignedByName;
  String? assignedByImageKey;
  int? assignTo;
  String? assignToName;
  String? assignToImageKey;
  List<TicketMedia>? ticketMedia;

  TicketData({
    this.ticketId,
    this.taskId,
    this.taskName,
    this.comment,
    this.isUrgent,
    this.isIssueResolved,
    this.assignedBy,
    this.assignedByName,
    this.assignedByImageKey,
    this.assignTo,
    this.assignToName,
    this.assignToImageKey,
    this.ticketMedia,
  });

  TicketData copyWith({
    int? ticketId,
    int? taskId,
    String? taskName,
    String? comment,
    bool? isUrgent,
    bool? isIssueResolved,
    int? assignedBy,
    String? assignedByName,
    String? assignedByImageKey,
    int? assignTo,
    String? assignToName,
    String? assignToImageKey,
    List<TicketMedia>? ticketMedia,
  }) {
    return TicketData(
      ticketId: ticketId ?? this.ticketId,
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      comment: comment ?? this.comment,
      isUrgent: isUrgent ?? this.isUrgent,
      isIssueResolved: isIssueResolved ?? this.isIssueResolved,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedByName: assignedByName ?? this.assignedByName,
      assignedByImageKey: assignedByImageKey ?? this.assignedByImageKey,
      assignTo: assignTo ?? this.assignTo,
      assignToName: assignToName ?? this.assignToName,
      assignToImageKey: assignToImageKey ?? this.assignToImageKey,
      ticketMedia: ticketMedia ?? this.ticketMedia,
    );
  }

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticketId: json['ticketId'],
      taskId: json['taskId'],
      taskName: json['taskName'],
      comment: json['comment'],
      isIssueResolved: json['isIssueResolved'],
      isUrgent: json['isUrgent'],
      assignedBy: json['assignedBy'],
      assignedByName: json['assignedByName'],
      assignedByImageKey: json['assignedByImageKey'],
      assignTo: json['assignTo'],
      assignToName: json['assignToName'],
      assignToImageKey: json['assignToImageKey'],
      ticketMedia: json['ticketMedia'] != null
          ? List<TicketMedia>.from(
              json['ticketMedia'].map((x) => TicketMedia.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'taskId': taskId,
      'taskName': taskName,
      'comment': comment,
      'isUrgent': isUrgent,
      'assignedBy': assignedBy,
      'assignedByName': assignedByName,
      'assignedByImageKey': assignedByImageKey,
      'assignTo': assignTo,
      'assignToName': assignToName,
      'assignToImageKey': assignToImageKey,
      'ticketMedia': ticketMedia != null
          ? List<dynamic>.from(ticketMedia!.map((x) => x.toJson()))
          : [],
    };
  }
}
