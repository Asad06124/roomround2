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
        showMailIcon: false,
        showNotificationIcon: false,
        decriptionWidget: AssignedTaskComponents.appBatTile(context),
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
                          list: ['Jalwa', 'Ho ga'],
                          onSelect: (String value) {}),
                      CustomeDropDown.simple(context,
                          list: [
                            'Department 1',
                            'Department 2',
                            'Department 3'
                          ],
                          hintText: "Department",
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
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return CustomeTiles.employeeTile(context);
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
