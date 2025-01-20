import 'package:roomrounds/core/constants/imports.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        title: 'Help & Support',
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
        child: ListView(
          children: [
            Text(
              'Welcome to Help & Support',
            ),
            const SizedBox(height: 16),
            Text(
              'Here are some useful resources and answers to common questions.',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onContactSupport,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'Contact Support',
                style: context.bodyLarge!.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(
      BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.primary),
              const SizedBox(width: 16),
              Text(
                title,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  // Example Help Item Callbacks
  void _onHowToUse() {
    // Navigate to a detailed how-to page or show relevant information
  }

  void _onAccountIssues() {
    // Navigate to a page for resolving account issues
  }

  void _onNotificationSettings() {
    // Navigate to the NotificationSettingsScreen
  }

  void _onTroubleshooting() {
    // Show common troubleshooting steps or FAQs
  }

  void _onContactSupport() {
    // Open an email client or support page for contacting customer service
  }
}
