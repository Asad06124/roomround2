import 'package:roomrounds/core/constants/imports.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        title: 'Contact Us',
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
            _buildSectionTitle('We\'d Love to Hear From You'),
            const SizedBox(height: 16),
            _buildSectionContent(
              'If you have any questions or concerns, feel free to reach out to us. You can contact us through the following methods:',
            ),
            const SizedBox(height: 32),
            _buildContactItem('Email', 'admin@gmail.com'),
            _buildContactItem('Address', '[Insert Address]'),
            _buildContactItem('Phone', '[Insert Phone Number]'),
            const SizedBox(height: 32),
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
        fontSize: 18,
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

  Widget _buildContactItem(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.contact_mail, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $info',
              style: const TextStyle(fontSize: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageForm(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Message:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _messageController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Enter your message here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Logic to send the message, e.g., API call or email client
            final message = _messageController.text;
            if (message.isNotEmpty) {
              // Handle sending message, for example, display a confirmation or submit it to an API
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Message Sent'),
                  content:
                      const Text('Your message has been sent successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: context.bodyLarge!.copyWith(color: Colors.white),
          ),
          child: const Text('Send Message'),
        ),
      ],
    );
  }
}
