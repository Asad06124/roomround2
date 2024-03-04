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
        decriptionWidget: AssignedTaskComponents.appBatTile(context,
            name: AppStrings.managinfStaff, desc: 'Philo Dairin '),
      ),
      child: GetBuilder<RoomListController>(
          init: RoomListController(),
          builder: (controller) {
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
                              '(Room A1)',
                              style: context.bodyLarge!.copyWith(
                                color: AppColors.gry,
                              ),
                            ),
                          ],
                        ),
                        SB.h(10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tasks.length,
                            itemBuilder: (context, index) {
                              return EmployeeDirectoryComponents.tile(context,
                                  prefixWidget: const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.gry,
                                    size: 20,
                                  ), onTap: () {
                                _showYesNoDialog();
                              },
                                  title: 'Arrange audit findings?',
                                  statusWidget: RoomListComponents.yesNoWidget(
                                      context, controller, index));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
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
