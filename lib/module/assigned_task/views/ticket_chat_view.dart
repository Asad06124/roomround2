import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/apis/models/tickets/ticket_model.dart';
import '../../../core/constants/imports.dart';
import '../../../core/extensions/datetime_extension.dart';
import '../components/ticket_message_components.dart';
import '../controller/assigned_task_controller.dart';
import '../controller/ticket_chat_controller.dart';

class TicketChatView extends StatelessWidget {
  final String ticketId;
  final String receiverId;
  final bool isAssignedToMe;
  final Ticket ticket;
  final String senderId;
  final String ticketTitle;

  TicketChatView({
    super.key,
    required this.ticketId,
    required this.receiverId,
    required this.ticket,
    required this.senderId,
    required this.ticketTitle,
    required this.isAssignedToMe,
  });

  final LayerLink link = LayerLink();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
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
          preferredSize: Size.fromHeight(70),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        assignedTaskController.onTicketTap(
                          type: assignedTaskController.ticketsType,
                          ticket: ticket,
                          isManager: isManager,
                          isClosed: ticket.isClosed!,
                        );
                      },
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
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.markMessagesAsSeen(ticketId, receiverId);
                });
              }

              return ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final message = snapshot.data![index];
                  final messageDate = message.updatedAt;

                  bool showDateHeader = false;
                  if (index == snapshot.data!.length - 1) {
                    showDateHeader = true;
                  } else {
                    final prevMessageDate = snapshot.data![index + 1].updatedAt;
                    if (!isSameDay(messageDate, prevMessageDate)) {
                      showDateHeader = true;
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showDateHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              getDateLabel(messageDate),
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                          ),
                        ),
                      if (message.type == 'system')
                        _buildSystemMessage(message)
                      else
                        TicketMessageComponents.messageTile(
                          context,
                          isSender: isAssignedToMe == false
                              ? int.parse(message.senderId) != ticket.assignBy
                              : int.parse(message.senderId) == ticket.assignBy,
                          msg: message.content,
                          time: DateTimeExtension.formatTimeOnly(
                            message.updatedAt.toString(),
                          ),
                          isDelivered: message.isDelivered,
                          isSeen: message.isSeen,
                          imageUrl: message.imageUrl,
                          controller: controller,
                        ),
                    ],
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
                          ticketId: ticket.ticketId.toString(),
                          receiverId: receiverId,
                          senderId: senderId,
                          content: controller.messageController.text.trim(),
                          type: 'text',
                          ticket: ticket,
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

  Widget _buildSystemMessage(ChatMessage message) {
    final regex = RegExp(r'Assignee changed from (.+?) to (.+)');
    final match = regex.firstMatch(message.content);
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black54, fontSize: 12),
            children: [
              const TextSpan(text: 'Assignee changed from '),
              TextSpan(
                text: match?.group(1) ?? '',
                style: const TextStyle(color: Colors.blue),
              ),
              const TextSpan(text: ' to '),
              TextSpan(
                text: match?.group(2) ?? '',
                style: const TextStyle(color: Colors.blue),
              ),
            ],
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
            ticket: ticket,
            child: Assets.icons.add.svg(),
          ),
        ],
      ),
    );
  }

  String getDateLabel(DateTime date) {
    final now = DateTime.now();
    if (isSameDay(date, now)) {
      return 'Today';
    } else if (isSameDay(date, now.subtract(Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('MM-dd-yyyy').format(date);
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
