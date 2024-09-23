import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/extensions/datetime_extension.dart';

class AssignedTaskComponents {
  static Widget appBatTile(BuildContext context,
      {String? name, String? desc, double padding = 15}) {
    String? Date = DateTime.now().format();
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SB.h(10),
              Text(
                name ?? '',
                style: context.titleMedium,
              ),
              Text(
                desc ?? '',
                style: context.bodyLarge!
                    .copyWith(color: AppColors.lightWhite.withOpacity(0.7)),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Center(
              child: Text(
                Date,
                style: context.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
