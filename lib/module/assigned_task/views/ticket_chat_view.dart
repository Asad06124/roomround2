import 'package:flutter/services.dart';

import '../../../core/apis/models/tickets/ticket_model.dart';
import '../../../core/constants/imports.dart';
import '../../../core/extensions/datetime_extension.dart';

// import '../../message/components/message_components.dart';
import '../../message/controller/chat_controller.dart';
import '../components/ticket_message_components.dart';
import '../controller/assigned_task_controller.dart';
import '../controller/ticket_chat_controller.dart';

class TicketChatView extends StatelessWidget {
  final String ticketId;
  final String receiverId;
  Ticket ticket;
  final String senderId;
  final String ticketTitle;
  final String? receiverImage;

  TicketChatView({
    super.key,
    required this.ticketId,
    required this.receiverId,
    required this.ticket,
    required this.senderId,
    required this.ticketTitle,
    required this.receiverImage,
  });

  final LayerLink link = LayerLink();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    bool isManager = profileController.isManager;

    final controller = Get.find<TicketChatController>();
    AssignedTaskController assignedTaskController = Get.find();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top - 15,
              bottom: MediaQuery.of(context).padding.top - 15,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: controller.chatFontSize * 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    height: controller.chatFontSize * 2.5,
                    width: controller.chatFontSize * 2.5,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.task_sharp,
                        color: AppColors.primary,
                        size: controller.chatFontSize * 1.5,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      assignedTaskController.onTicketTap(
                        type: assignedTaskController.ticketsType,
                        ticket: ticket,
                        isManager: isManager,
                        isClosed: ticket.isClosed!,
                      );
                    },
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          ticketTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.titleSmall!.copyWith(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: controller.chatFontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 45),
          color: Colors.grey[50],
          child: StreamBuilder<List<ChatMessage>>(
            stream: controller.getMessages(ticketId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No messages yet",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final messages = snapshot.data!;
              controller.markMessagesAsSeen(ticketId, receiverId);

              return ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return TicketMessageComponents.messageTile(
                    context,
                    sender: message.senderId == receiverId,
                    msg: message.content,
                    time: DateTimeExtension.formatTimeOnly(
                      message.updatedAt.toString(),
                    ),
                    isDelivered: message.isDelivered,
                    isSeen: message.isSeen,
                    imageUrl: message.imageUrl,
                    recieverImageUrl: receiverImage,
                    controller: controller,
                  );
                },
              );
            },
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          width: context.width,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gry.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _chatPrefixIcons(context, controller),
                SizedBox(
                  width: context.width -
                      (context.width * 0.38 > 90 ? 105 : context.width * 0.38) -
                      30,
                  child: CustomTextField(
                    controller: controller.messageController,
                    validator: (value) => null,
                    borderRadius: 30,
                    hintText: AppStrings.typeeMessageHere,
                    suffixIcon: AppImages.send,
                    onSuffixTap: () {
                      if (controller.messageController.text.trim().isNotEmpty) {
                        controller.sendMessage(
                          ticketId: ticketId,
                          receiverId: receiverId,
                          senderId: senderId,
                          content: controller.messageController.text.trim(),
                          type: 'text',
                        );
                      }
                    },
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatPrefixIcons(
    BuildContext context,
    TicketChatController mController,
  ) {
    return Container(
      width: context.width * 0.20,
      constraints: const BoxConstraints(
        maxWidth: 90,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          TicketCustomePainterDialouge(
            controller: mController.overlayController,
            link: link,
            onTap: () {
              mController.overlayController.toggle();
              mController.update();
            },
            ticketId: ticketId,
            receiverId: receiverId,
            senderId: senderId,
            child: Assets.icons.add.svg(),
          ),
        ],
      ),
    );
  }
}
