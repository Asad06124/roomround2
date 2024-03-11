import 'package:roomrounds/core/constants/imports.dart';

import 'package:roomrounds/module/main_features/components/main_features_components.dart';
import 'package:roomrounds/module/main_features/controller/main_feature_controller.dart';

// ignore: must_be_immutable
class MainFeaturesView extends StatelessWidget {
  MainFeaturesView({Key? key}) : super(key: key);
  int userType = 0;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(0),
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 110,
        // showWlcomeMessage: false,
        title: AppStrings.appNameSpace,
        isHome: true,
      ),
      child: GetBuilder<MainFeatureController>(
          init: MainFeatureController(userType),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    // width: context.width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 40),
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
                              AppStrings.mainFeature,
                              style: context.titleLarge!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => controller.chnageLayout(true),
                                  child: Assets.icons.gridIcon.svg(
                                      colorFilter: ColorFilter.mode(
                                          controller.isGridView
                                              ? AppColors.primary
                                              : AppColors.gry,
                                          BlendMode.srcIn)),
                                ),
                                SB.w(10),
                                InkWell(
                                  onTap: () => controller.chnageLayout(false),
                                  child: Assets.icons.listIcon.svg(
                                      colorFilter: ColorFilter.mode(
                                          controller.isGridView
                                              ? AppColors.gry
                                              : AppColors.primary,
                                          BlendMode.srcIn)),
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
                            child: MainFeaturesCompinents.mainCards(
                              context,
                              controller.titles,
                              controller.isGridView,
                              controller.images,
                              onPressed: (index) =>
                                  Get.toNamed(controller.pages[index]),
                            ),
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
