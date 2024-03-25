import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/room_list/components/room_list_components.dart';
import 'package:roomrounds/module/room_list/controller/room_list_controller.dart';

class RoomListView extends StatelessWidget {
  const RoomListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomListController>(
        init: RoomListController(),
        builder: (controller) {
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
                  name: AppStrings.managinfStaff, desc: userData.name),
            ),
            child: Column(
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
                              AppStrings.auditTemplete,
                              style: context.titleMedium!.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SB.h(10),
                        RoomListComponents.filter(
                            context, controller.chnageRoomType),
                        SB.h(10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              if (controller.roomType == RoomType.complete) {
                                return index % 2 != 0
                                    ? EmployeeDirectoryComponents.tile(
                                        context,
                                        title: 'Room A${index + 1}',
                                        onTap: index % 2 != 0
                                            ? () => Get.toNamed(
                                                AppRoutes.TASKSLISTS)
                                            : null,
                                        statusWidget:
                                            RoomListComponents.statusWidget(
                                                context,
                                                isComplete: index % 2 != 0),
                                      )
                                    : const SizedBox();
                              } else if (controller.roomType ==
                                  RoomType.incomplete) {
                                return index % 2 == 0
                                    ? EmployeeDirectoryComponents.tile(
                                        context,
                                        title: 'Room A${index + 1}',
                                        onTap: index % 2 != 0
                                            ? () => Get.toNamed(
                                                AppRoutes.TASKSLISTS)
                                            : null,
                                        statusWidget:
                                            RoomListComponents.statusWidget(
                                                context,
                                                isComplete: index % 2 != 0),
                                      )
                                    : const SizedBox();
                              } else {
                                return EmployeeDirectoryComponents.tile(
                                  context,
                                  title: 'Room A${index + 1}',
                                  onTap: index % 2 != 0
                                      ? () => Get.toNamed(AppRoutes.TASKSLISTS)
                                      : null,
                                  statusWidget: RoomListComponents.statusWidget(
                                      context,
                                      isComplete: index % 2 != 0),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
