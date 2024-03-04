import 'package:roomrounds/core/constants/imports.dart';

class CustomeTiles {
  static Widget employeeTile(BuildContext context,
      {Widget? image,
      String name = "Anthony Roy",
      String desc = "4:30 PM",
      GestureTapCallback? onPressed,
      int? notificationCount}) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Assets.images.person.image(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SB.w(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.width * 0.65,
                      child: Text(
                        name,
                        maxLines: 1,
                        style: context.bodyLarge!.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      desc,
                      style: context.bodySmall!.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (notificationCount != null && notificationCount != 0) ...{
                  const Spacer(),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: Center(
                      child: Text(
                        notificationCount.toString(),
                        style: context.bodyExtraSmall,
                      ),
                    ),
                  )
                }
              ],
            ),
          ),
        ),
        Divider(
          indent: 0,
          endIndent: 0,
          color: AppColors.gry.withOpacity(0.3),
          thickness: 0.8,
        ),
      ],
    );
  }

  static Widget notificationTileSimple(BuildContext context,
      {String name = "New task added in template",
      GestureTapCallback? onCloseTap,
      GestureTapCallback? onPressed,
      int? notificationCount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.gry.withOpacity(0.2),
                  child: const Icon(
                    Icons.notifications,
                    color: AppColors.black,
                    size: 25,
                  ),
                ),
                SB.w(20),
                SizedBox(
                  width: context.width * 0.65,
                  child: Text(
                    name,
                    maxLines: 2,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onCloseTap,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.gry.withOpacity(0.2),
                    child: const Center(
                        child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.black,
                    )),
                  ),
                )
              ],
            ),
          ),
          SB.h(3),
          Divider(
            indent: 0,
            endIndent: 0,
            color: AppColors.gry.withOpacity(0.3),
            thickness: 0.8,
          ),
        ],
      ),
    );
  }
}
