import 'package:roomrounds/core/constants/imports.dart';

class TicketImageFullView extends StatelessWidget {
  const TicketImageFullView({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        backButtunColor: AppColors.primary,
        iconsClor: AppColors.primary,
        isHome: false,
        isBackButtun: true,
        showMailIcon: false,
        notificationActive: false,
        showNotificationIcon: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
