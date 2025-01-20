import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/main_features/components/main_features_components.dart';
import 'package:roomrounds/module/main_features/controller/main_feature_controller.dart';

// ignore: must_be_immutable
class MainFeaturesView extends StatelessWidget {
  const MainFeaturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainFeatureController>(
        init: MainFeatureController(),
        builder: (controller) {
          User? user = profileController.user;
          return CustomContainer(
            padding: const EdgeInsets.all(0),
            appBar: CustomAppbar.simpleAppBar(
              context,
              height: context.height * 0.18,
              title: AppConstants.appNameSpace,
              isBackButtun: false,
              isHome: true,
              decriptionWidget: CustomAppbar.appBatTile(
                context,
                name: user?.username,
                desc: user?.role,
                padding: 0,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    // width: context.width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 40),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(55),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.mainFeature,
                              style: context.titleLarge!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => controller.changeLayout(true),
                                  child: Assets.icons.gridIcon.svg(
                                    colorFilter: ColorFilter.mode(
                                      controller.isGridView
                                          ? AppColors.primary
                                          : AppColors.gry,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                SB.w(10),
                                InkWell(
                                  onTap: () => controller.changeLayout(false),
                                  child: Assets.icons.listIcon.svg(
                                    colorFilter: ColorFilter.mode(
                                      controller.isGridView
                                          ? AppColors.gry
                                          : AppColors.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SB.h(30),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            color: Colors.transparent,
                            width: context.width,
                            // height: context.height * 0.55,
                            child: MainFeaturesComponents.mainCards(
                              context,
                              isGridView: controller.isGridView,
                              features: controller.features,
                              onPressed: (page) {
                                if (page != null) {
                                  Get.toNamed(page);
                                }
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
          );
        });
  }
}
