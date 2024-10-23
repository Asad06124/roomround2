import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/apis/models/tickets/tickets_list_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class AssignedTaskController extends GetxController {
  bool hasOpenTickets = false;
  bool hasClosedTickets = false;

  bool isAssignedToMe = true;
  int? totalTicketsCount;
  int? urgentTicketsCount;

  List<Ticket> _openTicketsList = [];
  List<Ticket> _closedTicketsList = [];

  List<Ticket> get openTicketsList => _openTicketsList;
  List<Ticket> get closedTicketsList => _closedTicketsList;

  final List<String> _ticketsTypesList = [AppStrings.assignedMe];

  List<String> get ticketsTypesList => _ticketsTypesList;

  TicketsType _ticketsType = TicketsType.assignedMe;

  TicketsType get ticketsType => _ticketsType;

  @override
  void onInit() {
    super.onInit();
    _addTicketsTypes();
    _fetchAssignedTickets();
    _fetchAssignedTickets(isClosed: true);
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
    totalTicketsCount = 0;
    urgentTicketsCount = 0;
    if (isClosed) {
      _closedTicketsList.clear();
      _updateHasClosedTickets(false);
    } else {
      _openTicketsList.clear();
      _updateHasOpenTickets(false);
    }

    String? status;
    // status = isClosed
    //     ? TicketStatus.closed.name.capitalize
    //     : TicketStatus.open.name.capitalize;

    Map<String, dynamic> data = {
      "isAssignedMe": _ticketsType == TicketsType.assignedMe,
      "ticketStatus": status,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllTickets,
      dataMap: data,
      fromJson: TicketsListModel.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is TicketsListModel) {
      List<Ticket>? tickets = resp.tickets;
      totalTicketsCount = resp.totalTicketCount;
      urgentTicketsCount = resp.urgentTicketCount;

      if (tickets != null && tickets.isNotEmpty) {
        if (isClosed) {
          _closedTicketsList = List.from(tickets);
        } else {
          _openTicketsList = List.from(tickets);
        }
      }
    }

    // if (resp != null) {
    //   List result = resp['result'];
    //   if (isClosed) {
    //     _closedTicketsList =
    //         List.from(result.map((json) => Ticket.fromJson(json)));
    //   } else {
    //     _openTicketsList =
    //         List.from(result.map((json) => Ticket.fromJson(json)));
    //   }
    // }

    if (isClosed) {
      _updateHasClosedTickets(true);
    } else {
      _updateHasOpenTickets(true);
    }
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
      if (_ticketsType == TicketsType.assignedMe) {
        _fetchAssignedTickets(isClosed: true);
      }
    }
  }

  void onTicketTap(
      {Ticket? ticket,
      TicketsType? type,
      bool isClosed = false,
      bool isManager = false}) {
    if (isManager) {
      if (type == TicketsType.assignedMe) {
        if (isClosed) {
          AssignedTaskComponents.openDialogEmployee(TicketDialogs.closedTicket);
        } else {
          AssignedTaskComponents.openDialogEmployee(TicketDialogs.threadTicket);
        }
      } else if (type == TicketsType.assignedTo) {
        AssignedTaskComponents.openDialogEmployee(TicketDialogs.assignedThread);
      }
    } else {
      if (type == TicketsType.assignedMe) {
        if (isClosed) {
          AssignedTaskComponents.openDialogEmployee(TicketDialogs.closedTicket);
        } else {
          AssignedTaskComponents.openDialogEmployee(TicketDialogs.closeTicket);
        }
      } else if (type == TicketsType.sendTo) {
        AssignedTaskComponents.openDialogEmployee(TicketDialogs.openThread);

        // AssignedTaskComponents.openDialogEmployee(
        //     TicketDialogs.openThreadArgue);
      }
    }
  }

  void onTicketStatusTap({TicketsType? type, bool isManager = false}) {
    if (type == TicketsType.assignedMe) {
      if (isManager) {
        AssignedTaskComponents.openDialogEmployee(TicketDialogs.seeThread);
      } else {
        AssignedTaskComponents.openDialogEmployee(TicketDialogs.closeTicket);
      }
    } else if (type == TicketsType.sendTo) {
      AssignedTaskComponents.openDialogEmployee(TicketDialogs.openThreadArgue);
    }
  }

  void _updateHasOpenTickets(bool value) {
    hasOpenTickets = value;
    update();
  }

  void _updateHasClosedTickets(bool value) {
    hasClosedTickets = value;
    update();
  }
}
