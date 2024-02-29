import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/settings/components/settings_components.dart';
import 'package:roomrounds/module/settings/controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        backButtunColor: AppColors.primary,
        title: AppStrings.settings,
        showMailIcon: false,
        showNotificationIcon: false,
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
                    title: "Notification Settings"),
                SettingsComponents.tile(context, title: "Help"),
                SettingsComponents.tile(context, title: "Contact Us"),
                SettingsComponents.tile(context, title: "Rate Us"),
              ],
            ),
          );
        },
      ),
    );
  }
}
