import 'dart:developer';

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
        decriptionWidget: CustomAppbar.appBatTile(
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
                SizedBox(
                  height: 10.0,
                ),
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
                              hintText: AppStrings.selectType,
                              list: controller.employeeTypes,
                              initialItem: controller.selectedEmployeeType,
                              onSelect: controller.onChangeEmployeeType,
                            ),
                            CustomeDropDown.simple(
                              context,
                              hintText: AppStrings.selectDepartment,
                              list: departmentsController.getDepartmentsNames(),
                              initialItem:
                                  departmentsController.selectedDepartment ==
                                          null
                                      ? "Department"
                                      : departmentsController
                                          .selectedDepartment?.departmentName
                                          ?.trim(),
                              onSelect: controller.onChangeDepartment,
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
          String imageUrl = (employee.imageKey?.isNotEmpty ?? false)
              ? '${Urls.domain}${employee.imageKey}'
              : AppImages.personPlaceholder;
          Color roleColor = employee.roleName?.toLowerCase() == 'manager'
              ? Color(0xff326FEA)
              : AppColors.darkGrey;
          return CustomeTiles.employeeTile(
            context,
            image: imageUrl,
            title: employee.employeeName,
            subHeading: employee.roleName,
            subtile: employee.departmentName,
            roleColor: roleColor,
            onPressed: () {
              log('Fcm Token For Push Notification: ${employee.fcmToken}');
              Get.toNamed(AppRoutes.CHAT, arguments: {
                'receiverId': employee.userId.toString(),
                'receiverImgUrl': imageUrl,
                'receiverDeviceToken': employee.fcmToken,
                'name': '${employee.firstName}${employee.lastName}',
              });
            },
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
