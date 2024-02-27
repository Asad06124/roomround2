import 'package:roomrounds/core/constants/imports.dart';

class MessageView extends StatelessWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 75,
        backButtunColor: AppColors.primary,
        title: AppStrings.messageAndResponse,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
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
              hintText: "Search employee",
              isShadow: true,
              validator: (value) {
                return null;
              },
              suffixIcon: AppImages.search,
            ),
            SB.h(10),
            CustomeTiles.employeeTile(context, notificationCount: 5),
            CustomeTiles.employeeTile(context, notificationCount: 10),
            CustomeTiles.employeeTile(context, notificationCount: 6),
            CustomeTiles.employeeTile(context, notificationCount: 0),
          ],
        ),
      ),
    );
  }
}
