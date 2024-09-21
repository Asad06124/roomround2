import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/authentications/controller/login_controller.dart';

class LoginView extends StatelessWidget with Validators {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (controller) {
            return Form(
              key: controller.loginKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SB.h(80),
                    Assets.images.loginImage.svg(
                      width: context.width,
                      height: context.height * 0.30,
                    ),
                    SB.h(40),
                    Text(
                      AppStrings.login,
                      style: context.displaySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w600),
                    ),
                    SB.h(10),
                    Text(
                      AppStrings.enterCredentialToLogin,
                      style:
                          context.bodyLarge!.copyWith(color: AppColors.white),
                    ),
                    SB.h(25),
                    CustomTextField(
                      hintText: AppStrings.userName,
                      prefixIcon: Assets.icons.person.svg(),
                      controller: controller.usernameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    SB.h(20),
                    CustomTextField(
                      hintText: AppStrings.password,
                      prefixIcon: Assets.icons.lock.svg(),
                      controller: controller.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPasswordField: true,
                      validator: validatePassword,
                    ),
                    SB.h(30),
                    AppButton.primary(
                      title: AppStrings.login,
                      onPressed: controller.login,
                    ),
                    SB.h(25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.unableToLogin,
                          style: context.bodyLarge!
                              .copyWith(color: AppColors.white),
                        ),
                        Text(
                          AppStrings.clickHere,
                          style: context.bodyLarge!.copyWith(
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decorationThickness: 2,
                            decorationColor: AppColors.white,
                            shadows: [
                              const Shadow(
                                color: Colors.white,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
