import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/department/department_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class DepartmentsController extends GetxController {
  List<Department> _departments = [];

  List<Department> get departments => _departments;

  Department? _selectedDepartment;

  Department? get selectedDepartment => _selectedDepartment;
  int? get selectedDepartmentId => _selectedDepartment?.departmentId;

  bool hasData = false;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getDepartments();
  // }

  Future<List<Department>> getDepartments({
    int? departmentId,
    bool? unassigned,
    bool? isMyEmpDepartment,
    bool? isAssignedEmployee,
  }) async {
    _updateHasData(false);

    Map<String, dynamic> data = {
      // "managerId": managerId,
      // "managerId": 3, // Testing
      "departmentId": departmentId,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
      "unassigned": unassigned,
      "isMyEmpDepartment": isMyEmpDepartment,
      "isAssignedEmployee": isAssignedEmployee,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllDepartments,
      dataMap: data,
      fromJson: Department.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is List && resp.isNotEmpty) {
      _departments = List.from(resp);
    }
    _updateHasData(true);
    return _departments;
  }

  List<String> getDepartmentsNames() {
    List<String> names = ['Department'];

    if (_departments.isNotEmpty) {
      for (var dep in _departments) {
        String? name = dep.departmentName?.trim();
        if (name != null && name.isNotEmpty) {
          names.add(name);
        }
      }
    }

    return names;
  }

  Department? selectMyDepartment() {
    if (_departments.isNotEmpty) {
      int? departmentId = profileController.departmentId;

      _selectedDepartment = _departments
          .firstWhereOrNull((dep) => dep.departmentId == departmentId);
    }
    return _selectedDepartment;
  }

  void onDepartmentSelect(String? name) {
    if (name != null && name.trim().isNotEmpty) {
      if (name == 'Select') {
        _selectedDepartment = null;
      } else if (_departments.isNotEmpty) {
        Department? department = _departments
            .firstWhereOrNull((dep) => dep.departmentName?.trim() == name);
        if (department != null) {
          _selectedDepartment = department;
        }
      }
    } else {
      _selectedDepartment = null;
    }
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
