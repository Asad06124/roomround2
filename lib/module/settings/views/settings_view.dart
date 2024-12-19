import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/settings/controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        backButtunColor: AppColors.primary,
        title: AppStrings.settings,
        showMailIcon: true,
        showNotificationIcon: true,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
        isHome: false,
      ),
      body: GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                SettingsComponents.tile(context,
                    title: AppStrings.notificationSettings),
                SettingsComponents.tile(context, title: AppStrings.help),
                SettingsComponents.tile(context,
                    title: AppStrings.privacyPolicy.capitalize!),
                SettingsComponents.tile(context, title: AppStrings.contactUs),
                SettingsComponents.tile(context, title: AppStrings.rateUs),
              ],
            ),
          );
        },
      ),
    );
  }
}
