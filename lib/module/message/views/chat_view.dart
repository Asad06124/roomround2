import 'dart:developer';

import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/message/components/message_components.dart';

import '../../../core/components/app_image.dart';
import '../../../core/extensions/datetime_extension.dart';
import '../controller/chat_controller.dart';

// ignore: must_be_immutable
class ChatView extends StatefulWidget {
  ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  LayerLink link = LayerLink();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    final arguments = Get.arguments as Map<String, dynamic>;
    final receiverId = arguments['receiverId'];
    final receiverImgUrl = arguments['receiverImgUrl'];
    final receiverDeviceToken = arguments['receiverDeviceToken'];
    final name = arguments['name'];
    final senderId = profileController.user!.userId
        .toString(); // Assuming sender's ID is available

    return SafeArea(
      child: Obx(() {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 15, left: 25, right: 25, bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gry.withOpacity(0.24),
                        offset: const Offset(2, 0),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SB.w(context.width),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            AppImage.network(
                              imageUrl:
                                  receiverImgUrl ?? AppImages.personPlaceholder,
                              borderRadius: BorderRadius.circular(20),
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(width: 20),
                            Text(
                              name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.titleSmall!.copyWith(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SB.h(10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.gry.withOpacity(0.24),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 5, left: 5, right: 5, bottom: 30),
                          child: StreamBuilder<List<ChatMessage>>(
                            stream:
                                controller.getMessages(receiverId, senderId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text("No messages"));
                              }

                              final messages = snapshot.data!;
                              final chatRoomId = controller.getChatRoomId(
                                  senderId, receiverId);
                              controller.markMessagesAsSeen(
                                  chatRoomId, receiverId);
                              return ListView.builder(
                                reverse: true,
                                // This will show latest messages at the bottom
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];
                                  log('${message.imageUrl}');
                                  return MessageComponents.messageTile(
                                    context,
                                    sender: message.receiverId ==
                                        profileController.user!.userId
                                            .toString(),
                                    msg: message.content,
                                    time: DateTimeExtension.formatTimeOnly(
                                        message.updatedAt.toString()),
                                    isDelivered: message.isDelivered,
                                    isSeen: message.isSeen,
                                    imageUrl: message.imageUrl,
                                    recieverImageUrl: receiverImgUrl,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                        (context.width * 0.38 > 90
                            ? 105
                            : context.width * 0.38) -
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
                                receiverImgUrl:
                                    receiverImgUrl, // Assuming sender's name is available
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
        );
      }),
    );
  }

  Widget _chatPrefeixIcons(BuildContext context, ChatController mController) {
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
              child: Assets.icons.add.svg(),
            ),
            if (mController.selectedImageFile.value != null)
              Badge(
                label: InkWell(
                  onTap: () {
                    if (mController.selectedImageFile.value != null) {
                      mController.selectedImageFile.value = null;
                      mController.update();
                      setState(() {});
                    }
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 20,
                    color: AppColors.red,
                  ),
                ),
                backgroundColor: Colors.transparent,
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      FileImage(mController.selectedImageFile.value!),
                ),
              ),
          ],
        ));
  }
}
