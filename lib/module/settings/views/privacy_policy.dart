import 'package:roomrounds/core/constants/imports.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        title: 'Privacy Policy',
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
            _buildSectionTitle('Effective Date: [Insert Date]'),
            const SizedBox(height: 16),
            _buildSectionTitle('1. Information We Collect'),
            _buildSectionContent(
              'We collect the following types of information:\n'
              'Personal Information: When you create an account, we may collect information such as your name, email address, contact details, and position within the institution (hospital/organization).\n'
              'Usage Data: We collect information about your interactions with the app, including but not limited to device information, IP address, and activity logs.\n'
              'Room and Task Data: Information related to room management, such as room identifiers, assigned tasks, task completion status, and templates applied.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('2. How We Use Your Information'),
            _buildSectionContent(
              'To provide and improve our services, including assigning tasks to managers and tracking room status within hospitals or institutions.\n'
              'To manage user accounts, including authentication and security.\n'
              'To communicate with you about updates, improvements, and any changes to the platform.\n'
              'To ensure the completion of room tasks as per the predefined templates.\n'
              'To monitor and analyze the use of the app for the purpose of improving functionality and enhancing the user experience.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('3. Data Sharing and Disclosure'),
            _buildSectionContent(
              'We do not share your personal data with third parties, except in the following situations:\n'
              'With Your Consent: We may share your data with third parties when you explicitly provide consent.\n'
              'Service Providers: We may share your information with service providers who assist us in operating the app, such as cloud storage providers or IT support.\n'
              'Legal Compliance: We may disclose your information if required by law or in response to valid legal requests, such as subpoenas.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('4. Data Security'),
            _buildSectionContent(
              'We take reasonable precautions to protect your personal information from unauthorized access, disclosure, or misuse. However, no data transmission or storage system can be guaranteed to be 100% secure.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('5. Your Data Rights'),
            _buildSectionContent(
              'You have the following rights regarding your data:\n'
              'Access: You may request to see the data we have about you.\n'
              'Correction: You may request that we correct any inaccurate information.\n'
              'Deletion: You may request the deletion of your data, though this may affect your ability to use the app.\n'
              'Portability: You can request a copy of your data in a machine-readable format.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('6. Cookies and Tracking Technologies'),
            _buildSectionContent(
              'Our web app may use cookies and similar tracking technologies to enhance user experience. You may modify your browser settings to reject cookies, though this may limit functionality.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('7. Children Privacy'),
            _buildSectionContent(
              'We do not knowingly collect personal information from children under the age of 13. If we become aware that a child under 13 has provided us with personal information, we will take steps to remove such information.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('8. Changes to This Privacy Policy'),
            _buildSectionContent(
              'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy on our website or via email notification.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('9. Contact Us'),
            _buildSectionContent(
              'If you have any questions or concerns about this Privacy Policy, please contact us at:\n'
              'Email: admin@gmail.com\n'
              'Address: [Insert Address]\n'
              'Phone: [Insert Phone Number]',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.primary,
      ),
    );
  }
}
