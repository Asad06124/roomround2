import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/dashboard/controller/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
      init: DashBoardController(),
      builder: (controller) {
        return Container(
          decoration: const BoxDecoration(
            gradient: null,
            color: AppColors.white,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: controller.curruntScreen,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: AppColors.lightWhite,
              color: AppColors.primary,
              items: <Widget>[
                Icon(
                  Icons.home,
                  size: 30,
                  color: controller.curruntIndex == 0
                      ? AppColors.primary
                      : AppColors.white,
                ),
                Icon(
                  Icons.settings,
                  size: 30,
                  color: controller.curruntIndex == 1
                      ? AppColors.primary
                      : AppColors.white,
                ),
                Icon(
                  Icons.person,
                  size: 30,
                  color: controller.curruntIndex == 2
                      ? AppColors.primary
                      : AppColors.white,
                ),
              ],
              onTap: controller.buttumButtunClick,
            ),
          ),
        );
      },
    );
  }
}
