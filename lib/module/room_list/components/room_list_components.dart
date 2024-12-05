import 'package:roomrounds/core/constants/imports.dart';

class RoomListComponents {
  static Widget yesNoWidget(BuildContext context, YesNo? selectedValue,
      Function(YesNo) onTaskValueChanged) {
    return Container(
      // margin: EdgeInsets.only(top: 15, left: 25),
      margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SB.w(25),
          RoomMapComponents.radioButton<YesNo>(
            context,
            YesNo.yes, // AssignedValue
            selectedValue, // SelectedValue
            AppStrings.yes, // Title
            (value) => onTaskValueChanged(value),
            width: 0,
          ),
          RoomMapComponents.radioButton<YesNo>(
            context,
            YesNo.no, // AssignedValue
            selectedValue, // SelectedValue
            AppStrings.no, // Title
            (value) => onTaskValueChanged(value),
            width: 0,
          ),
          RoomMapComponents.radioButton<YesNo>(
            context,
            YesNo.no,
            selectedValue, // SelectedValue
            AppStrings.na, // Title
            (value) {},
            width: 0,
          ),
        ],
      ),
    );
  }

  static Widget statusWidget(BuildContext context, {bool isComplete = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isComplete
            ? AppColors.green.withOpacity(0.5)
            : AppColors.yellowLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        isComplete ? "Completed" : "Incomplete",
        style: context.bodyLarge!.copyWith(
          color: isComplete ? AppColors.greenDark : AppColors.yellowDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget filter(BuildContext context, Function(String value) onSelect) {
    List<String> list = [
      AppStrings.allRooms,
      AppStrings.inProgress,
      AppStrings.complete,
    ];

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
              showShadow: false,
              closedShadow: false,
              textColor: AppColors.white,
              closedFillColor: AppColors.textPrimary,
              expandFillColor: AppColors.textPrimary,
              list: list,
              onSelect: onSelect,
              initialItem: list.firstOrNull,
            ),
          )
        ],
      ),
    );
  }
}
