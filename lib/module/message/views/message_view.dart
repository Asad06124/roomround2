import 'dart:developer';

import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/message/controller/chat_controller.dart';
import 'package:rxdart/rxdart.dart' as rxDart;

import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/apis/models/employee/employee_model.dart';
import '../../emloyee_directory/controller/employee_directory_controller.dart';

class MessageView extends GetView<EmployeeDirectoryController> {
  MessageView({super.key});

  Future<List<EmployeeWithLiveChat>>? _cachedFuture;

  @override
  Widget build(BuildContext context) {
    var chatController = Get.find<ChatController>();
    var searchQuery = ''.obs;
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
              onChange: (search) {
                searchQuery.value = search;
              },
              suffixIcon: AppImages.search,
            ),
            SB.h(10),
            GetBuilder<EmployeeDirectoryController>(
              init: EmployeeDirectoryController(),
              builder: (controller) {
                String currentUserId =
                    profileController.user!.userId.toString();

                if (controller.hasData && _cachedFuture == null) {
                  _cachedFuture = chatController.setupLiveChats(
                      controller.searchResults, currentUserId);
                }

                return controller.hasData
                    ? FutureBuilder<List<EmployeeWithLiveChat>>(
                        future: _cachedFuture,
                        builder: (context, snapshot) {
                          if (_cachedFuture == null) {
                            return const CustomLoader();
                          }

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

                          return Obx(() {
                            List<EmployeeWithLiveChat> filteredChats =
                                searchQuery.value.isEmpty
                                    ? liveChats
                                    : liveChats.where((liveChat) {
                                        return liveChat.employee.employeeName!
                                            .toLowerCase()
                                            .contains(searchQuery.value
                                                .toLowerCase());
                                      }).toList();

                            return filteredChats.isEmpty
                                ? const Expanded(
                                    child: Center(
                                      child:
                                          Text('No matching employees found.'),
                                    ),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: filteredChats.length,
                                        itemBuilder: (context, index) {
                                          EmployeeWithLiveChat liveChat =
                                              filteredChats[index];
                                          Employee employee = liveChat.employee;

                                          String imageUrl = (employee
                                                      .imageKey?.isNotEmpty ??
                                                  false)
                                              ? '${Urls.domain}${employee.imageKey}'
                                              : AppImages.personPlaceholder;

                                          Color roleColor = employee.roleName
                                                      ?.toLowerCase() ==
                                                  'manager'
                                              ? const Color(0xff326FEA)
                                              : AppColors.darkGrey;

                                          return StreamBuilder<ChatViewModel>(
                                            stream: rxDart.CombineLatestStream
                                                .combine2(
                                              liveChat.lastMessageStream,
                                              liveChat.unreadCountStream,
                                              (String lastMessage,
                                                      int unreadCount) =>
                                                  ChatViewModel(
                                                lastMessage: lastMessage,
                                                unreadCount: unreadCount,
                                              ),
                                            ),
                                            builder: (context, chatSnapshot) {
                                              return CustomeTiles.employeeTile(
                                                context,
                                                notificationCount: chatSnapshot
                                                        .data?.unreadCount ??
                                                    0,
                                                image: imageUrl,
                                                title: employee.employeeName,
                                                subHeading: employee.roleName,
                                                subtile: chatSnapshot
                                                        .data?.lastMessage ??
                                                    'Loading...',
                                                roleColor: roleColor,
                                                onPressed: () {
                                                  log('Fcm Token For Push Notification: ${employee.fcmToken}');
                                                  Get.toNamed(AppRoutes.CHAT,
                                                      arguments: {
                                                        'receiverId': employee
                                                            .userId
                                                            .toString(),
                                                        'receiverImgUrl':
                                                            imageUrl,
                                                        'receiverDeviceToken':
                                                            employee.fcmToken,
                                                        'name':
                                                            '${employee.firstName} ${employee.lastName}',
                                                      });
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                          });
                        },
                      )
                    : const CustomLoader();
              },
            ),
          ],
        ),
      ),
    );
  }
}
