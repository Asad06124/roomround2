import 'package:roomrounds/core/components/app_image.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/extensions/string_extension.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';

class ProfileComponents {
  static Widget profileHeader(
    BuildContext context, {
    String title = AppStrings.profile,
    bool showBackButton = false,
    bool showEditImage = false,
  }) {
    double imageSize = 100;
    return GetBuilder<ProfileController>(builder: (controller) {
      User? user = controller.user;
      String? userName = user?.username;
      String? userRole = user?.role;
      String? image = user?.image;
      if (image != null && image.trim().isNotEmpty) {
        image = image.completeUrl;
      }

      return Container(
        height: context.height * 0.32,
        width: context.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          gradient: AppColors.profileGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.gry.withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 8,
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: context.paddingTop + 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (showBackButton)
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                Text(
                  title,
                  style: context.titleLarge,
                ),
              ],
            ),
            SizedBox(
              height: imageSize,
              width: imageSize + 5,
              child: Stack(
                children: [
                  Container(
                    height: imageSize,
                    width: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: AppColors.white),
                    ),
                    child: AppImage.network(
                      imageUrl: image ?? AppImages.personPlaceholder,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(50),
                      errorWidget: (p0, p1, p2) {
                        return AppImage.network(
                          imageUrl: AppImages.personPlaceholder,
                        );
                      },
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   child: CircleAvatar(
                  //     radius: 50,
                  //     backgroundColor: Colors.white,
                  //     // child: Image.asset("assets/images/person.png"),
                  //     child: Assets.images.person.image(
                  //       fit: BoxFit.fill,
                  //       height: 100,
                  //       width: 100,
                  //     ),
                  //   ),
                  // ),
                  if (showEditImage)
                    Positioned(
                      bottom: 3,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // AppGlobals.requestPermissions();
                          profileController.updateUserImage(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Assets.icons.cameraAlt.svg(
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    userName ?? '',
                    style: context.titleMedium,
                  ),
                  Text(
                    userRole ?? '',
                    style: context.bodyLarge!
                        .copyWith(color: AppColors.lightWhite.withOpacity(0.7)),
                  ),
                  SB.h(15),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  static Widget teamTile(
    BuildContext context, {
    String? title,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onRemoveTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyLarge!.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyLarge!.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              if (onRemoveTap != null)
                // const Spacer(),
                InkWell(
                  onTap: onRemoveTap,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: AppColors.gry),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: AppColors.gry,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          SB.h(5),
          CustomeTiles.divider(),
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
}
