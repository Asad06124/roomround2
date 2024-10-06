class NotificationModel {
  int? notificationId;
  String? notificationTitle;
  String? notificationDescription;
  int? senderId;
  int? receiverId;
  bool? isRead;
  String? senderName;
  String? senderImage;
  String? receiverName;
  String? receiverImage;

  NotificationModel(
      {this.notificationId,
      this.notificationTitle,
      this.notificationDescription,
      this.senderId,
      this.receiverId,
      this.isRead,
      this.senderName,
      this.senderImage,
      this.receiverName,
      this.receiverImage});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    notificationTitle = json['notificationTitle'];
    notificationDescription = json['notificationDescription'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    isRead = json['isRead'];
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
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['isRead'] = isRead;
    data['senderName'] = senderName;
    data['senderImage'] = senderImage;
    data['receiverName'] = receiverName;
    data['receiverImage'] = receiverImage;
    return data;
  }
}
