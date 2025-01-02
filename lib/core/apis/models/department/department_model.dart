// import '../employee/employee_model.dart';

// class Department {
//   int? departmentId;
//   String? departmentName;
//   int? managerId;
//   String? description;
//   String? manager;
//   bool? unassigned;
//   bool? isMyEmpDepartment;
//   bool? isAssignedEmployee;
//   List<Employee>? employeeDepartments;

//   Department({
//     this.departmentId,
//     this.departmentName,
//     this.managerId,
//     this.description,
//     this.manager,
//     this.unassigned,
//     this.isMyEmpDepartment,
//     this.isAssignedEmployee,
//     this.employeeDepartments,
//   });

//   Department.fromJson(Map<String, dynamic> json) {
//     departmentId = json['departmentId'];
//     departmentName = json['departmentName'];
//     managerId = json['managerId'];
//     description = json['description'];
//     unassigned = json['unassigned'];
//     isMyEmpDepartment = json['isMyEmpDepartment'];
//     isAssignedEmployee = json['isAssignedEmployee'];
//     manager = json['manager'];
//     if (json['employeeDepartments'] != null) {
//       employeeDepartments = <Employee>[];
//       json['employeeDepartments'].forEach((v) {
//         employeeDepartments!.add(Employee.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['departmentId'] = departmentId;
//     data['departmentName'] = departmentName;
//     data['managerId'] = managerId;
//     data['description'] = description;
//     data['unassigned'] = unassigned;
//     data['isMyEmpDepartment'] = isMyEmpDepartment;
//     data['isAssignedEmployee'] = isAssignedEmployee;
//     data['manager'] = manager;
//     if (employeeDepartments != null) {
//       data['employeeDepartments'] =
//           employeeDepartments!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Department {
  int? pageNo;
  int? size;
  String? search;
  bool? isPagination;
  String? sortBy;
  String? sortDirection;
  int? departmentId;
  String? departmentName;
  String? manager;
  String? description;
  int? managerId;
  bool? unassigned;
  bool? isMyEmpDepartment;
  bool? isAssignedEmployee;

  Department(
      {this.pageNo,
      this.size,
      this.search,
      this.isPagination,
      this.sortBy,
      this.sortDirection,
      this.departmentId,
      this.departmentName,
      this.manager,
      this.description,
      this.managerId,
      this.unassigned,
      this.isMyEmpDepartment,
      this.isAssignedEmployee});

  Department.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    size = json['size'];
    search = json['search'];
    isPagination = json['isPagination'];
    sortBy = json['sortBy'];
    sortDirection = json['sortDirection'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    manager = json['manager'];
    description = json['description'];
    managerId = json['managerId'];
    unassigned = json['unassigned'];
    isMyEmpDepartment = json['isMyEmpDepartment'];
    isAssignedEmployee = json['isAssignedEmployee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNo'] = pageNo;
    data['size'] = size;
    data['search'] = search;
    data['isPagination'] = isPagination;
    data['sortBy'] = sortBy;
    data['sortDirection'] = sortDirection;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['manager'] = manager;
    data['description'] = description;
    data['managerId'] = managerId;
    data['unassigned'] = unassigned;
    data['isMyEmpDepartment'] = isMyEmpDepartment;
    data['isAssignedEmployee'] = isAssignedEmployee;
    return data;
  }
}
