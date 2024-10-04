import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/department/department_model.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';
import 'package:roomrounds/utils/custome_dialogue.dart';

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

  int? myDepartmentId;

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
    try {
      bool isManager = profileController.isManager;

      if (isManager) {
        _employeeTypes.add(AppStrings.myEmployees);
      }

      if (Get.arguments != null) {
        bool? searchTeam = Get.arguments?["myTeam"] as bool?;
        bool? searchManager = Get.arguments?["myManager"] as bool?;
        int? departmentId = Get.arguments?["departmentId"] as int?;
        if (searchTeam != null) {
          myEmployees = searchTeam;
        }
        if (searchManager != null) {
          managersOnly = searchManager;
        }
        if (departmentId != null && departmentId > 0) {
          myDepartmentId = departmentId;
        }
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

    int? departmentId =
        myDepartmentId ?? departmentsController.selectedDepartmentId;
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
      /*  _searchResults = [
         // Dummy Data
        Employee(
          employeeId: 1,
          employeeName: 'John Doe',
        ),
        Employee(
          employeeId: 2,
          employeeName: 'Jane Smith',
        ),
        Employee(
          employeeId: 3,
          employeeName: 'Michael Johnson',
        ),
      ]; */
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

  void onChangeDepartment(String? name) {
    if (name != null) {
      departmentsController.onDepartmentSelect(name);
      onSearch(searchTextField.text);
    }
  }

  void showRemoveConfirmationDialog(Employee? employee) async {
    if (employee != null) {
      String description =
          "${AppStrings.areYouSureWantToRemove} ${employee.employeeName ?? ''}?";
      Get.dialog(
        Dialog(
          child: YesNoDialog(
            title: description,
            onYesPressed: () {
              Get.back(); // Close Dialog
              _removeEmployee(employee);
            },
          ),
        ),
      );
    }
  }

  Future<void> _removeEmployee(Employee? employee) async {
    int? employeeId = employee?.employeeId;

    if (employeeId != null) {
      String params = "?employeeId=$employeeId";
      String url = Urls.removeDepartment + params;

      var resp = await APIFunction.call(
        APIMethods.get,
        url,
        showLoader: true,
        showErrorMessage: true,
        showSuccessMessage: true,
      );

      if (resp != null && resp is bool && resp == true) {
        // Remove from List
        _searchResults.removeWhere((e) => e.employeeId == employeeId);
        update();
      }
    }
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
