class User {
  int? userId;
  String? username;
  String? email;
  bool? rememberMe;
  int? roleId;
  String? role;
  int? organizationId;
  String? image;
  String? token;

  User(
      {this.userId,
      this.username,
      this.email,
      this.rememberMe,
      this.roleId,
      this.role,
      this.organizationId,
      this.image,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    email = json['email'];
    rememberMe = json['rememberMe'];
    roleId = json['roleId'];
    role = json['role'];
    organizationId = json['organizationId'];
    image = json['image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['rememberMe'] = rememberMe;
    data['roleId'] = roleId;
    data['role'] = role;
    data['organizationId'] = organizationId;
    data['image'] = image;
    data['token'] = token;
    return data;
  }
}
