import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/emloyee_directory/controller/employee_directory_controller.dart';

class EmployeeDirectoryView extends StatelessWidget {
  const EmployeeDirectoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeDirectoryController>(
        init: EmployeeDirectoryController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar.simpleAppBar(
              context,
              height: 70,
              backButtunColor: AppColors.primary,
              title: AppStrings.assignedTasks,
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
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,\
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    controller.ticketsType == TicketsType.assignedMe
                        ? "30 Tickets / 20 Closed / 5 Urgent"
                        : "30 Tickets / 20 Replied",
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
                        list: ["Assigned Me", 'Send To'],
                        onSelect: (value) =>
                            controller.changeTicketsType(value),
                        borderRadius: 20,
                        closedFillColor: AppColors.gry.withOpacity(0.24),
                        showShadow: true,
                        closedShaddow: false,
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: controller.ticketsType == TicketsType.assignedMe
                        ? context.height * 0.3800
                        : context.height * 0.80 -
                            context.paddingTop -
                            context.paddingBottom,
                    child: ListView.builder(
                      itemCount: 15,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return EmployeeDirectoryComponents.tile(
                          context,
                          isAcvtive:
                              controller.ticketsType == TicketsType.assignedMe
                                  ? index % 2 == 0
                                  : false,
                          status:
                              controller.ticketsType == TicketsType.assignedMe
                                  ? "Close"
                                  : "Open Thread",
                          onStatusPressed: () {
                            if (controller.ticketsType == TicketsType.sendTo) {
                              EmployeeDirectoryComponents.openDialog(3, index);
                              return;
                            }
                          },
                          onTap: () {
                            // close ticket dialoue = 0 //
                            // closed ticket dialoue = 1
                            // Open thread dialoue = 2 // send to
                            // Open thread Send to dialoue = 3
                            if (controller.ticketsType == TicketsType.sendTo) {
                              EmployeeDirectoryComponents.openDialog(2, index);
                              return;
                            }
                            EmployeeDirectoryComponents.openDialog(0, index);
                          },
                        );
                      },
                    ),
                  ),
                  if (controller.ticketsType == TicketsType.assignedMe) ...{
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
                              itemCount: 10,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return EmployeeDirectoryComponents.tile(
                                  context,
                                  titleActive: false,
                                  status: 'Closed',
                                  isUnderline: false,
                                  onTap: () {
                                    EmployeeDirectoryComponents.openDialog(
                                        1, index);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                ],
              ),
            ),
          );
        });
  }
}
