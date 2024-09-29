import 'package:roomrounds/core/constants/imports.dart';

class RoomMapComponents {
  static Widget bottomSheet(BuildContext context, {GestureTapCallback? onTab}) {
    return Container(
      height: context.height * 0.15,
      width: context.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.gry.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 10,
              offset: const Offset(1, 0))
        ],
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details",
                style: context.titleMedium!.copyWith(
                    color: AppColors.gry, fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Text(
                    "Room 6H",
                    style: context.titleMedium!.copyWith(
                        color: AppColors.black, fontWeight: FontWeight.w500),
                  ),
                  SB.w(10),
                  Text(
                    "3rd Floor",
                    style: context.titleSmall!.copyWith(
                        color: AppColors.gry, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: onTab,
            borderRadius: BorderRadius.circular(35),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.gry.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2))
                  ],
                  borderRadius: BorderRadius.circular(35)),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget tile(BuildContext context,
      {String title = "Room No", String suffixDesc = "6H"}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: context.titleSmall!.copyWith(color: AppColors.black),
              ),
              Text(
                suffixDesc,
                style: context.bodyLarge!.copyWith(color: AppColors.gry),
              ),
            ],
          ),
          SB.h(5),
          Divider(
            color: AppColors.gry.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  static Widget boxTile(
    BuildContext context, {
    String title = "Room No",
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.gry,
          )),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.titleSmall!.copyWith(color: AppColors.gry),
          ),
        ],
      ),
    );
  }

  static Widget radioButton<T>(BuildContext context, T assignedVal,
      T? selectedVal, String title, Function(T value)? onSelect,
      {double? width}) {
    width ?? context.width * 0.5 - 30;
    return InkWell(
      onTap: onSelect != null ? () => onSelect(assignedVal) : null,
      child: SizedBox(
        width: width == 0 ? null : width,
        child: Row(
          children: [
            CircleAvatar(
              radius: 6.5,
              backgroundColor: assignedVal == selectedVal
                  ? AppColors.primary
                  : AppColors.gry,
            ),
            SB.w(5),
            Text(
              title,
              style: context.bodyLarge!.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                // fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
