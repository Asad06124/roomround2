import 'package:roomrounds/core/constants/imports.dart';

class NotificationSettingView extends StatelessWidget {
  const NotificationSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        title: 'Notification Settings',
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        backButtunColor: AppColors.primary,
        iconsClor: AppColors.primary,
        isHome: false,
        isBackButtun: true,
        showMailIcon: false,
        notificationActive: false,
        showNotificationIcon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your notifications',
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(context, 'All Notifications', true),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
      BuildContext context, String title, bool value) {
    return SwitchListTile(
      title: Text(
        title,
      ),
      value: value,
      onChanged: (bool newValue) {},
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withOpacity(0.3),
    );
  }
}
