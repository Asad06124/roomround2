import 'package:roomrounds/core/constants/imports.dart';

enum TicketsType { assignedMe, assignedTo, sendTo }

class EmployeeDirectoryController extends GetxController {
  TicketsType _ticketsType = TicketsType.assignedMe;
  TicketsType get ticketsType => _ticketsType;

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
