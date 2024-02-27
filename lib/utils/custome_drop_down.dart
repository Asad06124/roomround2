import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:roomrounds/core/constants/imports.dart';

class CustomeDropDown {
  static Widget simple(
    BuildContext context, {
    required List<String> list,
    required Function(String value) onSelect,
    String hintText = "All Emplyees",
    double borderRadius = 5,
    Color closedFillColor = AppColors.white,
    Color expandFillColor = AppColors.white,
    bool showShadow = true,
  }) {
    return SizedBox(
      width: context.width * 0.40,
      child: CustomDropdown<String>(
        hintText: hintText,
        items: list,
        initialItem: list[0],
        onChanged: (value) {
          onSelect(value);
        },
        closedHeaderPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: CustomDropdownDecoration(
            closedSuffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.black,
            ),
            closedFillColor: closedFillColor,
            expandedFillColor: expandFillColor,
            closedBorderRadius: BorderRadius.circular(borderRadius),
            expandedBorderRadius: BorderRadius.circular(borderRadius),
            expandedSuffixIcon: const Icon(
              Icons.arrow_drop_up_outlined,
              color: AppColors.black,
            ),
            expandedShadow: [
              BoxShadow(
                color: AppColors.gry.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
            closedShadow: showShadow
                ? [
                    BoxShadow(
                      color: AppColors.gry.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    )
                  ]
                : []),
      ),
    );
  }
}
