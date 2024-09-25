
class Employee {
  int? employeeDepartmentId;
  int? departmentId;
  int? employeeId;
  bool? isDeleted;
  String? employeeName;
  String? employeeImage;

  Employee(
      {this.employeeDepartmentId,
      this.departmentId,
      this.employeeId,
      this.isDeleted,
      this.employeeName,
      this.employeeImage});

  Employee.fromJson(Map<String, dynamic> json) {
    employeeDepartmentId = json['employeeDepartmentId'];
    departmentId = json['departmentId'];
    employeeId = json['employeeId'];
    isDeleted = json['isDeleted'];
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeDepartmentId'] = employeeDepartmentId;
    data['departmentId'] = departmentId;
    data['employeeId'] = employeeId;
    data['isDeleted'] = isDeleted;
    data['employeeName'] = employeeName;
    data['employeeImage'] = employeeImage;
    return data;
  }
}
