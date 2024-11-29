import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileComponents.profileHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: GetBuilder<ProfileController>(builder: (controller) {
                User? user = controller.user;
                String? userName = user?.username;
                String? userEmail = user?.email;
                String? userRole = user?.role;
                bool isManager = controller.isManager;

                TextStyle? tileTextStyle = context.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SB.h(25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.personalInformation,
                          style: context.titleMedium!.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.setTextFieldsData();
                            Get.toNamed(AppRoutes.EDIT_PROFILE);
                          },
                          child: Row(
                            children: [
                              Text(
                                AppStrings.edit,
                                style: context.titleMedium!.copyWith(
                                  color: AppColors.deepSkyBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.deepSkyBlue,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SB.h(20),
                    // SB.h(20),
                    SettingsComponents.tile(context,
                        title: userName, isDisabled: true),
                    SettingsComponents.tile(context,
                        title: userRole, isDisabled: true),
                    SettingsComponents.tile(context,
                        title: userEmail, isDisabled: true),
                    SettingsComponents.tile(
                      context,
                      style: tileTextStyle,
                      title: AppStrings.changePassword,
                      onPressed: () => Get.toNamed(
                        AppRoutes.CHANGE_PASSWORD,
                      ),
                    ),
                    if (isManager)
                      SettingsComponents.tile(
                        context,
                        style: tileTextStyle,
                        title: AppStrings.teamMember,
                        onPressed: () => Get.toNamed(
                          AppRoutes.TEAM_MEMBERS,
                          arguments: {"myTeam": true},
                        ),
                      ),
                    SettingsComponents.tile(
                      context,
                      style: tileTextStyle,
                      title: AppStrings.logout,
                      onPressed: controller.showLogoutDialog,
                    ),
                    /*   InkWell(
                        onTap: () => Get.toNamed(
                          AppRoutes.TEAMMEMBERS,
                          arguments: {"myTeam": true},
                        ),
                        child: Text(
                          AppStrings.teamMember,
                          style: context.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SB.h(10),
                      InkWell(
                        onTap: () => profileController.logout(),
                        child: Text(
                          AppStrings.logout,
                          style: context.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ), */
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
