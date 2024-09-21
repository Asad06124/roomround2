import 'package:roomrounds/core/apis/models/user_data/user_model.dart';
import 'package:roomrounds/core/constants/controllers.dart';
import 'package:roomrounds/core/constants/imports.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = profileController.user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileComponents.mainCard(
              context,
              name: user?.username,
              description: user?.role,
              // userData.type == UserType.employee
              //     ? "Employee"
              //     : "Department Manager",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.h(25),
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
                    ],
                  ),
                  SB.h(10),
                  Text(
                    AppStrings.edit,
                    style: context.titleMedium!.copyWith(
                      color: AppColors.deepSkyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(20),
                  SettingsComponents.tile(context, title: user?.username),
                  SettingsComponents.tile(context, title: "Roye"),
                  SettingsComponents.tile(context, title: "Male"),
                  SettingsComponents.tile(context, title: user?.email),
                  SettingsComponents.tile(context, title: "**********"),
                  if (userData.type == UserType.manager)
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.TEAMMEMBERS),
                      child: Text(
                        AppStrings.teamMember,
                        style: context.titleSmall!.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  SB.h(10),
                  InkWell(
                    onTap: () {
                      profileController.logout();
                    },
                    child: Text(
                      AppStrings.logout,
                      style: context.titleSmall!.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
