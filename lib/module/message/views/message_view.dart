import 'package:roomrounds/core/constants/imports.dart';

class MessageView extends StatelessWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 75,
        backButtunColor: AppColors.textPrimary,
        title: userData.type == UserType.manager
            ? AppStrings.messages
            : AppStrings.messageAndResponse,
        showNotificationIcon: false,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.textPrimary),
        iconsClor: AppColors.textPrimary,
        isHome: false,
        showMailIcon: false,
        isBackButtun: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SB.w(context.width),
            CustomTextField(
              borderRadius: 35,
              fillColor: AppColors.white,
              hintText: AppStrings.searchEmployee,
              isShadow: true,
              validator: (value) {
                return null;
              },
              suffixIcon: AppImages.search,
            ),
            SB.h(10),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: 12,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CustomeTiles.employeeTile(
                      context,
                      notificationCount: index,
                      onPressed: () => Get.toNamed(AppRoutes.CHAT),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
