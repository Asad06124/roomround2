import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class AssignedTaskController extends GetxController {
  bool hasData = false;

  bool isAssignedToMe = true;

  List<Ticket> _openTicketsList = [];
  List<Ticket> _closedTicketsList = [];

  List<Ticket> get openTicketsList => _openTicketsList;
  List<Ticket> get closedTicketsList => _closedTicketsList;

  List<String> _ticketsTypesList = [AppStrings.assignedMe];

  List<String> get ticketsTypesList => _ticketsTypesList;

  TicketsType _ticketsType = TicketsType.assignedMe;

  TicketsType get ticketsType => _ticketsType;

  @override
  void onInit() {
    super.onInit();
    _addTicketsTypes();
    _fetchAssignedTickets();
  }

  void _addTicketsTypes() {
    bool isManager = profileController.isManager;

    if (isManager) {
      _ticketsTypesList.add(AppStrings.assignedTo);
    } else {
      _ticketsTypesList.add(AppStrings.sendTo);
    }
  }

  void _fetchAssignedTickets({bool isClosed = false}) async {
    _updateHasData(false);

    Map<String, dynamic> data = {
      "isAssignedMe": _ticketsType == TicketsType.assignedMe,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllTickets,
      dataMap: data,
      fromJson: Ticket.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is List && resp.isNotEmpty) {
      _openTicketsList = List.from(resp);
    }

    _updateHasData(true);
  }

  void changeTicketsType(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value == AppStrings.assignedMe) {
        _ticketsType = TicketsType.assignedMe;
      } else if (value == AppStrings.assignedTo) {
        _ticketsType = TicketsType.assignedTo;
      } else if (value == AppStrings.sendTo) {
        _ticketsType = TicketsType.sendTo;
      } else {
        _ticketsType = TicketsType.assignedMe;
      }
      // update();
      _fetchAssignedTickets();
    }
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
