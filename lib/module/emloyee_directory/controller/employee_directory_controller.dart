import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/department/department_model.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';

enum TicketsType { assignedMe, assignedTo, sendTo }

class EmployeeDirectoryController extends GetxController {
  TicketsType _ticketsType = TicketsType.assignedMe;
  TicketsType get ticketsType => _ticketsType;

  final TextEditingController searchTextField = TextEditingController();

  List<Employee> _searchResults = [];

  List<Employee> get searchResults => _searchResults;

  final List<String> _employeeTypes = [
    AppStrings.allEmployees,
    AppStrings.allManagers,
  ];

  List<String> get employeeTypes => _employeeTypes;

  bool hasData = false;

  bool managersOnly = false;

  bool myEmployees = false;

  @override
  void onInit() {
    super.onInit();
    _addMyEmployeesType();
    _resetSelectedDepartment();
    onSearch('');
  }

  void _resetSelectedDepartment() {
    departmentsController.onDepartmentSelect(null);
  }

  void _addMyEmployeesType() {
    UserType? userType = profileController.userType;

    if (userType == UserType.manager) {
      _employeeTypes.add(AppStrings.myEmployees);
    }
    try {
      bool? searchTeam = Get.arguments?["myTeam"] as bool?;
      if (searchTeam != null) {
        myEmployees = searchTeam;
      }
    } catch (e) {
      customLogger(
        "$e",
        error: '_addMyEmployeesType',
        type: LoggerType.error,
      );
    }
  }

  void onSearch(String? text) async {
    _updateHasData(false);

    int? departmentId = departmentsController.selectedDepartmentId;
    int? managerId;
    if (myEmployees) {
      managerId = profileController.userId;
    }

    Map<String, dynamic> data = {
      "search": text?.trim(),
      "isManager": managersOnly,
      "departmentId": departmentId,
      "managerId": managerId,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
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
      _searchResults = List.from(resp);
    } else {
      _searchResults = [];
    }
    _updateHasData(true);
  }

  void onChangeEmployeeType(String? type) {
    switch (type) {
      case AppStrings.myEmployees:
        managersOnly = false;
        myEmployees = true;
        break;
      case AppStrings.allManagers:
        managersOnly = true;
        myEmployees = false;
        break;
      case AppStrings.allEmployees:
        managersOnly = false;
        myEmployees = false;
        break;
      default:
        break;
    }
    onSearch(searchTextField.text);
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }

  void changeTicketsType(String val) {
    if (userData.type == UserType.employee) {
      if (val == 'Assigned Me') {
        _ticketsType = TicketsType.assignedMe;
      } else {
        _ticketsType = TicketsType.sendTo;
      }
    } else {
      changeTicketsTypeManager(val);
    }
    update();
  }

  void changeTicketsTypeManager(String val) {
    if (val == 'Assigned Me') {
      _ticketsType = TicketsType.assignedMe;
    } else {
      _ticketsType = TicketsType.assignedTo;
    }
  }
}

class DepartmentsController extends GetxController {
  List<Department> _departments = [];

  List<Department> get departments => _departments;

  Department? _selectedDepartment;

  Department? get selectedDepartment => _selectedDepartment;
  int? get selectedDepartmentId => _selectedDepartment?.departmentId;

  bool hasData = false;

  @override
  void onInit() {
    super.onInit();
    _getDepartments();
  }

  void _getDepartments() async {
    _updateHasData(false);

    Map<String, dynamic> data = {
      // "managerId": managerId,
      // "managerId": 3, // Testing
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
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
  }

  List<String> getDepartmentsNames() {
    List<String> names = [];

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

  void onDepartmentSelect(String? name) {
    if (name != null && name.isNotEmpty) {
      if (_departments.isNotEmpty) {
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
