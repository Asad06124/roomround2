import 'package:flutter/services.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/message/components/message_components.dart';

import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/components/app_image.dart';
import '../../../core/extensions/datetime_extension.dart';
import '../controller/chat_controller.dart';

class ChatView extends StatelessWidget {
  final String receiverId;
  final String receiverImgUrl;
  final String receiverDeviceToken;
  final String name;
  final String senderId;

  ChatView({super.key})
      : receiverId = Get.arguments['receiverId'],
        receiverImgUrl =
            Get.arguments['receiverImgUrl'] ?? AppImages.personPlaceholder,
        receiverDeviceToken = Get.arguments['receiverDeviceToken'] ?? "",
        name = Get.arguments['name'] ?? '',
        senderId = profileController.user!.userId.toString();

  LayerLink link = LayerLink();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    var controller = Get.find<ChatController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: controller.chatFontSize * 1.2,
                        color: AppColors.textPrimary,
                      )),
                  AppImage.network(
                    imageUrl: receiverImgUrl,
                    borderRadius: BorderRadius.circular(25),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    height: controller.chatFontSize * 2.5,
                    width: controller.chatFontSize * 2.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleSmall!.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: controller.chatFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 45),
          color: Colors.grey[50],
          child: StreamBuilder<List<ChatMessage>>(
            stream: controller.getMessages(receiverId, senderId),
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
                      SizedBox(height: 10),
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
              final chatRoomId = controller.getChatRoomId(senderId, receiverId);
              controller.markMessagesAsSeen(chatRoomId, receiverId);

              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return MessageComponents.messageTile(
                    context,
                    sender: message.receiverId ==
                        profileController.user!.userId.toString(),
                    msg: message.content,
                    time: DateTimeExtension.formatTimeOnly(
                        message.updatedAt.toString()),
                    isDelivered: message.isDelivered,
                    isSeen: message.isSeen,
                    imageUrl: message.imageUrl,
                    recieverImageUrl: receiverImgUrl,
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
                      offset: const Offset(2, 0))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _chatPrefeixIcons(context, controller),
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
                      controller.update();
                      controller.isLoading.value != true
                          ? controller.sendMessage(
                              receiverId: receiverId.toString(),
                              senderId: senderId.toString(),
                              content: controller.messageController.value.text
                                  .trim(),
                              type: 'text',
                              senderName: profileController.user!.username!,
                              receiverDeviceToken: receiverDeviceToken,
                              receiverImgUrl: receiverImgUrl,
                            )
                          : null;
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

  Widget _chatPrefeixIcons(
    BuildContext context,
    ChatController mController,
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
          CustomePainterDialouge(
            controller: mController.overlayController,
            link: link,
            onTap: () {
              mController.overlayController.toggle();
              mController.update();
            },
            receiverDeviceToken: receiverDeviceToken,
            receiverImgUrl: receiverImgUrl,
            receiverId: receiverId,
            name: name,
            child: Assets.icons.add.svg(),
          ),
        ],
      ),
    );
  }
}
