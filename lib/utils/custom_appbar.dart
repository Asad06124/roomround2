import 'package:roomrounds/core/constants/imports.dart';

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
      String title = "Robert Brown"}) {
    final txtStyle = titleStyle ?? context.titleLarge;
    double iconHeight = isHome ? 25 : 20;
    final iconWeight = iconHeight;
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Padding(
        padding: EdgeInsets.only(
          top: context.paddingTop + 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isBackButtun) ...{
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(35),
                    child: Icon(
                      Icons.arrow_back,
                      color: backButtunColor ?? AppColors.white,
                    ),
                  ),
                  SB.w(20),
                },
                Text(
                  title,
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
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.NOTIFICATION),
                        child: notificationActive
                            ? Assets.icons.bellActive.svg(
                                color: iconsClor,
                                height: iconHeight + 8,
                                width: iconWeight + 8,
                              )
                            : Assets.icons.bell.svg(
                                color: iconsClor,
                                height: iconHeight + 3,
                                width: iconWeight + 3,
                              ),
                      ),
                    if (showMailIcon) ...{
                      SB.w(notificationActive ? 15 : 20),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.MESSAGE),
                        child: Assets.icons.mail.svg(
                          color: iconsClor,
                          height: iconHeight,
                          width: iconWeight,
                        ),
                      )
                    },
                  ],
                )
              ],
            ),
            if (decriptionWidget != null) ...{SB.h(10), decriptionWidget},
            if (showWlcomeMessage) ...{
              SB.h(5),
              Text(
                AppStrings.welcomeBack,
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
}
