import '../employee/employee_model.dart';

class Department {
  int? departmentId;
  String? departmentName;
  int? managerId;
  String? description;
  String? manager;
  List<Employee>? employeeDepartments;

  Department(
      {this.departmentId,
      this.departmentName,
      this.managerId,
      this.description,
      this.manager,
      this.employeeDepartments});

  Department.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    managerId = json['managerId'];
    description = json['description'];
    manager = json['manager'];
    if (json['employeeDepartments'] != null) {
      employeeDepartments = <Employee>[];
      json['employeeDepartments'].forEach((v) {
        employeeDepartments!.add(Employee.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['managerId'] = managerId;
    data['description'] = description;
    data['manager'] = manager;
    if (employeeDepartments != null) {
      data['employeeDepartments'] =
          employeeDepartments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
