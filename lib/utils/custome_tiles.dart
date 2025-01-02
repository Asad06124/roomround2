import 'package:roomrounds/core/components/app_image.dart';
import 'package:roomrounds/core/constants/imports.dart';

class CustomeTiles {
  static Widget employeeTile(
    BuildContext context, {
    String? title,
    String? subtile,
    String? subHeading,
    String? image,
    GestureTapCallback? onPressed,
    GestureTapCallback? onRemoveTap,
    int? notificationCount,
    Color? roleColor,
  }) {
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
                AppImage.network(
                  imageUrl: image ?? AppImages.personPlaceholder,
                  borderRadius: BorderRadius.circular(20),
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
                ),
                // CircleAvatar(
                //   radius: 20,
                //   child: Assets.images.person.image(
                //     height: 40,
                //     width: 40,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                SB.w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.titleSmall!.copyWith(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (subHeading != null &&
                              subHeading.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '($subHeading)',
                                style: context.bodyMedium!.copyWith(
                                  color: roleColor ?? AppColors.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        subtile ?? '',
                        style: context.bodySmall!.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (notificationCount != null && notificationCount != 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary,
                      child: Center(
                        child: Text(
                          notificationCount.toString(),
                          style: context.bodyExtraSmall,
                        ),
                      ),
                    ),
                  ),
                // if (onRemoveTap != null)
                //   InkWell(
                //     onTap: onRemoveTap,
                //     child: Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(35),
                //         border: Border.all(color: AppColors.gry),
                //       ),
                //       child: const Icon(
                //         Icons.remove,
                //         color: AppColors.gry,
                //         size: 16,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
        divider(),
        // Divider(
        //   indent: 0,
        //   endIndent: 0,
        //   color: AppColors.gry.withOpacity(0.3),
        //   thickness: 0.8,
        // ),
      ],
    );
  }

  static Widget notificationTileSimple(BuildContext context,
      {String? title,
      String? description,
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
                Expanded(
                  // width: context.width * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyLarge!.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (description != null && description.isNotEmpty)
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyMedium!.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                SB.w(8),
                // const Spacer(),
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
          divider(),
          // Divider(
          //   indent: 0,
          //   endIndent: 0,
          //   color: AppColors.gry.withOpacity(0.3),
          //   thickness: 0.8,
          // ),
        ],
      ),
    );
  }

  static Widget divider() {
    return Divider(
      indent: 0,
      endIndent: 0,
      color: AppColors.gry.withOpacity(0.3),
      thickness: 0.8,
    );
  }
}
