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
      String title = "Robert Brown"}) {
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
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
                      : context.titleSmall,
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showNotificationIcon)
                      notificationActive
                          ? Assets.icons.bellActive.svg()
                          : Assets.icons.bell.svg(),
                    if (showMailIcon) ...{
                      SB.w(notificationActive ? 15 : 20),
                      Assets.icons.mail.svg()
                    },
                  ],
                )
              ],
            ),
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
