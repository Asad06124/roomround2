import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/assigned_task/controller/assigned_task_controller.dart';

class AssignedTasksView extends StatelessWidget {
  const AssignedTasksView({super.key});

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
              titleStyle:
                  context.titleLarge!.copyWith(color: AppColors.primary),
              iconsClor: AppColors.primary,
              isHome: false,
              isBackButtun: true,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    '${totalTickets ?? 0} ${AppStrings.tickets} / ${urgentTickets ?? 0} ${AppStrings.urgent}',
                    // userData.type == UserType.employee
                    //     ? controller.ticketsType == TicketsType.assignedMe
                    //         ? "30 Tickets / 20 Urgent / 5 Urgent"
                    //         : "30 Tickets / 20 Replied"
                    //     : controller.ticketsType == TicketsType.assignedMe
                    //         ? "30 Tickets / 20 Urgent"
                    //         : "30 Tickets",
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.gry,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SB.h(10),
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
                        context,
                        list: controller.ticketsTypesList,
                        initialItem: controller.ticketsTypesList.firstOrNull,
                        onSelect: controller.changeTicketsType,
                        closedFillColor: AppColors.lightWhite,
                        borderRadius: 20,
                        showShadow: true,
                        closedShadow: false,
                      ),
                    ],
                  ),
                  Expanded(
                    child: controller.hasOpenTickets
                        ? _buildOpenClosedTicketsList(context, controller)
                        : CustomLoader(),
                  ),
                  SB.h(10),
                  if (controller.ticketsType == TicketsType.assignedMe) ...[
                    // Show Closed Tickets List Container
                    Expanded(
                      child: controller.hasClosedTickets
                          ? _buildOpenClosedTicketsList(context, controller,
                              isClosedTickets: true)
                          : CustomLoader(),
                    ),
                    SB.h(20),
                  ],

                  /*  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: userData.type == UserType.employee
                        ? controller.ticketsType == TicketsType.assignedMe
                            ? context.height * 0.3800
                            : context.height * 0.80 -
                                context.paddingTop -
                                context.paddingBottom
                        : context.height * 0.80 -
                            context.paddingTop -
                            context.paddingBottom,
                    child: ListView.builder(
                      itemCount: 8,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return userData.type == UserType.employee
                            ? AssignedTaskComponents.tile(
                                context,
                                showIsActiveDot: controller.ticketsType ==
                                        TicketsType.assignedMe
                                    ? index % 2 == 0
                                    : false,
                                status: controller.ticketsType ==
                                        TicketsType.assignedMe
                                    ? "Close"
                                    : "Open Thread",
                                onStatusPressed: () {
                                  if (controller.ticketsType ==
                                      TicketsType.sendTo) {
                                    AssignedTaskComponents
                                        .openDialogEmployee(3, index);
                                    return;
                                  }
                                },
                                onTap: () {
                                  // close ticket dialoue = 0 //
                                  // closed ticket dialoue = 1
                                  // Open thread dialoue = 2 // send to
                                  // Open thread Send to dialoue = 3
                                  if (controller.ticketsType ==
                                      TicketsType.sendTo) {
                                    AssignedTaskComponents
                                        .openDialogEmployee(2, index);
                                    return;
                                  }
                                  AssignedTaskComponents
                                      .openDialogEmployee(0, index);
                                },
                              )
                            : AssignedTaskComponents.tile(
                                context,
                                showIsActiveDot: controller.ticketsType ==
                                    TicketsType.assignedMe,
                                status: controller.ticketsType ==
                                        TicketsType.assignedMe
                                    ? "See Thread"
                                    : 'Assigned',
                                title: 'Room A${index + 1}',
                                statusTextColor: controller.ticketsType ==
                                        TicketsType.assignedMe
                                    ? AppColors.black
                                    : AppColors.gry,
                                isUnderline: controller.ticketsType ==
                                    TicketsType.assignedMe,
                                onStatusPressed: () {
                                  if (controller.ticketsType ==
                                      TicketsType.assignedMe) {
                                    AssignedTaskComponents
                                        .openDialogManager(1, index);
                                  }
                                },
                                onTap: () {
                                  if (controller.ticketsType ==
                                      TicketsType.assignedMe) {
                                    AssignedTaskComponents
                                        .openDialogManager(0, index);
                                  } else {
                                    AssignedTaskComponents
                                        .openDialogManager(2, index);
                                  }
                                },
                              );
                      },
                    ),
                  ),
                  if (controller.ticketsType == TicketsType.assignedMe &&
                      userData.type == UserType.employee) ...{
                    SB.h(10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.gry.withOpacity(0.2),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.closed,
                            style: context.titleSmall!.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SB.h(10),
                          SizedBox(
                            height: context.height * 0.30,
                            child: ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AssignedTaskComponents.tile(
                                  context,
                                  titleActive: false,
                                  title: 'B${index + 1}',
                                  status: 'Closed',
                                  isUnderline: false,
                                  onTap: () {
                                    AssignedTaskComponents
                                        .openDialogEmployee(1, index);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  }, */
                ],
              ),
            ),
          );
        });
  }

  Widget _buildOpenClosedTicketsList(
      BuildContext context, AssignedTaskController controller,
      {bool isClosedTickets = false}) {
    return Container(
      padding: EdgeInsets.all(isClosedTickets ? 15 : 0),
      decoration: BoxDecoration(
        color: isClosedTickets ? AppColors.lightWhite : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isClosedTickets)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                AppStrings.closed,
                style: context.titleSmall!.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          _buildList(
            list: isClosedTickets
                ? controller.closedTicketsList
                : controller.openTicketsList,
            controller: controller,
            type: controller.ticketsType,
            isClosedTickets: isClosedTickets,
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      {required AssignedTaskController controller,
      required List<Ticket> list,
      required TicketsType type,
      bool isClosedTickets = false}) {
    bool isManager = profileController.isManager;
    // bool isEmployee = profileController.isEmployee;

    return Flexible(
      child: list.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              // physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Ticket ticket = list[index];

                String? status = isClosedTickets
                    ? AppStrings.closed
                    : type == TicketsType.assignedMe
                        ? isManager
                            ? AppStrings.seeThread
                            : AppStrings.close
                        : type == TicketsType.assignedTo
                            ? AppStrings.assigned
                            : AppStrings.openThread;

                bool showUnderline =
                    !isClosedTickets && type != TicketsType.assignedTo;

                return AssignedTaskComponents.tile(
                  context,
                  title: ticket.roomName ??
                      ticket.floorName ??
                      ticket.assignToName,
                  // showIsActiveDot:
                  //     type == TicketsType.assignedMe ? index % 2 == 0 : false,
                  status: status,
                  isUnderline: showUnderline,
                  onStatusPressed: showUnderline
                      ? () {
                          controller.onTicketStatusTap(
                            isManager: isManager,
                            ticket: ticket,
                            type: type,
                          );
                        }
                      : null,
                  onTap: () {
                    // // close ticket dialoue = 0 //
                    // // closed ticket dialoue = 1
                    // // Open thread dialoue = 2 // send to
                    // // Open thread Send to dialoue = 3
                    // if (controller.ticketsType == TicketsType.sendTo) {
                    //   EmployeeDirectoryComponents.openDialogEmployee(2, index);
                    //   return;
                    // }
                    // AssignedTaskComponents.openDialogEmployee(0, index);

                    controller.onTicketTap(
                      type: type,
                      ticket: ticket,
                      isManager: isManager,
                      isClosed: isClosedTickets,
                    );
                  },
                );
              },
            )
          : _noResultsFound(),
    );
  }

  Widget _noResultsFound() {
    return Center(
      child: Text(AppStrings.noTicketsFound),
    );
  }
}
