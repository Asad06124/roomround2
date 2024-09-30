import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/emloyee_directory/controller/employee_directory_controller.dart';

class TeamMembersView extends StatelessWidget {
  const TeamMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        child: GetBuilder<EmployeeDirectoryController>(
            init: EmployeeDirectoryController(),
            builder: (controller) {
              return Column(
                children: [
                  ProfileComponents.mainCard(context, isBackButtun: true),
                  Expanded(
                    // height: context.height * 0.68,
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
                          SB.h(10),
                          Expanded(
                            // height: context.height -
                            //     context.height * 0.30 -
                            //     30 -
                            //     context.paddingTop,
                            child: controller.hasData
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: controller.searchResults.length,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Employee? employee =
                                          controller.searchResults[index];

                                      return ProfileComponents.teamTile(
                                        context,
                                        title: employee.employeeName,
                                        subtitle: employee.roleName,
                                        onRemoveTap: () {
                                          controller
                                              .showRemoveConfirmationDialog(
                                                  employee);
                                        },
                                      );
                                    },
                                  )
                                : CustomLoader(),
                          ),
                          SB.h(10),
                        ],
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
