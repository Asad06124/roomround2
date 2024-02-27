import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/profile/components/profile_components.dart';

class TeamMembersView extends StatelessWidget {
  const TeamMembersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileComponents.mainCard(context, isBackButtun: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.h(25),
                  Text(
                    "Team Members",
                    style: context.titleSmall!.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  SB.h(20),
                  ProfileComponents.teamTile(context, name: "Anthony Roye"),
                  ProfileComponents.teamTile(context, name: "Anthony Roye"),
                  ProfileComponents.teamTile(context, name: "Anthony Roye"),
                  ProfileComponents.teamTile(context, name: "Anthony Roye"),
                  ProfileComponents.teamTile(context, name: "Anthony Roye"),
                  ProfileComponents.teamTile(context, name: "Anthony Roye"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
