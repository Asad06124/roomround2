import 'package:roomrounds/core/constants/imports.dart';

class SettingsComponents {
  static Widget tile(BuildContext context,
      {String? title, GestureTapCallback? onPressed}) {
    if (title != null && title.isNotEmpty) {
      return GestureDetector(
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.bodyLarge!.copyWith(
                  color: AppColors.textGrey,
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
          ));
    }
    return SizedBox();
  }
}
