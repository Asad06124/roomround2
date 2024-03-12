import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:roomrounds/core/constants/imports.dart';

class CustomeDropDown {
  static Widget simple<T>(
    BuildContext context, {
    required List<T> list,
    required Function(T value) onSelect,
    String hintText = "All Emplyees",
    double borderRadius = 5,
    List<String>? labels,
    bool borderRadiusBoth = true,
    Color closedFillColor = AppColors.white,
    Color expandFillColor = AppColors.white,
    Color textColor = AppColors.black,
    bool showShadow = true,
    bool closedShaddow = true,
  }) {
    return SizedBox(
      width: context.width * 0.40,
      child: CustomDropdown<T>(
        hintText: hintText,
        items: list,
        initialItem: list[0],
        onChanged: (value) {
          onSelect(value);
        },
        closedHeaderPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: CustomDropdownDecoration(
            listItemStyle: context.bodySmall!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            headerStyle: context.bodyLarge!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            closedSuffixIcon: Icon(
              Icons.arrow_drop_down,
              color: textColor,
            ),
            closedFillColor: closedFillColor,
            expandedFillColor: expandFillColor,
            closedBorderRadius: BorderRadius.circular(borderRadius),
            expandedBorderRadius:
                BorderRadius.circular(borderRadiusBoth ? borderRadius : 5),
            expandedSuffixIcon: Icon(
              Icons.arrow_drop_up_outlined,
              color: textColor,
            ),
            expandedShadow: showShadow
                ? [
                    BoxShadow(
                      color: AppColors.gry.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
            closedShadow: closedShaddow
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
