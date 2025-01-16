import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/apis/models/room/room_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/room_list/components/room_list_components.dart';
import 'package:roomrounds/module/room_list/controller/room_tasks_controller.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(0),
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 140,
        isBackButtun: true,
        titleStyle: context.titleLarge,
        title: AppStrings.roomStatusList,
        isHome: false,
        decriptionWidget: CustomAppbar.appBatTile(
          context,
          name: AppStrings.managingStaff,
          desc: profileController.user?.username,
        ),
      ),
      child: GetBuilder<RoomTasksController>(
          init: RoomTasksController(),
          builder: (controller) {
            String? roomName, templateName;
            Room? room = controller.room;
            if (room != null) {
              roomName = room.roomName?.trim();
              templateName = room.templateName?.trim();
            }

            return Column(
              children: [
                Expanded(
                  child: Container(
                    // width: context.width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55),
                        topRight: Radius.circular(55),
                      ),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        SB.w(context.width),
                        SB.h(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(),
                                Text(
                                  templateName ?? AppStrings.template,
                                  style: context.titleMedium!.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  roomName?.isNotEmpty == true
                                      ? '($roomName)'
                                      : '',
                                  style: context.bodyLarge!.copyWith(
                                    color: AppColors.gry,
                                  ),
                                ),
                              ],
                            ),
                            CustomeDropDown.simple<String>(
                              context,
                              list: controller.sortBy,
                              initialItem: controller.sortBy[0],
                              onSelect: controller.changeSortBy,
                              closedFillColor: AppColors.lightWhite,
                              borderRadius: 20,
                              showShadow: true,
                              closedShadow: false,
                            ),
                          ],
                        ),
                        SB.h(10),
                        Expanded(
                          child: controller.hasData
                              ? _buildTasksList(
                                  context, controller, controller.tasks)
                              : CustomLoader(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildTasksList(BuildContext context, RoomTasksController controller,
      List<RoomTask> list) {
    if (list.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          RoomTask task = list[index];
          bool isTaskCompleted = task.taskStatus ?? false;

          return EmployeeDirectoryComponents.tile(
            context,
            title: task.taskName,
            showPrefixDropdown: false,
            trailingWidget: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: RoomListComponents.statusWidget(
                context,
                isComplete: isTaskCompleted,
                onToggle: () {
                  controller.updateTaskStatus(
                    index,
                    YesNo.no,
                  );
                },
              ),
            ),
            subtitleWidget: task.taskStatus == true
                ? task.isNA != true
                    ? IgnorePointer(
                        ignoring: isTaskCompleted,
                        child: RoomListComponents.yesNoWidget(
                          context,
                          YesNo.no,
                          (newVal) =>
                              controller.changeTaskStatus(index, newVal, ),
                        ),
                      )
                    : IgnorePointer(
                        ignoring: isTaskCompleted,
                        child: RoomListComponents.yesNoWidget(
                          context,
                          YesNo.na,
                          (newVal) =>
                              controller.changeTaskStatus(index, newVal, ),
                        ),
                      )
                : IgnorePointer(
                    ignoring: isTaskCompleted,
                    child: RoomListComponents.yesNoWidget(
                      context,
                      task.userSelection,
                      (newVal) =>
                          controller.changeTaskStatus(index, newVal, ),
                    ),
                  ),
          );
        },
      );
    } else {
      // No Tasks found
      return SettingsComponents.noResultsFound(
          context, AppStrings.noTasksFound);
    }
  }

/*  void _showYesNoDialog() {
    Get.dialog(
      Dialog(
        child: YesNoDialog(
          title: 'Is audit findings needs to be arranged?',
          onYesPressed: () {
            Get.back();
            _showArrangeAuditFundingDialog();
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showArrangeAuditFundingDialog() {
    Get.dialog(
      const Dialog(child: ArrangeAuditFunding()),
      barrierDismissible: false,
    );
  } */
}
