import 'package:roomrounds/core/constants/app_globals.dart';
import 'package:roomrounds/core/constants/imports.dart';

class AssignedTasksView extends StatelessWidget {
  const AssignedTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          name: userData.type == UserType.employee
              ? "Employee Staff"
              : "Managing Staff",
          desc: userData.name,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              // width: context.width,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    style: context.titleLarge!.copyWith(color: AppColors.black),
                  ),
                  SB.h(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomeDropDown.simple(context,
                          list: ['All Employees', 'All Managers'],
                          onSelect: (String value) {}),
                      CustomeDropDown.simple(context,
                          list: [
                            'Departments',
                            'Nursing, DON',
                            'Administration ',
                            'Nursing, ADON'
                          ],
                          onSelect: (String value) {}),
                    ],
                  ),
                  SB.h(15),
                  CustomTextField(
                    borderRadius: 35,
                    fillColor: AppColors.white,
                    hintText: AppStrings.searchEmployee,
                    isShadow: true,
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: AppImages.search,
                  ),
                  SB.h(10),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: AppGlobals.dummyData.length,
                      itemBuilder: (context, index) {
                        return CustomeTiles.employeeTile(
                          context,
                          name: AppGlobals.dummyData[index].name,
                          desc: AppGlobals.dummyData[index].time,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
