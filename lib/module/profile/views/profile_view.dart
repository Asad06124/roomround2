import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/profile/components/profile_components.dart';
import 'package:roomrounds/module/settings/components/settings_components.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileComponents.mainCard(
              context,
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
                        "Personal Information",
                        style: context.titleSmall!.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        "Edit",
                        style: context.titleSmall!.copyWith(
                          color: AppColors.deepSkyBlue,
                        ),
                      ),
                    ],
                  ),
                  SB.h(20),
                  SettingsComponents.tile(context, title: "Anthony"),
                  SettingsComponents.tile(context, title: "Roye"),
                  SettingsComponents.tile(context, title: "Male"),
                  SettingsComponents.tile(context, title: "jgkwru@gmail.com"),
                  SettingsComponents.tile(context, title: "**********"),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.TEAMMEMBERS),
                    child: Text(
                      "Team Members",
                      style: context.titleSmall!.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SB.h(10),
                  Text(
                    "Logout",
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
