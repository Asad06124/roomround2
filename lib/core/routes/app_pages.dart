import 'package:roomrounds/core/constants/imports.dart';

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
        () {
          // Get.lazyPut<OnboardingController>(
          //   () => OnboardingController(),
          // );
        },
      ),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
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
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      transition: transitionType,
      binding: BindingsBuilder(
        () {
          // Get.lazyPut<OnboardingController>(
          //   () => OnboardingController(),
          // );
        },
      ),
    ),
  ];
}
