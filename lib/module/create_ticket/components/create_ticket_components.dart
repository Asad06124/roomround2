import 'package:roomrounds/core/constants/imports.dart';

class CreateTicketComponents {
  static Widget customDropdown(
    BuildContext context, {
    String? title,
    String? hintText,
    String? selectedItem,
    List<String> list = const [],
    required Function(String) onSelect,
    SingleSelectController<String?>? controller,
  }) {
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
              list: list,
              closedShadow: false,
              width: context.width * 0.5,
              initialItem: selectedItem,
              onSelect: onSelect,
              controller: controller,
              hintText: hintText ?? AppStrings.select,
            ),
          ],
        ),
        CustomeTiles.divider(),
        SB.h(5),
      ],
    );
  }
}
