class EmployeeListResponseModel {
  final bool succeeded;
  final String message;
  final int httpStatusCode;
  final int totalCounts;
  final List<Employee>? data;

  EmployeeListResponseModel({
    required this.succeeded,
    required this.message,
    required this.httpStatusCode,
    required this.totalCounts,
    this.data,
  });

  factory EmployeeListResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeListResponseModel(
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? '',
      httpStatusCode: json['httpStatusCode'] ?? 0,
      totalCounts: json['totalCounts'] ?? 0,
      data: json['data'] != null
          ? List<Employee>.from(json['data'].map((x) => Employee.fromJson(x)))
          : null,
    );
  }
}

class Employee {
  final int userId;
  final int roleId;
  final String? imageKey;
  final String employeeName;
  final String firstName;
  final String lastName;
  final String roleName;
  final String departmentName;
  final int departmentId;
  final String email;
  final String phoneNumber;
  final int roomCount;

  Employee({
    required this.userId,
    required this.roleId,
    this.imageKey,
    required this.employeeName,
    required this.firstName,
    required this.lastName,
    required this.roleName,
    required this.departmentName,
    required this.departmentId,
    required this.email,
    required this.phoneNumber,
    required this.roomCount,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      userId: json['userId'] ?? 0,
      roleId: json['roleId'] ?? 0,
      imageKey: json['imageKey'],
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      roleName: json['roleName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      departmentId: json['departmentId'] ?? 0,
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      roomCount: json['roomCount'] ?? 0,
    );
  }
}
