import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/authentications/views/forget_view.dart';
import 'package:roomrounds/module/create_ticket/views/create_ticket_view.dart';
import 'package:roomrounds/module/profile/change_password/view/change_password_view.dart';
import 'package:roomrounds/module/profile/views/edit_profile_view.dart';
import 'package:roomrounds/module/settings/views/contact_view.dart';
import 'package:roomrounds/module/settings/views/help_view.dart';
import 'package:roomrounds/module/settings/views/notification_setting_view.dart';
import 'package:roomrounds/module/settings/views/privacy_policy.dart';

import '../../module/dashboard/controller/dashboard_controller.dart';
import '../../module/emloyee_directory/controller/employee_directory_controller.dart';
import '../../module/message/binding/chat_controller_binding.dart';
import '../../module/message/controller/chat_controller.dart';

class AppPages {
  static Transition? transitionType;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH_SCREEN,
      page: () => const SplashView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {
          // Get.lazyPut<OnboardingController>(
          //   () => OnboardingController(),
          // );
        },
      ),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.FORGET,
      page: () => const ForgetView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {
          Get.lazyPut<DashBoardController>(
            () => DashBoardController(),
          );
          Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
        },
      ),
    ),
    GetPage(
      name: AppRoutes.TEAM_MEMBERS,
      page: () => const TeamMembersView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.ASSIGNED_TASKS,
      page: () => const AssignedTasksView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.MESSAGE,
      page: () =>  MessageView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {
          Get.lazyPut<EmployeeDirectoryController>(
            () => EmployeeDirectoryController(),
          );
          Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
        },
      ),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATION,
      page: () => const NotificationView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.EMPLOYEE_DIRECTORy,
      page: () => EmployeeDirectoryView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.CREATE_TICKET,
      page: () => const CreateTicketView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.ROOM_MAP,
      page: () => const RoomMapView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.ROOM_MAP_DETAILS,
      page: () => const RoomMapDetailsView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => ChatView(),
      transition: transitionType,
      binding: ChatControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.ROOMS_LIST,
      page: () => const RoomListView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.TASKS_LISTS,
      page: () => const TasksList(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    // GetPage(
    //   name: AppRoutes.Chat_Image_Preview,
    //   page: () => const ImagePreviewScreen(),
    //   transition: transitionType,
    //   binding: BindingsBuilder(
    //     () {},
    //   ),
    // ),
    GetPage(
      name: AppRoutes.ROOM_MAP_MANAGER,
      page: () => const RoomMapManagerView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.Notification_Setting_View,
      page: () => const NotificationSettingView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.Help_Screen,
      page: () => const HelpScreen(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.Privacy_Policy_Screen,
      page: () => const PrivacyPolicyScreen(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.Contact_Us_Screen,
      page: () => const ContactUsScreen(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
  ];
}
