import '../../../core/constants/imports.dart';
import '../controller/ticket_chat_controller.dart';

class TicketChatImagePreviewScreen extends StatelessWidget {
  final String ticketId;
  final String receiverId;
  final String senderId;

  const TicketChatImagePreviewScreen({
    super.key,
    required this.ticketId,
    required this.receiverId,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context) {
    var mController = Get.find<TicketChatController>();
    final senderId = profileController.user!.userId.toString();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Image Preview - Takes most of the screen
              Expanded(
                child: InteractiveViewer(
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.file(
                      mController.selectedImageFile.value!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Bottom Caption Area
              Container(
                color: Colors.black87,
                padding: const EdgeInsets.all(12.0),
                child: CustomTextField(
                  controller: mController.messageController,
                  validator: (value) => null,
                  borderRadius: 30,
                  hintText: "Add a caption...",
                  suffixIcon: AppImages.send,
                  hintTextColor: AppColors.white,
                  textColor: AppColors.white,
                  onSuffixTap: () {
                    mController.update();
                    if (mController.isLoading.value != true) {
                      mController
                          .sendMessage(
                            receiverId: receiverId,
                            senderId: senderId,
                            content:
                                mController.messageController.value.text.trim(),
                            type: 'text',
                            ticketId: ticketId,

                          )
                          .then((value) => Get.back());
                    }
                  },
                  maxLines: 3,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
          // Loading Indicator
          Obx(() => mController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
