import 'package:intl/intl.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/assigned_task/controller/assigned_task_controller.dart';

import '../controller/ticket_chat_controller.dart';

class AssignedTasksView extends StatefulWidget {
  const AssignedTasksView({super.key});

  @override
  _AssignedTasksViewState createState() => _AssignedTasksViewState();
}

class _AssignedTasksViewState extends State<AssignedTasksView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TicketChatController ticketChatController =
      Get.put(TicketChatController());
  final AssignedTaskController controller = Get.put(AssignedTaskController());
  final ScrollController _scrollController = ScrollController();
  ValueKey<String> _dropdownKey = ValueKey("All");

  @override
  void initState() {
    super.initState();
    controller.loadOpenTickets(initial: true);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_tabController.index == 0) {
        controller.fetchMoreOpenTickets();
      } else {
        if (profileController.isManager) {
          controller.fetchMoreClosedTickets();
        } else {
          controller.fetchMoreOpenTickets();
        }
      }
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
      helpText: 'Select Start Date',
      context: context,
      initialDate: controller.startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.startDate = picked;
        if (controller.endDate != null && picked.isAfter(controller.endDate!)) {
          controller.endDate = null;
        }
        _selectEndDate(context);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (controller.startDate == null) {
      _showDateError('Please select start date first');
      return;
    }

    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Colors.blueGrey.shade700,
              secondary: Colors.tealAccent.shade700,
              onSecondary: Colors.black,
              error: Colors.redAccent,
              onError: Colors.white,
              surface: Colors.blueGrey.shade800,
              onSurface: Colors.white,
            ),
          ).copyWith(
            dialogBackgroundColor: Colors.blueGrey.shade800,
          ),
          child: child!,
        );
      },
      helpText: 'Select End Date',
      context: context,
      initialDate: controller.endDate ?? controller.startDate!,
      firstDate: controller.startDate!,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.endDate = picked;
      });
      controller.updateDateFilters(start: controller.startDate!, end: picked);
    }
  }

  void _showDateError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      controller.changeTicketsType(
        _tabController.index == 0
            ? AppStrings.assignedMe
            : AppStrings.assignedTo,
      );

      // Reset filter value in controller
      controller.changeStatusFilter("All");

      // Force dropdown rebuild by changing the key
      setState(() {
        _dropdownKey = ValueKey("All_${_tabController.index}");
      });

      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssignedTaskController>(
      init: AssignedTaskController(),
      builder: (controller) {
        bool isManager = profileController.isManager;
        int? totalTickets = controller.totalTicketsCount;
        int? urgentTickets = controller.urgentTicketsCount;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppbar.simpleAppBar(
            context,
            height: 70,
            backButtunColor: AppColors.primary,
            title: isManager ? AppStrings.queries : AppStrings.assignedTasks,
            showMailIcon: true,
            showNotificationIcon: true,
            notificationActive: true,
            titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
            iconsClor: AppColors.primary,
            isHome: false,
            isBackButtun: true,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${totalTickets ?? 0} ${AppStrings.tickets} / ${urgentTickets ?? 0} ${AppStrings.urgent}',
                        style: context.bodyMedium!.copyWith(
                          color: AppColors.gry,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Start Date Picker
                          Flexible(
                            child: GestureDetector(
                              onTap: () => _selectStartDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.lightWhite,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.1)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        controller.startDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(controller.startDate!)
                                            : 'Start',
                                        style: context.bodySmall!.copyWith(
                                          color: controller.startDate != null
                                              ? AppColors.textPrimary
                                              : AppColors.gry,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Separator
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '-',
                              style: TextStyle(color: AppColors.gry),
                            ),
                          ),

                          // End Date Picker
                          Flexible(
                            child: GestureDetector(
                              onTap: () => controller.endDate == null &&
                                      controller.startDate == null
                                  ? _showDateError('Select start date first')
                                  : _selectEndDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.lightWhite,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.1)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        controller.endDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(controller.endDate!)
                                            : 'End',
                                        style: context.bodySmall!.copyWith(
                                          color: controller.endDate != null
                                              ? AppColors.textPrimary
                                              : AppColors.gry,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SB.h(10),
                TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: const EdgeInsets.only(bottom: 10),
                  tabs: const [
                    Tab(text: 'Assigned me'),
                    Tab(text: 'Assigned to'),
                  ],
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.gry,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2,
                  labelStyle: context.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: context.titleSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SB.h(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.tickets,
                      style: context.titleSmall!.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomeDropDown.simple<String>(
                      key: _dropdownKey,
                      context,
                      list: controller.ticketStatusList
                          .map((status) => status.value ?? 'All')
                          .toList(),
                      initialItem: "All",
                      onSelect: controller.changeStatusFilter,
                      closedFillColor: AppColors.lightWhite,
                      borderRadius: 20,
                      showShadow: true,
                      closedShadow: false,
                    )
                  ],
                ),
                SB.h(16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(context, controller, isAssignedMe: true),
                      _buildTabContent(context, controller,
                          isAssignedMe: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabContent(
      BuildContext context, AssignedTaskController controller,
      {required bool isAssignedMe}) {
    bool dataLoaded = controller.hasOpenTickets;
    if (profileController.isManager) {
      dataLoaded = dataLoaded || controller.hasClosedTickets;
    }

    return dataLoaded
        ? _buildTicketsList(context, controller, isAssignedMe)
        : CustomLoader();
  }

  Widget _buildTicketsList(BuildContext context,
      AssignedTaskController controller, bool isAssignedMe) {
    List<Ticket> allTickets = isAssignedMe
        ? controller.openTickets
        : (profileController.isManager
            ? controller.closedTickets
            : controller.openTickets);

    if (allTickets.isEmpty) return _noResultsFound();

    return ListView.builder(
      controller: _scrollController,
      itemCount: allTickets.length,
      itemBuilder: (context, index) {
        Ticket ticket = allTickets[index];
        bool isManager = profileController.isManager;
        bool showUnderline = !ticket.isClosed! &&
            controller.ticketsType != TicketsType.assignedTo;
        return AssignedTaskComponents.tile(
          context,
          title: ticket.ticketName ?? ticket.floorName ?? ticket.assignToName,
          status: ticket.isClosed == false || ticket.isClosed == null
              ? 'Open'
              : ticket.isCompleted == true
                  ? 'Completed'
                  : ticket.status!,
          isUnderline: showUnderline,
          onTap: () {
            controller.onTicketTap(
              type: controller.ticketsType,
              ticket: ticket,
              isManager: isManager,
              isClosed: ticket.isClosed!,
            );
          },
          fillColor: AppColors.getStatusColor(ticket.status ?? 'Open'),
          ticket: ticket,
        );
      },
    );
  }

  Widget _noResultsFound() {
    return Center(
      child: Text(AppStrings.noTicketsFound),
    );
  }
}
