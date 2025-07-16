import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/apis/models/maintenance_task_model.dart';
import '../../../core/constants/imports.dart';
import '../../../core/extensions/datetime_extension.dart';
import '../controller/maintenance_task_chat_controller.dart';
import '../../assigned_task/components/ticket_message_components.dart';

class MaintenanceTaskChatView extends StatelessWidget {
  final String taskId;
  final String receiverId;
  final MaintenanceTask task;
  final String senderId;
  final String taskTitle;
  final bool isAssignedToMe;

  MaintenanceTaskChatView({
    super.key,
    required this.taskId,
    required this.receiverId,
    required this.task,
    required this.senderId,
    required this.taskTitle,
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

    final controller = Get.put(MaintenanceTaskChatController());
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        taskTitle,
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
                ],
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 45),
          color: Colors.grey[50],
          child: StreamBuilder<List<ChatMessage>>(
            stream: controller.getMessages(taskId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.markMessagesAsSeen(taskId, receiverId);
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
                          isSender:
                               int.parse(message.senderId) !=int.parse(senderId)
                                      ,
                              // // :
                              // int.parse(message.senderId) ==
                              //     (task.maintenanceTaskAssigns?.userId ?? 0),
                          msg: message.content,
                          time: DateTimeExtension.formatTimeOnly(
                            message.updatedAt.toString(),
                          ),
                          isDelivered: message.isDelivered,
                          isSeen: message.isSeen,
                          imageUrl: message.imageUrl,
                          isAdmin: message.isAdmin,
                          senderName: message.senderName,
                          senderImageUrl: message.senderImageUrl,
                          controller: controller as dynamic,
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
                          taskId: taskId,
                          receiverId: receiverId,
                          senderId: senderId,
                          content: controller.messageController.text.trim(),
                          type: 'text',
                          task: task,
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
    MaintenanceTaskChatController mController,
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
            ticketId: taskId,
            receiverId: receiverId,
            senderId: senderId,
            ticket: task as dynamic,
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
