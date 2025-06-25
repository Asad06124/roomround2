class NotificationModel {
  int? notificationId;
  String? notificationTitle;
  String? notificationDescription;
  String? createdDate;
  int? senderId;
  int? receiverId;
  bool? isRead;
  bool? isAssignTemplateActive;
  String? senderName;
  String? senderImage;
  String? receiverName;
  String? receiverImage;

  NotificationModel(
      {this.notificationId,
      this.notificationTitle,
      this.notificationDescription,
      this.createdDate,
      this.senderId,
      this.receiverId,
      this.isRead,
      this.isAssignTemplateActive,
      this.senderName,
      this.senderImage,
      this.receiverName,
      this.receiverImage});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    notificationTitle = json['notificationTitle'];
    notificationDescription = json['notificationDescription'];
    createdDate = json['createdDate'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    isRead = json['isRead'];
    isAssignTemplateActive = json['isAssignTemplateActive'];
    senderName = json['senderName'];
    senderImage = json['senderImage'];
    receiverName = json['receiverName'];
    receiverImage = json['receiverImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['notificationTitle'] = notificationTitle;
    data['notificationDescription'] = notificationDescription;
    data['createdDate'] = createdDate;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['isRead'] = isRead;
    data['isAssignTemplateActive'] = isAssignTemplateActive;
    data['senderName'] = senderName;
    data['senderImage'] = senderImage;
    data['receiverName'] = receiverName;
    data['receiverImage'] = receiverImage;
    return data;
  }
}
