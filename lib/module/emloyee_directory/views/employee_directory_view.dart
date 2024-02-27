import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/emloyee_directory/components/employee_directory_components.dart';

class EmployeeDirectoryView extends StatelessWidget {
  const EmployeeDirectoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        backButtunColor: AppColors.primary,
        title: AppStrings.assignedTasks,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
        isHome: false,
        isBackButtun: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "30 Tickets / 20 Closed / 5 Urgent",
              style: context.bodyLarge!.copyWith(
                color: AppColors.gry,
              ),
            ),
            SB.h(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tickets",
                  style: context.titleSmall!.copyWith(
                    color: AppColors.black,
                  ),
                ),
                CustomeDropDown.simple(
                  context,
                  list: ["Assigned Me", "Aslam", "Cheema"],
                  onSelect: (value) {},
                  borderRadius: 20,
                  closedFillColor: AppColors.textGrey.withOpacity(0.1),
                  showShadow: false,
                ),
              ],
            ),
            SizedBox(
              height: context.height * 0.38,
              child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return EmployeeDirectoryComponents.tile(
                    context,
                    isAcvtive: index % 2 == 0,
                  );
                },
              ),
            ),
            SB.h(10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.gry.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Closed Tickets",
                    style: context.titleSmall!.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  SB.h(10),
                  SizedBox(
                    height: context.height * 0.30,
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return EmployeeDirectoryComponents.tile(context,
                            titleActive: false);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
