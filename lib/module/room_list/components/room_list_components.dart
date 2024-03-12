import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/room_list/controller/room_list_controller.dart';

class RoomListComponents {
  static Widget yesNoWidget(
      BuildContext context, RoomListController controller, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoomMapComponents.radioButtton<YesNo>(
            context,
            YesNo.yes,
            controller.tasks[index],
            AppStrings.yes,
            (value) => controller.chnageTaskStatus(value, index),
            width: 0),
        SB.w(10),
        RoomMapComponents.radioButtton<YesNo>(
            context,
            YesNo.no,
            controller.tasks[index],
            AppStrings.no,
            width: 0,
            (value) => controller.chnageTaskStatus(value, index)),
      ],
    );
  }

  static Widget statusWidget(BuildContext context, {bool isComplete = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isComplete
            ? AppColors.green.withOpacity(0.5)
            : AppColors.yellowLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          isComplete ? "Completed" : "Incomplete",
          style: context.bodyLarge!.copyWith(
            color: isComplete ? AppColors.greenDark : AppColors.yellowDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static Widget filter(BuildContext context, Function(String value) onSelect) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.textPrimary,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.icons.filter.svg(),
          SB.w(15),
          Expanded(
            child: CustomeDropDown.simple<String>(
              context,
              closedFillColor: AppColors.textPrimary,
              expandFillColor: AppColors.textPrimary,
              showShadow: false,
              closedShaddow: false,
              textColor: AppColors.white,
              list: [
                "All Rooms",
                "Completed",
                "Incomplete",
              ],
              onSelect: onSelect,
            ),
          )
        ],
      ),
    );
  }
}
