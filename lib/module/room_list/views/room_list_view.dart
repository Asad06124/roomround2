// ignore_for_file: unused_local_variable

import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/room_list/components/room_list_components.dart';
import 'package:roomrounds/module/room_list/controller/room_list_controller.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class RoomListView extends StatelessWidget {
  const RoomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomListController>(
        init: RoomListController(),
        builder: (controller) {
          User? user = profileController.user;
          List<Room> roomsList = controller.roomsList;

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
                desc: user?.username,
              ),
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
                            // const SizedBox(),
                            Text(
                              controller.hasData
                                  ? roomsList.firstOrNull?.templateName ??
                                      AppStrings.template
                                  : AppStrings.template,
                              style: context.titleMedium!.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SB.h(10),
                        RoomListComponents.filter(
                          context,
                          controller.changeRoomType,
                        ),
                        SB.h(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(),
                            Text(
                              AppStrings.rooms,
                              style: context.titleMedium!.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SB.h(10),
                        Expanded(
                          child: controller.hasData
                              ? _buildRoomsList(context, roomsList)
                              : const CustomLoader(),
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

  Widget _buildRoomsList(BuildContext context, List<Room> list) {
    if (list.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          Room room = list[index];

          /* if (controller.roomType == RoomType.complete) {
            return index % 2 != 0
                ? EmployeeDirectoryComponents.tile(
                    context,
                    title: 'Room A${index + 1}',
                    onTap: index % 2 != 0
                        ? () => Get.toNamed(AppRoutes.TASKSLISTS)
                        : null,
                    statusWidget: RoomListComponents.statusWidget(context,
                        isComplete: index % 2 != 0),
                  )
                : const SizedBox();
          } else if (controller.roomType == RoomType.inProgress) {
            return index % 2 == 0
                ? EmployeeDirectoryComponents.tile(
                    context,
                    title: 'Room A${index + 1}',
                    onTap: index % 2 != 0
                        ? () => Get.toNamed(AppRoutes.TASKSLISTS)
                        : null,
                    statusWidget: RoomListComponents.statusWidget(context,
                        isComplete: index % 2 != 0),
                  )
                : const SizedBox();
          } else { */
          bool isCompleted = room.roomStatus == true;

          return Stack(
            children: [
              EmployeeDirectoryComponents.tile(
                context,
                title: room.roomName,
                onTap: () async {
                  await Get.toNamed(AppRoutes.TASKS_LISTS, arguments: room);
                  final controller = Get.find<RoomListController>();
                  controller.fromTaskList = true;
                  controller.fetchRoomsList(hasData: true);
                },
                trailingWidget: RoomListComponents.statusWidget(
                  context,
                  isComplete: isCompleted,
                ),
              ),
              if (room.taskProgress?.totalTicketCount != null &&
                  room.taskProgress?.totalTicketCount != 0)
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15), // Rounded edges
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Ticket",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              if (!isCompleted)
                Positioned(
                  bottom: 10,
                  child: Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15), // Rounded edges
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${room.taskProgress!.totalTicketCount! + room.taskProgress!.completedTasksCount!}/${room.taskProgress?.totalTasksCount}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
            ],
          );
          // }
        },
      );
    } else {
      return SettingsComponents.noResultsFound(
          context, AppStrings.noRoomsFound);
    }
  }
}
