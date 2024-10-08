import 'package:roomrounds/core/constants/imports.dart';

class CreateTicketComponents {
  static Widget customDropdown(BuildContext context,
      {String? title, required Function(String) onSelect}) {
    TextStyle headingTextStyle =
        context.titleSmall!.copyWith(color: AppColors.black);
    TextStyle bodyTextStyle = context.bodyLarge!.copyWith(color: AppColors.gry);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null) Text(title, style: headingTextStyle),
            CustomeDropDown.simple(
              context,
              closedShadow: false,
              width: context.width * 0.5,
              hintText: AppStrings.selectDepartment,
              list: departmentsController.getDepartmentsNames(),
              onSelect: onSelect,
            ),
          ],
        ),
        CustomeTiles.divider(),
        SB.h(5),
      ],
    );
  }
}
