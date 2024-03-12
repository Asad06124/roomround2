import 'package:roomrounds/core/constants/imports.dart';

class AssignedTaskComponents {
  static Widget appBatTile(BuildContext context,
      {String name = "Robert Brown",
      String desc = "Staff / Employee",
      String date = "11/23/2023",
      EdgeInsets? pading}) {
    return Padding(
      padding: pading ?? const EdgeInsets.only(left: 15),
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
                name,
                style: context.titleMedium,
              ),
              Text(
                desc,
                style: context.bodyLarge!
                    .copyWith(color: AppColors.lightWhite.withOpacity(0.7)),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Center(
              child: Text(
                date,
                style: context.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
