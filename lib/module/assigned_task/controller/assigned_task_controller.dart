import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_status_model.dart';
import 'package:roomrounds/core/apis/models/tickets/tickets_list_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/create_ticket/controller/create_ticket_controller.dart';

import '../../../core/apis/models/employee/employee_model.dart';

class AssignedTaskController extends GetxController {
  bool hasOpenTickets = false;
  bool hasClosedTickets = false;

  bool isAssignedToMe = true;
  int? totalTicketsCount;
  int? urgentTicketsCount;
  String? selectedStatusValue;

  List<TicketStatusModel> get ticketStatusList => [
        TicketStatusModel(lookupId: null, value: "All"),
        TicketStatusModel(lookupId: null, value: "Open"),
        ...?_ticketStatusList
      ];

  List<Ticket> _TicketsList = [];
  final List<Ticket> _closedTicketsList = [];
  String selectedDropdownValue = 'Closed';

  List<Ticket> get TicketsList => _TicketsList;

  List<Ticket> get closedTicketsList => _closedTicketsList;
  List<TicketStatusModel>? _ticketStatusList;

  final List<String> _ticketsTypesList = [AppStrings.assignedMe];

  List<String> get ticketsTypesList => _ticketsTypesList;
  int? statusId;
  TicketsType _ticketsType = TicketsType.assignedMe;

  TicketsType get ticketsType => _ticketsType;
  TextEditingController replyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTicketStatusList();
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

  void _refreshOpenAndClosedTickets() {
    _fetchAssignedTickets();
    _fetchAssignedTickets(isClosed: true);
  }

  void _fetchAssignedTickets({
    bool isClosed = false,
    bool isCompleted = false,
    int? statusId,
    bool sendIsClosedParam = false,
  }) async {
    totalTicketsCount = 0;
    urgentTicketsCount = 0;
    if (isClosed) {
      _closedTicketsList.clear();
      _updateHasClosedTickets(false);
    } else {
      _TicketsList.clear();
      _updateHasOpenTickets(false);
    }

    List<String> statuses = [];
    if (isClosed) {
      String? closed = TicketStatus.closed.name.capitalize;
      if (closed != null) statuses.add(closed);
    } else {
      String? open = TicketStatus.open.name.capitalize;
      String? inProgress = TicketStatus.inProgress.name.capitalize;

      // statuses.add(''); // Empty Status
      if (open != null) statuses.add(open);
      if (inProgress != null) statuses.add(inProgress);
    }

    bool isManager = profileController.isManager;
    int? managerId;
    if (isClosed && isManager) {
      managerId = profileController.userId;
    }

    Map<String, dynamic> data = {
      "isAssignedMe": _ticketsType == TicketsType.assignedMe,
      // "isClosed": isClosed ? true : false,
      "assignBy": managerId,
      "isCompleted": isCompleted,
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
    };
    if (sendIsClosedParam) {
      data["isClosed"] = false;
    }
    if (statusId != null) {
      data["statusId"] = statusId;
    }
    var resp = await APIFunction.call(APIMethods.post, Urls.getAllTickets,
        dataMap: data,
        fromJson: TicketsListModel.fromJson,
        showLoader: false,
        showErrorMessage: false,
        isGoBack: false);

    if (resp != null && resp is TicketsListModel) {
      fetchTicketStatusList();
      List<Ticket>? tickets = resp.tickets;
      totalTicketsCount = resp.totalTicketCount;
      urgentTicketsCount = resp.urgentTicketCount;

      if (tickets != null && tickets.isNotEmpty) {
        _TicketsList = List.from(tickets);
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

  Employee? selectedEmployee;

  // Method to set the selected employee
  void setSelectedEmployee(Employee employee) {
    selectedEmployee = employee;
    update();
  }

  CreateTicketController createTicketController =
      Get.put(CreateTicketController());

  void _closeTicketApi({
    int? ticketId,
    String? reply,
    int? statusId,
    bool? isClosed,
  }) async {
    if (ticketId != null) {
      String params =
          '?ticketId=$ticketId&reply=$reply&statusId=$statusId&isClosed=$isClosed';
      if (selectedEmployee?.userId != null) {
        params += '&assignTo=${selectedEmployee!.userId}';
      }
      var resp = await APIFunction.call(
          APIMethods.post, Urls.updateTicketStatus + params,
          showLoader: true,
          showErrorMessage: true,
          showSuccessMessage: true,
          isGoBack: false);

      if (resp != null && resp is bool && resp == true) {
        _refreshOpenAndClosedTickets();
        selectedEmployee = null;
        update();
      }
    }
  }

  // void _completeTicket({int? ticketId, bool isCompleted = false}) async {
  //   if (ticketId != null) {
  //     String params = '?ticketId=$ticketId&isCompleted=$isCompleted';
  //
  //     var resp = await APIFunction.call(
  //       APIMethods.post,
  //       Urls.updateIsCompletedTickets + params,
  //       showLoader: true,
  //       showErrorMessage: true,
  //       showSuccessMessage: true,
  //     );
  //
  //     if (resp != null && resp is bool && resp == true) {
  //       _refreshOpenAndClosedTickets();
  //     }
  //   }
  // }

  // void _deleteTicket({int? ticketId, bool isDeleted = false}) async {
  //   if (ticketId != null) {
  //     var resp = await APIFunction.call(
  //       APIMethods.delete,
  //       Urls.deleteTicket,
  //       dataMap: {"id": ticketId, "isDeleted": isDeleted},
  //       showLoader: true,
  //       showErrorMessage: true,
  //       showSuccessMessage: true,
  //     );

  //     if (resp != null && resp is bool && resp == true) {
  //       _refreshOpenAndClosedTickets();
  //     }
  //   }
  // }

  void changeClosedCompletedType(String? value) {
    if (value == 'Completed') {
      _fetchAssignedTickets(isClosed: true, isCompleted: true);
    } else {
      _fetchAssignedTickets(isClosed: true, isCompleted: false);
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
      if (_ticketsType == TicketsType.assignedMe ||
          _ticketsType == TicketsType.assignedTo) {
        _fetchAssignedTickets(isClosed: true, isCompleted: false);
      }
    }
  }

  void changeStatusFilter(String? value) {
    selectedStatusValue = value;
    if (value == 'Open') {
      _fetchAssignedTickets(sendIsClosedParam: true);
    } else {
      final selectedStatus = _ticketStatusList?.firstWhere(
        (status) => status.value == value,
        orElse: () => TicketStatusModel(lookupId: null, value: "All"),
      );
      _fetchAssignedTickets(statusId: selectedStatus?.lookupId);
    }
    update();
  }

  Future<List<TicketStatusModel>> fetchTicketStatusList() async {
    if (_ticketStatusList != null && _ticketStatusList!.isNotEmpty) {
      return _ticketStatusList!;
    }

    Map<String, dynamic> data = {
      "type": "TicketDependenciesStatus",
    };
    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.ticketStatus,
      dataMap: data,
      showLoader: false,
      showErrorMessage: true,
      isGoBack: false,
    );

    if (resp != null && resp is List) {
      _ticketStatusList = [];

      _ticketStatusList?.addAll(
          resp.map((item) => TicketStatusModel.fromJson(item)).toList());
      return _ticketStatusList!;
    }
    return [];
  }

  void onTicketTap(
      {Ticket? ticket,
      TicketsType? type,
      bool isClosed = false,
      bool isManager = false}) {
    _openTicketsDialog(
      type: TicketDialogs.closeTicket,
      ticket: ticket,
    );
  }

  // void onTicketStatusTap(
  //     {TicketsType? type, Ticket? ticket, bool isManager = false}) {
  //   if (type == TicketsType.assignedMe) {
  //     if (isManager) {
  //       _openTicketsDialog(
  //         type: TicketDialogs.seeThread,
  //         ticket: ticket,
  //       );
  //     } else {
  //       _openTicketsDialog(
  //         type: TicketDialogs.closeTicket,
  //         ticket: ticket,
  //       );
  //     }
  //   } else if (type == TicketsType.sendTo) {
  //     _openTicketsDialog(
  //       type: TicketDialogs.openThreadArgue,
  //       ticket: ticket,
  //     );
  //   }
  // }

  void _updateHasOpenTickets(bool value) {
    hasOpenTickets = value;
    update();
  }

  void _updateHasClosedTickets(bool value) {
    hasClosedTickets = value;
    update();
  }

  void _openTicketsDialog({TicketDialogs? type, Ticket? ticket}) async {
    List<TicketStatusModel> statusList = await fetchTicketStatusList();
    List<String> statusStrings =
        statusList.map((status) => status.value ?? '').toList();

    customLogger("Ticket: ${ticket?.toJson()}");
    _showFullWidthDialog(
      CloseTicketDialouge(
        ticket: ticket,
        showClose: false,
        sendStatusList: statusStrings,
        textController: replyController,
        onReplyButtonTap: () {
          _closeTicketApi(
            ticketId: ticket?.ticketId,
            reply: replyController.text,
            statusId: statusId,
            isClosed: true,
          );
        },
        onRadioTap: (index) {
          index = statusList[index].lookupId!;
          statusId = index;
        },
      ),
    );
  }

  void _showFullWidthDialog(Widget child) {
    Get.dialog(
      Dialog(
        // elevation: 0,
        // backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 14),
        child: child,
      ),
      // barrierDismissible: false,
    );

    // showDialog(
    //   barrierDismissible: false,
    //   context: Get.context!,
    //   builder: (context) => Dialog(
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     insetPadding: const EdgeInsets.symmetric(horizontal: 14),
    //     child: child,
    //   ),
    // );
  }
}
