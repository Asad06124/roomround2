class Room {
  String? managerName;
  String? imageKey;
  String? roomStatus;
  int? roomId;
  int? managerId;
  String? roomName;
  String? floorName;
  String? comment;
  String? latitude;
  String? longitude;

  Room(
      {this.managerName,
      this.imageKey,
      this.roomStatus,
      this.roomId,
      this.managerId,
      this.roomName,
      this.floorName,
      this.comment,
      this.latitude,
      this.longitude});

  Room.fromJson(Map<String, dynamic> json) {
    managerName = json['managerName'];
    imageKey = json['imageKey'];
    roomStatus = json['roomStatus'];
    roomId = json['roomId'];
    managerId = json['managerId'];
    roomName = json['roomName'];
    floorName = json['floorName'];
    comment = json['comment'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['managerName'] = managerName;
    data['imageKey'] = imageKey;
    data['roomStatus'] = roomStatus;
    data['roomId'] = roomId;
    data['managerId'] = managerId;
    data['roomName'] = roomName;
    data['floorName'] = floorName;
    data['comment'] = comment;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
