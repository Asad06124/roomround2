import 'package:roomrounds/core/constants/imports.dart';

import 'package:roomrounds/module/main_features/components/main_features_components.dart';
import 'package:roomrounds/module/main_features/controller/main_feature_controller.dart';

class MainFeaturesView extends StatelessWidget {
  const MainFeaturesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      "Employee directory",
      "Assigned tasks",
      "Room/map view",
    ];
    List<SvgGenImage> images = [
      Assets.icons.emplyeeDirectory,
      Assets.icons.assignedTasks,
      Assets.icons.roomMapView,
    ];

    List<String> pages = [
      AppRoutes.EMPLOYEEDIRECTORy,
      AppRoutes.ASSIGNEDTASKS,
      AppRoutes.ROOMMAP
    ];
    return CustomContainer(
      padding: const EdgeInsets.all(0),
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        // showWlcomeMessage: false,
        title: AppStrings.appNameSpace,
        isHome: true,
      ),
      child: GetBuilder<MainFeatureController>(
          init: MainFeatureController(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    // width: context.width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 50),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55),
                        topRight: Radius.circular(55),
                      ),
                      color: AppColors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Main Features",
                              style: context.titleLarge!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => controller.chnageLayout(true),
                                  child: Assets.icons.gridIcon.svg(
                                      color: controller.isGridView
                                          ? AppColors.primary
                                          : AppColors.gry),
                                ),
                                SB.w(10),
                                InkWell(
                                  onTap: () => controller.chnageLayout(false),
                                  child: Assets.icons.listIcon.svg(
                                      color: !controller.isGridView
                                          ? AppColors.primary
                                          : AppColors.gry),
                                ),
                              ],
                            )
                          ],
                        ),
                        SB.h(50),
                        SizedBox(
                          width: context.width,
                          // height: context.height * 0.55,
                          child: MainFeaturesCompinents.mainCards(
                            context,
                            titles,
                            images,
                            onPressed: (index) => Get.toNamed(pages[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
