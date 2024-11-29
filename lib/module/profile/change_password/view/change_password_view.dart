import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/profile/change_password/controller/change_password_controller.dart';

class ChangePasswordView extends StatelessWidget with Validators {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        // height: context.height,
        child: GetBuilder<ChangePasswordController>(
          init: ChangePasswordController(),
          builder: (controller) {
            return Column(
              children: [
                ProfileComponents.profileHeader(context, showBackButton: true),
                Expanded(
                  // height: context.height * 0.68,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SB.h(25),
                            Text(
                              AppStrings.changePassword,
                              style: context.titleSmall!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            SB.h(20),
                            CustomTextField(
                              isPasswordField: true,
                              hintText: AppStrings.oldPassword,
                              borderColor: AppColors.darkGrey,
                              prefixIcon: Assets.icons.lock.svg(),
                              controller: controller.oldPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: validatePassword,
                            ),
                            SB.h(20),
                            CustomTextField(
                              isPasswordField: true,
                              hintText: AppStrings.newPassword,
                              borderColor: AppColors.darkGrey,
                              prefixIcon: Assets.icons.lock.svg(),
                              controller: controller.newPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: validatePassword,
                            ),
                            SB.h(20),
                            CustomTextField(
                              isPasswordField: true,
                              hintText: AppStrings.confirmNewPassword,
                              borderColor: AppColors.darkGrey,
                              prefixIcon: Assets.icons.lock.svg(),
                              controller: controller.confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) => validateConfirmPassword(
                                  value, controller.newPasswordController.text),
                            ),
                            SB.h(40),
                            AppButton.primary(
                              height: 50,
                              width: context.width,
                              title: AppStrings.updatePassword,
                              background: AppColors.primary,
                              onPressed: controller.onChangePassword,
                            ),
                            SB.h(10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
