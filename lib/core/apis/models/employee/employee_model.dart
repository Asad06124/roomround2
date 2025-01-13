class Employee {
  int? userId;
  int? roleId;
  int? employeeId;
  String? imageKey;
  String? employeeImage;
  String? employeeName;
  String? firstName;
  String? lastName;
  String? roleName;
  String? departmentName;
  int? departmentId;
  int? employeeDepartmentId;
  String? email;
  String? phoneNumber;
  int? roomCount;
  bool? isDeleted;
  String? fcmToken; // Added property for FCM token

  Employee(
      {this.userId,
        this.roleId,
        this.employeeId,
        this.imageKey,
        this.employeeImage,
        this.employeeName,
        this.firstName,
        this.lastName,
        this.roleName,
        this.departmentName,
        this.departmentId,
        this.employeeDepartmentId,
        this.email,
        this.phoneNumber,
        this.roomCount,
        this.isDeleted,
        this.fcmToken}); // Added fcmToken to constructor

  Employee.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    roleId = json['roleId'];
    employeeId = json['employeeId'];
    imageKey = json['imageKey'];
    employeeImage = json['employeeImage'];
    employeeName = json['employeeName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    roleName = json['roleName'];
    departmentName = json['departmentName'];
    departmentId = json['departmentId'];
    employeeDepartmentId = json['employeeDepartmentId'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    roomCount = json['roomCount'];
    isDeleted = json['isDeleted'];
    fcmToken = json['fcmToken']; // Extract fcmToken from JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['roleId'] = roleId;
    data['employeeId'] = employeeId;
    data['imageKey'] = imageKey;
    data['employeeImage'] = employeeImage;
    data['employeeName'] = employeeName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['roleName'] = roleName;
    data['departmentName'] = departmentName;
    data['departmentId'] = departmentId;
    data['employeeDepartmentId'] = employeeDepartmentId;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['roomCount'] = roomCount;
    data['isDeleted'] = isDeleted;
    data['fcmToken'] = fcmToken; // Include fcmToken when converting to JSON
    return data;
  }

  @override
  String toString() {
    return employeeName ?? '';
  }
}
