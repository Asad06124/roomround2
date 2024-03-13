import 'package:roomrounds/core/constants/imports.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileComponents.mainCard(context,
                name: userData.name,
                decs: userData.type == UserType.employee
                    ? "Employee"
                    : "Department Manager"),
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
                  SettingsComponents.tile(context, title: userData.name),
                  SettingsComponents.tile(context, title: "Roye"),
                  SettingsComponents.tile(context, title: "Male"),
                  SettingsComponents.tile(context, title: userData.username),
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
                  Text(
                    AppStrings.logout,
                    style: context.titleSmall!.copyWith(
                      color: AppColors.black,
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
