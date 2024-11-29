import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';

class EditProfileView extends StatelessWidget with Validators {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        child: GetBuilder<ProfileController>(builder: (controller) {
          return Column(
            children: [
              ProfileComponents.profileHeader(context,
                  showBackButton: true, showEditImage: true),
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
                            AppStrings.editProfile,
                            style: context.titleSmall!.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          SB.h(20),
                          CustomTextField(
                            hintText: AppStrings.userName,
                            borderColor: AppColors.darkGrey,
                            prefixIcon: Assets.icons.person.svg(),
                            controller: controller.userNameController,
                            keyboardType: TextInputType.name,
                            validator: validateName,
                          ),
                          SB.h(20),
                          CustomTextField(
                            readOnly: true,
                            hintText: AppStrings.emailAddress,
                            borderColor: AppColors.darkGrey,
                            prefixIcon: Assets.icons.person.svg(),
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          SB.h(40),
                          AppButton.primary(
                            height: 50,
                            width: context.width,
                            title: AppStrings.updateProfile,
                            background: AppColors.primary,
                            onPressed: controller.updateUserName,
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
        }),
      ),
    );
  }
}
