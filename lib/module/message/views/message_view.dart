import 'dart:developer';

import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/message/controller/chat_controller.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/apis/models/employee/employee_model.dart';
import '../../emloyee_directory/controller/employee_directory_controller.dart';

class MessageView extends GetView<EmployeeDirectoryController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    var chatController = Get.find<ChatController>();
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 75,
        backButtunColor: AppColors.textPrimary,
        title: userData.type == UserType.manager
            ? AppStrings.messages
            : AppStrings.messageAndResponse,
        showNotificationIcon: false,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.textPrimary),
        iconsClor: AppColors.textPrimary,
        isHome: false,
        showMailIcon: false,
        isBackButtun: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SB.w(context.width),
            CustomTextField(
              borderRadius: 35,
              fillColor: AppColors.white,
              hintText: AppStrings.searchEmployee,
              isShadow: true,
              validator: (value) {
                return null;
              },
              suffixIcon: AppImages.search,
            ),
            SB.h(10),
            GetBuilder<EmployeeDirectoryController>(
              init: EmployeeDirectoryController(),
              builder: (controller) {
                String currentUserId =
                    profileController.user!.userId.toString();
                return controller.hasData
                    ? FutureBuilder<List<EmployeeWithLiveChat>>(
                        future: chatController.setupLiveChats(
                            controller.searchResults, currentUserId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomLoader();
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No chats found.'));
                          }

                          List<EmployeeWithLiveChat> liveChats = snapshot.data!;

                          return Expanded(
                            child: SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: liveChats.length,
                                itemBuilder: (context, index) {
                                  EmployeeWithLiveChat liveChat =
                                      liveChats[index];
                                  Employee employee = liveChat.employee;

                                  String imageUrl =
                                      (employee.imageKey?.isNotEmpty ?? false)
                                          ? '${Urls.domain}${employee.imageKey}'
                                          : AppImages.personPlaceholder;

                                  Color roleColor =
                                      employee.roleName?.toLowerCase() ==
                                              'manager'
                                          ? Color(0xff326FEA)
                                          : AppColors.darkGrey;

                                  return StreamBuilder<ChatViewModel>(
                                    stream: CombineLatestStream.combine2(
                                      liveChat.lastMessageStream,
                                      liveChat.unreadCountStream,
                                      (String lastMessage, int unreadCount) =>
                                          ChatViewModel(
                                        lastMessage: lastMessage,
                                        unreadCount: unreadCount,
                                      ),
                                    ),
                                    builder: (context, chatSnapshot) {
                                      return CustomeTiles.employeeTile(
                                        context,
                                        notificationCount:
                                            chatSnapshot.data?.unreadCount ?? 0,
                                        image: imageUrl,
                                        title: employee.employeeName,
                                        subHeading: employee.roleName,
                                        subtile:
                                            chatSnapshot.data?.lastMessage ??
                                                'Loading...',
                                        roleColor: roleColor,
                                        onPressed: () {
                                          log('Fcm Token For Push Notification: ${employee.fcmToken}');
                                          Get.toNamed(AppRoutes.CHAT,
                                              arguments: {
                                                'receiverId':
                                                    employee.userId.toString(),
                                                'receiverImgUrl': imageUrl,
                                                'receiverDeviceToken':
                                                    employee.fcmToken,
                                                'name':
                                                    '${employee.firstName}${employee.lastName}',
                                              });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : const CustomLoader();
              },
            )
          ],
        ),
      ),
    );
  }
}
