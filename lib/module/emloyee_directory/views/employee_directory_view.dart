import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/emloyee_directory/controller/employee_directory_controller.dart';

class EmployeeDirectoryView extends StatelessWidget {
  EmployeeDirectoryView({super.key});

  final Debouncer _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    User? user = profileController.user;
    return CustomContainer(
      padding: const EdgeInsets.all(0),
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 140,
        isBackButtun: true,
        titleStyle: context.titleLarge,
        title: AppStrings.roomStatusList,
        isHome: false,
        showMailIcon: true,
        showNotificationIcon: true,
        decriptionWidget: AssignedTaskComponents.appBatTile(
          context,
          name: user?.username,
          desc: user?.role,
          // userData.type == UserType.employee
          //     ? "Employee Staff"
          //     : "Managing Staff",
        ),
      ),
      child: GetBuilder<EmployeeDirectoryController>(
          init: EmployeeDirectoryController(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    // width: context.width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55),
                        topRight: Radius.circular(55),
                      ),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        SB.w(context.width),
                        Text(
                          AppStrings.employeeDirectory,
                          style: context.titleLarge!
                              .copyWith(color: AppColors.black),
                        ),
                        SB.h(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeDropDown.simple(
                              context,
                              list: [
                                AppStrings.allEmployees,
                                AppStrings.allManagers
                              ],
                              onSelect: (String value) {},
                            ),
                            CustomeDropDown.simple(
                              context,
                              list: departmentsController.getDepartmentsNames(),
                              onSelect:
                                  departmentsController.onDepartmentSelect,
                            ),
                          ],
                        ),
                        SB.h(15),
                        CustomTextField(
                          borderRadius: 35,
                          fillColor: AppColors.white,
                          hintText: AppStrings.searchEmployee,
                          controller: controller.searchTextField,
                          textInputAction: TextInputAction.search,
                          isShadow: true,
                          validator: (value) {
                            return null;
                          },
                          suffixIcon: AppImages.search,
                          onSuffixTap: () {
                            // Search
                            controller.onSearch(
                              controller.searchTextField.text,
                            );
                          },
                          onFieldSubmitted: controller.onSearch,
                          onChange: (text) {
                            _debouncer.run(() {
                              controller.onSearch(text);
                            });
                          },
                        ),
                        SB.h(10),
                        Expanded(
                          child: controller.hasData
                              ? _buildEmployeeList(
                                  context, controller.searchResults)
                              : const CustomLoader(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildEmployeeList(BuildContext context, List<Employee> list) {
    if (list.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          Employee employee = list[index];

          return CustomeTiles.employeeTile(
            context,
            name: employee.employeeName,
            desc: employee.departmentName,
          );
        },
      );
    } else {
      // No Employees found
      return Center(
        child: Text(
          AppStrings.noEmployeesFound,
          style: context.bodyLarge!.copyWith(
            color: AppColors.black,
          ),
        ),
      );
    }
  }
}
