import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/assigned_task/components/assigned_tasks_components.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(0),
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 140,
        isBackButtun: true,
        titleStyle: context.titleLarge,
        title: AppStrings.notification,
        showNotificationIcon: false,
        isHome: false,
        decriptionWidget: AssignedTaskComponents.appBatTile(context),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              // width: context.width,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                      const SizedBox(),
                      Text(
                        "Clear All",
                        style: context.titleSmall!.copyWith(
                          color: AppColors.gry,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.gry,
                        ),
                      ),
                    ],
                  ),
                  SB.h(15),
                  CustomeTiles.notificationTile(context),
                  CustomeTiles.notificationTile(context),
                  CustomeTiles.notificationTile(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
