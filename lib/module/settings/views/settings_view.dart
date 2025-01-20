import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/message/controller/chat_controller.dart';
import 'package:roomrounds/module/settings/controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var chatController = Get.find<ChatController>();
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
                SettingsComponents.tile(
                  context,
                  title: 'Chat Font Size',
                  onPressed: () {
                    _showFontSizeDialog(context, chatController);
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

void _showFontSizeDialog(BuildContext context, ChatController controller) {
  Get.defaultDialog(
    title: 'Chat Font Size',
    titleStyle: context.bodyLarge!.copyWith(color: AppColors.white),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select your preferred chat font size',
          style: context.bodyLarge!.copyWith(color: AppColors.white),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _fontSizeButton(context, controller, 14.0, 'Small'),
            _fontSizeButton(context, controller, 16.0, 'Medium'),
            _fontSizeButton(context, controller, 18.0, 'Large'),
            _fontSizeButton(context, controller, 20.0, 'Extra Large'),
          ],
        ),
      ],
    ),
    backgroundColor: AppColors.primary,
    radius: 10.0, // Optional: to round the corners of the dialog
  );
}


Widget _fontSizeButton(BuildContext context, ChatController controller, double size, String label) {
  return InkWell(
    onTap: () async {
      await controller.updateFontSize(size);
      Navigator.pop(context);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: controller.chatFontSize == size ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: controller.chatFontSize == size ? Colors.white : AppColors.white,
          fontSize: size,
        ),
      ),
    ),
  );
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
