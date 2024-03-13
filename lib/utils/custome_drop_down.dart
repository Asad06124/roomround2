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
    double? width,
  }) {
    width = width ?? context.width * 0.40;
    return SizedBox(
      width: width,
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

  static Widget custome(
    BuildContext context, {
    double? width,
    required List<Widget> dropDownItems,
    int? selectedIndex,
  }) {
    width = width ?? MediaQuery.of(context).size.width * 0.20;
    return SizedBox(
      width: width,
      child: CoolDropdown(
        controller: DropdownController(),
        dropdownList: dropDownItems
            .map((e) => CoolDropdownItem(
                  label: '',
                  value: '',
                  icon: e,
                ))
            .toList(),
        defaultItem: CoolDropdownItem(
          label: '',
          value: '',
          icon: dropDownItems[0],
        ),
        onChange: (dropdownItem) {},
        resultOptions: const ResultOptions(
          padding: EdgeInsets.symmetric(horizontal: 12),
          boxDecoration: BoxDecoration(),
          openBoxDecoration: BoxDecoration(),
          render: ResultRender.icon,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.black,
            size: 20,
          ),
        ),
        dropdownItemOptions: DropdownItemOptions(
          render: DropdownItemRender.icon,
          selectedPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedBoxDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.black.withOpacity(0.7),
                width: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
