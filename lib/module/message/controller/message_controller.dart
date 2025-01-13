import 'package:roomrounds/core/constants/imports.dart';

import '../../../core/apis/models/employee/employee_model.dart';
import '../../emloyee_directory/controller/employee_directory_controller.dart';

class MessageViewController extends GetxController {
  var employeeDirectoryController = Get.put(EmployeeDirectoryController());

  List<Employee> userlist = [];

  @override
  void onInit() {
    super.onInit();

    userlist = employeeDirectoryController.searchResults;
  }
}
