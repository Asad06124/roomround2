import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/app_enum.dart';
import 'package:roomrounds/core/constants/urls.dart';

mixin EmployeeMixin {
  Future<List<Employee>> getEmployeeList({
    String? search,
    int? managerId,
    int? departmentId,
    bool? managersOnly,
  }) async {
    List<Employee> list = [];

    Map<String, dynamic> data = {
      "search": search?.trim(),
      "isManager": managersOnly,
      "departmentId": departmentId,
      "managerId": managerId,
      "pageNo": 1,
      "size": 20,
      "isPagination": true,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllEmployee,
      dataMap: data,
      fromJson: Employee.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is List && resp.isNotEmpty) {
      list = List.from(resp);
    }
    return list;
  }

  List<String> getEmployeesNamesList(List<Employee> list) {
    List<String> names = [];

    if (list.isNotEmpty) {
      for (var emp in list) {
        String? name = emp.employeeName?.trim();
        if (name != null && name.isNotEmpty) {
          names.add(name);
        }
      }
    }

    return names;
  }
}
