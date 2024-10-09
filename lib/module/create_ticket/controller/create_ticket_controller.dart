import 'package:roomrounds/core/apis/models/department/department_model.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/mixins/employee_mixin.dart';
import 'package:roomrounds/module/room_map/views/floor_plan_view.dart';

class CreateTicketController extends GetxController with EmployeeMixin {
  YesNo? _urgent;
  YesNo? get isUrgent => _urgent;

  // Department? _selectedDepartment;
  // Department? get selectedDepartment => _selectedDepartment;

  List<Employee> _employeeList = [];
  List<Employee> get employeeList => _employeeList;
  Employee? _selectedEmployee;
  Employee? get selectedEmployee => _selectedEmployee;

  final TextEditingController descriptionController = TextEditingController();

  List<String> get employeesNamesList => getEmployeesNamesList(_employeeList);

  @override
  void onInit() {
    super.onInit();
    _resetSelectedDepartment();
    _fetchDepartments();
  }

  void _resetSelectedDepartment() {
    departmentsController.onDepartmentSelect(null);
  }

  void _fetchDepartments() async {
    bool isEmployee = profileController.isEmployee;
    bool isManager = profileController.isManager;

    int? departmentId = profileController.departmentId;
    // For Employee Get only My Department
    // For Manager Get All Departments
    List<Department> departments = await departmentsController.getDepartments(
      departmentId: isEmployee ? departmentId : null,
    );
    Department? myDepartment;
    if (departments.isNotEmpty) {
      myDepartment = departments
          .firstWhereOrNull((item) => item.departmentId == departmentId);
      departmentsController.onDepartmentSelect(myDepartment?.departmentName);
    }

    if (isEmployee) {
      // For Employee Select his manager from his department
      if (myDepartment != null && myDepartment.managerId != null) {
        _employeeList.add(Employee(
          userId: myDepartment.managerId,
          employeeId: myDepartment.managerId,
          employeeName: myDepartment.manager,
          departmentId: myDepartment.departmentId,
          departmentName: myDepartment.departmentName,
        ));
        _selectedEmployee = _employeeList.firstOrNull;
      }
    } else if (isManager) {
      // For Manager Fetch his employees from his department
      _fetchEmployeesFromDepartment();
    }

    update();
  }

  void _fetchEmployeesFromDepartment() async {
    int? departmentId = departmentsController.selectedDepartmentId;
    int? myDepartmentId = profileController.departmentId;
    bool isManager = profileController.isManager;
    int? managerId = profileController.userId;
    bool managersOnly = true;

    if (isManager && departmentId != null && myDepartmentId != null) {
      // if other department selected then Managers Only
      // if My Department matched then just my employee
      managersOnly = departmentId != myDepartmentId;
    }

    List<Employee> resp = await getEmployeeList(
      departmentId: departmentId,
      managersOnly: managersOnly,
      // managerId: isManager ? managerId : null,
    );

    if (resp.isNotEmpty) {
      _employeeList = List.from(resp);
      update();
    }
  }

  void onChangeDepartment(String? name) {
    if (name != null) {
      departmentsController.onDepartmentSelect(name);
      _fetchEmployeesFromDepartment();
    }
  }

  void onChangeEmployee(String? name) {
    if (name != null && name.trim().isNotEmpty) {
      if (_employeeList.isNotEmpty) {
        Employee? employee = _employeeList
            .firstWhereOrNull((emp) => emp.employeeName?.trim() == name);
        if (employee != null) {
          _selectedEmployee = employee;
        }
      }
    } else {
      _selectedEmployee = null;
    }
  }

  void onSubmitTicket() async {
    Get.to(() => FloorPlan());
  }

  void onUrgentChanged(YesNo value) {
    _urgent = value;
    update();
  }
}
