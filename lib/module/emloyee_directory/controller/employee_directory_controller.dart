import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/mixins/employee_mixin.dart';
import 'package:roomrounds/module/emloyee_directory/controller/departments_controller.dart';

class EmployeeDirectoryController extends GetxController with EmployeeMixin {
  EmployeeDirectoryController({
    this.fetchDepartments = true,
    this.fetchEmployees = false,
    this.ignoreDepartmentId = false,
    this.ignoreManager = false,
    this.onlyMyEmployees = false,
  });

  final bool ignoreDepartmentId;

  final bool fetchDepartments;
  final bool ignoreManager;
  final bool onlyMyEmployees;
  final bool fetchEmployees;

  final TextEditingController searchTextField = TextEditingController();

  List<Employee> _searchResults = [];

  List<Employee> get searchResults => _searchResults;

  final List<String> _employeeTypes = [
    AppStrings.all,
    AppStrings.allEmployees,
    AppStrings.allManagers,
  ];

  List<String> get employeeTypes => _employeeTypes;
  String? selectedEmployeeType;
  bool hasData = false;
  bool? managersOnly;
  int? myDepartmentId;
  int? managerId;
  int? departmentId;
  bool myEmployees = false;

  @override
  void onInit() {
    super.onInit();
    _addMyEmployeesType();
    _resetSelectedDepartment();
    selectedEmployeeType = AppStrings.all;
    if (fetchEmployees) onSearch('');
  }

  void _resetSelectedDepartment() async {
    if (Get.isRegistered<DepartmentsController>()) {
      departmentsController.onDepartmentSelect(null);
      if (fetchDepartments) {
        await departmentsController.getDepartments(
          unassigned: null,
          isAssignedEmployee: true,
        );
        onSearch(
          departmentsController.selectedDepartment == null
              ? searchTextField.text
              : searchTextField.text,
        );
        update();
      }
    }
  }

  void _addMyEmployeesType() {
    try {
      bool isManager = profileController.isManager;
      if (isManager) {
        String myEmployeesText = AppStrings.myEmployees;
        _employeeTypes.add(myEmployeesText);
        myEmployees = true;
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

    int? departmentId = ignoreDepartmentId
        ? null
        : (onlyMyEmployees
            ? profileController.departmentId
            : myDepartmentId ?? departmentsController.selectedDepartmentId);

    bool? managersOnlyParam = ignoreManager ? null : managersOnly;
    List<Employee> resp = await getEmployeeList(
      search: text,
      managerId: managerId,
      departmentId: departmentId,
      managersOnly: managersOnlyParam,
    );

    /*   Map<String, dynamic> data = {
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
    ); */

    if (resp.isNotEmpty) {
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
      case AppStrings.all:
        managersOnly = null;
        managerId = null;
        departmentId = null;
        break;
      case AppStrings.allEmployees:
        managersOnly = false;
        managerId = null;
        departmentId = null;
        break;
      case AppStrings.allManagers:
        managersOnly = true;
        managerId = null;
        departmentId = null;
        break;
      case AppStrings.myEmployees:
        managersOnly = false;
        myEmployees = true;
        managerId = profileController.userId;
        departmentId = profileController.departmentId;
        break;
      default:
        break;
    }
    departmentsController.getDepartments(
      unassigned: type == AppStrings.allManagers ? false : null,
      isAssignedEmployee:
          type == AppStrings.all || type == AppStrings.allEmployees
              ? true
              : null,
      departmentId: type == AppStrings.myEmployees
          ? profileController.departmentId
          : null,
    );
    departmentsController.onDepartmentSelect(null);
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
}
