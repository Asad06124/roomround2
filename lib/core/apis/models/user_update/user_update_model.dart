class UserUpdate {
  String? userName;
  String? email;
  String? image;

  UserUpdate({this.userName, this.email, this.image});

  UserUpdate.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}
