import 'package:roomrounds/core/constants/imports.dart';

class SettingsComponents {
  static Widget tile(BuildContext context,
      {String? title,
      TextStyle? style,
      GestureTapCallback? onPressed,
      bool isDisabled = false}) {
    if (title != null && title.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          // show Divider at bottom
          border: Border(
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: ListTile(
          onTap: onPressed,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Text(title),
          titleTextStyle: style ??
              context.bodyLarge!.copyWith(
                color: isDisabled ? AppColors.gry : AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
      /*  return GestureDetector(
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: style ??
                    context.bodyLarge!.copyWith(
                      color: isDisabled ? AppColors.gry : AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SB.h(2),
              Divider(
                indent: 0,
                endIndent: 0,
                color: AppColors.gry.withOpacity(0.3),
                thickness: 0.8,
              ),
              SB.h(20),
            ],
          )); */
    }
    return SizedBox();
  }

  static Widget noResultsFound(BuildContext context, String? message) {
    return Center(
      child: Text(
        message ?? AppStrings.noResultsFound,
        style: context.bodyLarge!.copyWith(
          color: AppColors.black,
        ),
      ),
    );
  }
}
