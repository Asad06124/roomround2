import 'package:roomrounds/core/constants/imports.dart';

enum TicketsType { assignedMe, sendTo }

class EmployeeDirectoryController extends GetxController {
  TicketsType _ticketsType = TicketsType.assignedMe;
  TicketsType get ticketsType => _ticketsType;

  void changeTicketsType(String val) {
    if (val == 'Assigned Me') {
      _ticketsType = TicketsType.assignedMe;
    } else {
      _ticketsType = TicketsType.sendTo;
    }
    update();
  }
}
