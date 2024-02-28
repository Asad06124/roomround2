import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/romm_map/views/room_map_details_view.dart';
import 'package:roomrounds/module/romm_map/views/room_map_view.dart';

class AppPages {
  static Transition transitionType = Transition.rightToLeft;

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
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.TEAMMEMBERS,
      page: () => const TeamMembersView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.ASSIGNEDTASKS,
      page: () => const AssignedTasksView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.MESSAGE,
      page: () => const MessageView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
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
      name: AppRoutes.EMPLOYEEDIRECTORy,
      page: () => const EmployeeDirectoryView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.ROOMMAP,
      page: () => const RoomMapView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
    GetPage(
      name: AppRoutes.ROOMAMPDETAILS,
      page: () => const RoomMapDetailsView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {},
      ),
    ),
  ];
}
