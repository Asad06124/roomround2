import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custom_appbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isGradient: false,
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 120,
        showWlcomeMessage: true,
        isHome: true,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // SB.w(context.width),
          // SB.h(50),
          Positioned(
            top: 50,
            child: Assets.images.homeImage.svg(
              height: context.height * 0.30,
            ),
          ),
          Positioned(
            top: context.height * 0.30,
            child: Container(
              width: context.width * 0.90,
              height: context.height * 0.30,
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.appNameSpace,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
