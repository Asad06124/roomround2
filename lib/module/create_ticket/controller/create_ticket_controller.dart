import 'package:roomrounds/core/constants/app_enum.dart';
import 'package:roomrounds/core/constants/imports.dart';

class CreateTicketController extends GetxController {
  YesNo? _urgent;

  YesNo? get isUrgent => _urgent;

  @override
  void onInit() {
    super.onInit();
    _resetSelectedDepartment();
  }

  void _resetSelectedDepartment() {
    departmentsController.onDepartmentSelect(null);
  }

  void onChangeDepartment(String? name) {
    if (name != null) {
      departmentsController.onDepartmentSelect(name);
      // onSearch(searchTextField.text);
    }
  }

  void onChangeManager(String? name) {}

  void onUrgentChanged(YesNo value) {
    _urgent = value;
    update();
  }
}
