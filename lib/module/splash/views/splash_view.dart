import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/splash/controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
              body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SB.w(context.width),
              SB.w(context.width),
              Column(
                children: [
                  Assets.icons.splashLogo.svg(),
                  SB.h(10),
                  Text(
                    AppConstants.appName,
                    style: context.titleMedium!
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
              Opacity(
                opacity: 0.3,
                child: Assets.images.splashBottom.svg(
                  width: context.width,
                  // height: context.height * 0.30,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ));
        });
  }
}
