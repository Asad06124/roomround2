import 'package:roomrounds/core/apis/models/notifications/notification_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        init: NotificationController(),
        builder: (controller) {
          User? user = profileController.user;
          return CustomContainer(
            padding: const EdgeInsets.all(0),
            appBar: CustomAppbar.simpleAppBar(
              context,
              height: 140,
              isBackButtun: true,
              titleStyle: context.titleLarge,
              title: AppStrings.notification,
              showNotificationIcon: false,
              showMailIcon: false,
              isHome: false,
              decriptionWidget: CustomAppbar.appBatTile(
                context,
                name: user?.username,
                desc: user?.role,
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
                        if (controller.notificationsList.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              InkWell(
                                onTap: controller.clearAllNotifications,
                                child: Text(
                                  AppStrings.clearAll,
                                  style: context.titleSmall!.copyWith(
                                    color: Colors.transparent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.gry,
                                    shadows: [
                                      const Shadow(
                                        color: AppColors.gry,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SB.h(15),
                        Expanded(
                          child: controller.hasData
                              ? _buildNotificationsList(
                                  context,
                                  controller.notificationsList,
                                  onCloseTap: controller.removeNotification,
                                )
                              : CustomLoader(),
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

  Widget _buildNotificationsList(
      BuildContext context, List<NotificationModel> list,
      {ValueChanged<int?>? onCloseTap}) {
    if (list.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          NotificationModel notification = list[index];

          return CustomeTiles.notificationTileSimple(context,
              title: notification.notificationTitle,
              description: notification.notificationDescription,
              createdDate: notification.createdDate,
              onCloseTap: onCloseTap != null
                  ? () => onCloseTap(notification.notificationId)
                  : null, onPressed: () {
            if (notification.notificationTitle
                    ?.toLowerCase()
                    .contains('template') ==
                true) {
              if (notification.isAssignTemplateActive == true) {
                Get.toNamed(AppRoutes.ROOMS_LIST);
              } else {
                CustomOverlays.showToastMessage(
                  title: 'Oh no!',
                  message: 'Template is not available.',
                  isSuccess: false,
                );
              }
            }
            if (notification.notificationDescription
                        ?.toLowerCase()
                        .contains('ticket') ==
                    true ||
                notification.notificationTitle
                        ?.toLowerCase()
                        .contains('ticket') ==
                    true) {
              Get.toNamed(AppRoutes.ASSIGNED_TASKS);
            }
          });
        },
      );
    } else {
      return _noMessagesFound(context);
    }
  }

  Widget _noMessagesFound(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.images.mailBoxEmpty.svg(),
        Text(
          AppStrings.noNotificationFound,
          style: context.titleMedium!.copyWith(
            color: AppColors.gry,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(35),
      ],
    );
  }
}
