import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/authentications/controller/forget_controller.dart';

class ForgetView extends StatelessWidget with Validators {
  const ForgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: GetBuilder<ForgetController>(
          init: ForgetController(),
          builder: (controller) {
            return Form(
              key: controller.forgetKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SB.h(80),
                    Center(
                      child: Assets.images.loginImage.svg(
                        width: context.width,
                        height: context.height * 0.30,
                      ),
                    ),
                    SB.h(40),
                    Text(
                      'Forget Password?',
                      style: context.displaySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w600),
                    ),
                    SB.h(10),
                    Text(
                      'Enter your email address and we will send you instructions to reset your password.',
                      textAlign: TextAlign.center,
                      style:
                          context.bodyLarge!.copyWith(color: AppColors.white),
                    ),
                    SB.h(25),
                    CustomTextField(
                      hintText: AppStrings.emailAddress,
                      prefixIcon: Assets.icons.email.svg(),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.usernameController,
                      validator: validateEmail,
                    ),
                    SB.h(30),
                    AppButton.primary(
                      title: 'Continue',
                      onPressed: controller.forget,
                    ),
                    SB.h(20),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        'Back to the Platform',
                        textAlign: TextAlign.center,
                        style: context.bodyLarge!.copyWith(
                          color: AppColors.divider,
                        ),
                      ),
                    ),
                    SB.h(25),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
