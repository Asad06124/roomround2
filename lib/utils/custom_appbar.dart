import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/extensions/datetime_extension.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';

class CustomAppbar {
  static PreferredSize simpleAppBar(BuildContext context,
      {required double height,
      bool showWlcomeMessage = false,
      bool showMailIcon = true,
      bool showNotificationIcon = true,
      bool notificationActive = true,
      bool isHome = false,
      bool isBackButtun = false,
      Color? backButtunColor,
      Color? iconsClor,
      TextStyle? titleStyle,
      Widget? decriptionWidget,
      Widget? actionWidget,
      String? title}) {
    final txtStyle = titleStyle ?? context.titleLarge;
    double iconHeight = isHome ? 20 : 20;
    final iconWeight = iconHeight;
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Padding(
        padding: EdgeInsets.only(
          top: context.paddingTop + (isBackButtun ? 10 : 20),
          left: isBackButtun ? 5 : 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (isBackButtun) ...{
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: backButtunColor ?? AppColors.white,
                    ),
                  ),
                  // InkWell(
                  //   onTap: () => Get.back(),
                  //   borderRadius: BorderRadius.circular(35),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: Icon(
                  //       Icons.arrow_back,
                  //       color: backButtunColor ?? AppColors.white,
                  //     ),
                  //   ),
                  // ),
                  SB.w(0),
                },
                if (title?.isNotEmpty == true)
                  Text(
                    title ?? '',
                    style: isHome
                        ? context.displaySmall!.copyWith(
                            color: AppColors.white,
                          )
                        : txtStyle,
                  ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showNotificationIcon)
                      GetBuilder<NotificationController>(
                        init: notificationsController,
                        builder: (controller) {
                          bool hasNotifications =
                              controller.hasUnreadNotifications;
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.find<NotificationController>()
                                      .fetchNotificationsList();
                                  Get.toNamed(AppRoutes.NOTIFICATION);
                                },
                                child: Assets.icons.bell.svg(
                                  colorFilter: iconsClor != null
                                      ? ColorFilter.mode(
                                          iconsClor, BlendMode.srcIn)
                                      : null,
                                  height: iconHeight + 4,
                                  width: iconWeight + 4,
                                ),
                              ),
                              if (hasNotifications)
                                Positioned(
                                  right: 3,
                                  top: 2,
                                  child: CircleAvatar(
                                    radius: iconWeight * 0.24,
                                    backgroundColor: AppColors.orange,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    if (showMailIcon) ...{
                      SB.w(10),
                      GetBuilder<ProfileController>(
                        builder: (controller) {
                          return GestureDetector(
                            onTap: () {
                              controller.fetchUserProfile();
                              Get.offNamed(AppRoutes.MESSAGE);
                            },
                            child: Assets.icons.mail.svg(
                              colorFilter: iconsClor != null
                                  ? ColorFilter.mode(iconsClor, BlendMode.srcIn)
                                  : null,
                              height: iconHeight,
                              width: iconWeight,
                            ),
                          );
                        },
                      ),
                    },
                    if (actionWidget != null) actionWidget,
                  ],
                ),
              ],
            ),
            if (decriptionWidget != null) ...{SB.h(10), decriptionWidget},
            if (showWlcomeMessage) ...{
              SB.h(5),
              Text(
                AppStrings.welcomeBack,
                textAlign: TextAlign.left,
                style: context.titleSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            }
          ],
        ),
      ),
    );
  }

  static Widget appBatTile(BuildContext context,
      {String? name, String? desc, double padding = 15}) {
    String? date = DateTime.now().format();
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SB.h(10),
              Text(
                name ?? '',
                style: context.titleMedium,
              ),
              Text(
                desc ?? '',
                style: context.bodyLarge!
                    .copyWith(color: AppColors.lightWhite.withOpacity(0.7)),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Center(
              child: Text(
                date,
                style: context.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
