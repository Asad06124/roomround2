import 'package:roomrounds/core/constants/imports.dart';

class TeamMembersView extends StatelessWidget {
  const TeamMembersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        child: Column(
          children: [
            ProfileComponents.mainCard(context, isBackButtun: true),
            SizedBox(
              height: context.height * 0.68,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SB.h(25),
                    Text(
                      AppStrings.teamMember,
                      style: context.titleSmall!.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        // height: context.height -
                        //     context.height * 0.30 -
                        //     30 -
                        //     context.paddingTop,
                        child: ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return ProfileComponents.teamTile(
                              context,
                              name: "Anthony Roye",
                              isAdmin: true,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
