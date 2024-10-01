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
                  ProfileComponents.profileHeader(context,
                      showBackButton: true),
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
                                ? _buildMembersList(context, controller)
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

  Widget _buildMembersList(
      BuildContext context, EmployeeDirectoryController controller) {
    List<Employee> members = controller.searchResults;

    if (members.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controller.searchResults.length,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Employee? employee = controller.searchResults[index];

          return ProfileComponents.teamTile(
            context,
            title: employee.employeeName,
            subtitle: employee.roleName,
            onRemoveTap: () {
              controller.showRemoveConfirmationDialog(employee);
            },
          );
        },
      );
    } else {
      // No Team Members found
      return SettingsComponents.noResultsFound(
          context, AppStrings.noMembersFound);
    }
  }
}
