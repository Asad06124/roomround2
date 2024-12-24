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
                    title: AppStrings.notificationSettings, onPressed: () {
                  Get.toNamed(AppRoutes.Notification_Setting_View);
                }),
                SettingsComponents.tile(context, title: AppStrings.help,
                    onPressed: () {
                  Get.toNamed(AppRoutes.Help_Screen);
                }),
                SettingsComponents.tile(
                  context,
                  title: AppStrings.privacyPolicy.capitalize!,
                  onPressed: () {
                    Get.toNamed(AppRoutes.Privacy_Policy_Screen);
                  },
                ),
                SettingsComponents.tile(
                  context,
                  title: AppStrings.contactUs,
                  onPressed: () {
                    Get.toNamed(AppRoutes.Contact_Us_Screen);
                  },
                ),
                SettingsComponents.tile(
                  context,
                  title: AppStrings.rateUs,
                  onPressed: () {
                    _showRateUsDialog(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void _showRateUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Rate Us',
          style: context.bodyLarge!.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'If you enjoy using the app, please take a moment to rate us.',
              style: context.bodyLarge!.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.star, color: Colors.yellow),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.star, color: Colors.yellow),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.star),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.star),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.star),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle dismiss action if user doesn't want to rate
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Not Now'),
            ),
          ],
        ),
      );
    },
  );
}
