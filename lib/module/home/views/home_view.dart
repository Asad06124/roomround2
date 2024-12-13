import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    notificationsController =
        Get.put(NotificationController(), permanent: true);
    _navigateToDashboard();
  }

  void _navigateToDashboard() async {
    await Future.delayed(Duration(seconds: 2));
    Get.offAllNamed(AppRoutes.DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 120,
        showWlcomeMessage: true,
        notificationActive: false,
        isHome: true,
        // title: userData.name,
        title: profileController.user?.username,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // SB.w(context.width),
          // SB.h(50),
          Positioned(
            top: 30,
            child: Assets.images.homeImage.svg(
              height: context.height * 0.30,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: context.height * 0.30,
            width: context.width,
            child: Container(
              width: context.width,
              height: context.height * 0.23,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(33),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]),
              child: InkWell(
                onTap: () => Get.offAllNamed(AppRoutes.DASHBOARD),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppConstants.appNameSpace,
                        style: context.displaySmall!.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SB.h(10),
                      Text(
                        AppStrings.keepUpDataWithSatausOf,
                        style: context.titleSmall!.copyWith(
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
