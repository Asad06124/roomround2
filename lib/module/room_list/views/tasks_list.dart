import 'package:roomrounds/core/apis/models/room/room_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/room_list/components/room_list_components.dart';
import 'package:roomrounds/module/room_list/controller/room_list_controller.dart';
import 'package:roomrounds/utils/custome_dialogue.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

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
        decriptionWidget: AssignedTaskComponents.appBatTile(
          context,
          name: AppStrings.managinfStaff,
          desc: profileController.user?.username,
        ),
      ),
      child: GetBuilder<TaskListController>(
          init: TaskListController(),
          builder: (controller) {
            String? roomName = controller.roomName?.trim();
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(),
                            Text(
                              AppStrings.auditTempleteTasks,
                              style: context.titleMedium!.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              roomName?.isNotEmpty == true ? '($roomName)' : '',
                              style: context.bodyLarge!.copyWith(
                                color: AppColors.gry,
                              ),
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

  Widget _buildTasksList(BuildContext context, TaskListController controller,
      List<RoomTask> list) {
    if (list.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          RoomTask task = list[index];

          return EmployeeDirectoryComponents.tile(
            context,
            prefixWidget: const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColors.gry,
              size: 20,
            ),
            onTap: () {
              _showYesNoDialog();
            },
            title: task.taskName,
            statusWidget:
                RoomListComponents.yesNoWidget(context, controller, index),
          );
        },
      );
    } else {
      // No Tasks found
      return Center(
        child: Text(
          AppStrings.noTasksFound,
          style: context.bodyLarge!.copyWith(
            color: AppColors.black,
          ),
        ),
      );
    }
  }

  void _showYesNoDialog() {
    Get.dialog(
      Dialog(
        child: YesNoDialouge(
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
  }
}
