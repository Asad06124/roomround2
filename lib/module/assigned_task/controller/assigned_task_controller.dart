import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_status_model.dart';
import 'package:roomrounds/core/apis/models/tickets/tickets_list_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/create_ticket/controller/create_ticket_controller.dart';

import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/apis/models/employee/employee_model.dart';

class AssignedTaskController extends GetxController {
  List<Ticket> _openTickets = [];
  int _openPage = 1;
  final int _pageSize = 10;
  bool _hasMoreOpenTickets = true;
  bool isFetchingOpenTickets = false;

  List<Ticket> _closedTickets = [];
  int _closedPage = 1;
  bool hasMoreClosedTickets = true;
  bool isFetchingClosedTickets = false;

  bool hasOpenTickets = false;
  bool hasClosedTickets = false;
  bool isAssignedToMe = true;
  int? totalTicketsCount;
  int? urgentTicketsCount;
  String? selectedStatusValue;
  DateTime? startDate;
  DateTime? endDate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _updateHasOpenTickets(bool value) {
    hasOpenTickets = value;
    update();
  }

  void _updateHasClosedTickets(bool value) {
    hasClosedTickets = value;
    update();
  }

  List<TicketStatusModel> get ticketStatusList => [
        TicketStatusModel(lookupId: null, value: "All"),
        TicketStatusModel(lookupId: null, value: "Open"),
        ...?_ticketStatusList,
      ];
  List<TicketStatusModel>? _ticketStatusList;

  final List<String> _ticketsTypesList = [AppStrings.assignedMe];

  List<String> get ticketsTypesList => _ticketsTypesList;
  int? statusId;
  TicketsType _ticketsType = TicketsType.assignedMe;

  TicketsType get ticketsType => _ticketsType;

  TextEditingController replyController = TextEditingController();

  List<Ticket> get openTickets => _openTickets;

  List<Ticket> get closedTickets => _closedTickets;

  @override
  void onInit() {
    super.onInit();
    fetchTicketStatusList();
    _addTicketsTypes();

    startDate = DateTime.now().subtract(Duration(days: 7));
    endDate = DateTime.now();

    _initialLoadTickets();
  }

  Future<void> _initialLoadTickets() async {
    await Future.wait([
      loadOpenTickets(initial: true),
      if (profileController.isManager) _loadClosedTickets(initial: true),
    ]);
  }

  Future<List<Ticket>> _fetchTicketsFromServer({
    required bool isClosed,
    required int page,
  }) async {
    final data = {
      "isAssignedMe": _ticketsType == TicketsType.assignedMe,
      "pageNo": page,
      "size": _pageSize,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "isPagination": true,
    };

    if (isClosed) {
      data["assignBy"] = profileController.userId;
    }

    if (selectedStatusValue != null && selectedStatusValue != "All") {
      // The API expects an "isClosed" flag to determine whether to fetch open or closed tickets.
      // Here, when the user selects "Open", we set "isClosed" to false because:
      // - A false value for "isClosed" tells the API to return open tickets.
      if (selectedStatusValue == "Open") {
        data["isClosed"] = false;
      } else {
        // For statuses other than "Open", we do not directly use the "isClosed" flag.
        // Instead, we search for a ticket status model that matches the selected status value.
        //
        // The lookupId from the TicketStatusModel represents a specific status filter.
        // If such a model is found and its lookupId is valid (not null), we add it to the data
        // using the "statusId" key. This way, the API will filter the tickets based on the provided status id.
        final selectedStatus = _ticketStatusList?.firstWhere(
          (status) => status.value == selectedStatusValue,
          orElse: () => TicketStatusModel(lookupId: null, value: "All"),
        );
        if (selectedStatus != null && selectedStatus.lookupId != null) {
          data["statusId"] = selectedStatus.lookupId;
        }
      }
    }

    final resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllTickets,
      dataMap: data,
      fromJson: TicketsListModel.fromJson,
      showLoader: false,
      showErrorMessage: false,
      isGoBack: false,
    );

    if (resp != null && resp is TicketsListModel) {
      totalTicketsCount = resp.totalTicketCount;
      urgentTicketsCount = resp.urgentTicketCount;
      return resp.tickets ?? [];
    }

    return [];
  }

  Future<void> loadOpenTickets(
      {bool initial = false, bool refresh = false}) async {
    if (initial) {
      _updateHasOpenTickets(false);
      isFetchingOpenTickets = true;
      _openPage = 1;
      List<Ticket> fetched =
          await _fetchTicketsFromServer(isClosed: false, page: _openPage);
      _openTickets = fetched;
      _hasMoreOpenTickets = fetched.length == _pageSize;
      isFetchingOpenTickets = false;
      _updateHasOpenTickets(true);
      update();
    } else if (refresh) {
      List<Ticket> fetched =
          await _fetchTicketsFromServer(isClosed: false, page: 1);
      final newTickets = _getNewTickets(_openTickets, fetched);
      if (newTickets.isNotEmpty) {
        _openTickets.insertAll(0, newTickets);
        update();
      }
    }
  }

  Future<void> fetchMoreOpenTickets() async {
    if (!_hasMoreOpenTickets || isFetchingOpenTickets) return;
    isFetchingOpenTickets = true;
    _openPage++;
    List<Ticket> fetched =
        await _fetchTicketsFromServer(isClosed: false, page: _openPage);
    if (fetched.isNotEmpty) {
      _openTickets.addAll(fetched);
    }
    if (fetched.length < _pageSize) {
      _hasMoreOpenTickets = false;
    }
    isFetchingOpenTickets = false;
    update();
  }

  Future<void> _loadClosedTickets(
      {bool initial = false, bool refresh = false}) async {
    if (initial) {
      _updateHasClosedTickets(false);
      isFetchingClosedTickets = true;
      _closedPage = 1;
      List<Ticket> fetched =
          await _fetchTicketsFromServer(isClosed: true, page: _closedPage);
      _closedTickets = fetched;
      hasMoreClosedTickets = fetched.length == _pageSize;
      isFetchingClosedTickets = false;
      _updateHasClosedTickets(true);
      update();
    } else if (refresh) {
      List<Ticket> fetched =
          await _fetchTicketsFromServer(isClosed: true, page: 1);
      final newTickets = _getNewTickets(_closedTickets, fetched);
      if (newTickets.isNotEmpty) {
        _closedTickets.insertAll(0, newTickets);
        update();
      }
    }
  }

  Future<void> fetchMoreClosedTickets() async {
    if (!hasMoreClosedTickets || isFetchingClosedTickets) return;
    isFetchingClosedTickets = true;
    _closedPage++;
    List<Ticket> fetched =
        await _fetchTicketsFromServer(isClosed: true, page: _closedPage);
    if (fetched.isNotEmpty) {
      _closedTickets.addAll(fetched);
    }
    if (fetched.length < _pageSize) {
      hasMoreClosedTickets = false;
    }
    isFetchingClosedTickets = false;
    update();
  }

  void refreshTickets() {
    loadOpenTickets(refresh: true);
    if (profileController.isManager) {
      _loadClosedTickets(refresh: true);
    }
  }

  void updateDateFilters({required DateTime start, required DateTime end}) {
    startDate = start;
    endDate = end;
    loadOpenTickets(initial: true);
    if (profileController.isManager) {
      _loadClosedTickets(initial: true);
    }
    update();
  }

  void _addTicketsTypes() {
    _ticketsTypesList.add(profileController.isManager
        ? AppStrings.assignedTo
        : AppStrings.sendTo);
  }

  void refreshOpenAndClosedTickets() {
    loadOpenTickets(refresh: true);
    if (profileController.isManager) {
      _loadClosedTickets(refresh: true);
    }
  }

  Employee? selectedEmployee;

  void setSelectedEmployee(Employee employee) {
    selectedEmployee = employee;
    update();
  }

  CreateTicketController createTicketController =
      Get.put(CreateTicketController());

  void _closeTicketApi({
    int? ticketId,
    Ticket? ticket,
    String? reply,
    int? statusId,
    bool? isClosed,
    String? newStatusText,
  }) async {
    if (ticketId != null && ticket != null) {
      Map<String, String> queryParams = {
        'ticketId': ticketId.toString(),
        'reply': reply ?? "",
        'statusId': statusId?.toString() ?? "",
        'isClosed': isClosed.toString(),
      };
      if (selectedEmployee?.userId != null) {
        queryParams['assignTo'] = selectedEmployee!.userId.toString();
      }
      final url = Uri.parse(Urls.updateTicketStatus)
          .replace(queryParameters: queryParams)
          .toString();

      final resp = await APIFunction.call(
        APIMethods.post,
        url,
        showLoader: true,
        showErrorMessage: true,
        showSuccessMessage: true,
        isGoBack: false,
      );

      if (resp != null && resp is bool && resp == true) {
        sendAssigneeChangeNotification(
          ticketId: ticket.ticketId.toString(),
          oldAssignee: ticket.assignToName ?? '',
          newAssignee: selectedEmployee?.employeeName ?? '',
        );
        // When updating only the assignee (statusId is null),
        // force newStatusText to be null to avoid unwanted status update.
        _updateTicketInCache(
          ticketId,
          reply,
          statusId,
          isClosed,
          selectedEmployee,
          statusId != null ? newStatusText : null,
        );
        refreshOpenAndClosedTickets();
        statusId = null;
        selectedEmployee = null;
        update();
      }
    }
  }

  void _updateTicketInCache(
    int ticketId,
    String? reply,
    int? statusId,
    bool? isClosed,
    Employee? newAssignee,
    String? newStatusText,
  ) {
    for (var ticket in _openTickets) {
      if (ticket.ticketId == ticketId) {
        ticket.reply = reply;
        ticket.statusId = statusId;
        ticket.isClosed = isClosed;
        ticket.assignToName = newAssignee?.employeeName;
        ticket.assignToImage = newAssignee?.imageKey;
        // Only update the status if newStatusText is provided.
        if (newStatusText != null && newStatusText.isNotEmpty) {
          ticket.status = newStatusText;
        }
        break;
      }
    }
    for (var ticket in _closedTickets) {
      if (ticket.ticketId == ticketId) {
        ticket.reply = reply;
        ticket.statusId = statusId;
        ticket.isClosed = isClosed;
        ticket.assignToName = newAssignee?.employeeName;
        ticket.assignToImage = newAssignee?.imageKey;
        if (newStatusText != null && newStatusText.isNotEmpty) {
          ticket.status = newStatusText;
        }
        break;
      }
    }
  }

  void changeClosedCompletedType(String? value) {
    _loadClosedTickets(initial: true);
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
      loadOpenTickets(initial: true);
      if (_ticketsType == TicketsType.assignedMe ||
          _ticketsType == TicketsType.assignedTo) {
        if (profileController.isManager) {
          _loadClosedTickets(initial: true);
        }
      }
    }
  }

  void changeStatusFilter(String? value) {
    selectedStatusValue = value;
    loadOpenTickets(initial: true);
    if (profileController.isManager) {
      _loadClosedTickets(initial: true);
    }
    update();
  }

  Future<List<TicketStatusModel>> fetchTicketStatusList() async {
    if (_ticketStatusList != null && _ticketStatusList!.isNotEmpty) {
      return _ticketStatusList!;
    }
    Map<String, dynamic> data = {"type": "TicketDependenciesStatus"};
    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.ticketStatus,
      dataMap: data,
      showLoader: false,
      showErrorMessage: true,
      isGoBack: false,
    );

    if (resp != null && resp is List) {
      _ticketStatusList =
          resp.map((item) => TicketStatusModel.fromJson(item)).toList();
      return _ticketStatusList!;
    }
    return [];
  }

  void onTicketTap({
    Ticket? ticket,
    TicketsType? type,
    bool isClosed = false,
    bool isManager = false,
  }) {
    _openTicketsDialog(
      type: TicketDialogs.closeTicket,
      ticket: ticket,
    );
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
        onReplyButtonTap: (newStatusText) {
          _closeTicketApi(
            ticketId: ticket?.ticketId,
            reply: replyController.text,
            statusId: statusId != null ? ticket?.statusId : statusId,
            isClosed: true,
            ticket: ticket,
            newStatusText: newStatusText,
          );
          newStatusText = '';
        },
        onRadioTap: (index) {
          statusId = statusList[index].lookupId;
        },
      ),
    );
  }

  Future<void> sendAssigneeChangeNotification({
    required String ticketId,
    required String oldAssignee,
    required String newAssignee,
  }) async {
    final String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    ChatMessage systemMessage = ChatMessage(
      id: messageId,
      chatId: ticketId,
      senderId: 'system',
      // system identifier
      receiverId: '',
      // not needed
      type: 'system',
      // custom type to distinguish system messages
      content: "Assignee changed from $oldAssignee to $newAssignee",
      imageUrl: '',
      isDelivered: true,
      isSeen: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .doc(messageId)
        .set(systemMessage.toJson());
  }

  void _showFullWidthDialog(Widget child) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14),
        child: child,
      ),
    );
  }

  List<Ticket> _getNewTickets(
      List<Ticket> currentTickets, List<Ticket> fetched) {
    if (fetched.isNotEmpty &&
        (currentTickets.isEmpty ||
            fetched.first.ticketId != currentTickets.first.ticketId)) {
      return fetched
          .where((ticket) =>
              !currentTickets.any((t) => t.ticketId == ticket.ticketId))
          .toList();
    }
    return [];
  }
}
