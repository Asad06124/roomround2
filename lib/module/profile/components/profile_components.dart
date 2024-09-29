import 'package:roomrounds/core/constants/imports.dart';

class ProfileComponents {
  static Widget mainCard(
    BuildContext context, {
    bool isBackButtun = false,
    String title = "Profile",
    String? name,
    String? description,
  }) {
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
              if (isBackButtun) ...{
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                  ),
                ),
                SB.w(20),
              },
              Text(
                title,
                style: context.titleLarge,
              ),
            ],
          ),
          SizedBox(
            height: 100,
            width: 105,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    // child: Image.asset("assets/images/person.png"),
                    child: Assets.images.person.image(
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
              ],
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                Text(
                  name ?? '',
                  style: context.titleMedium,
                ),
                Text(
                  description ?? '',
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
  }

  static Widget teamTile(
    BuildContext context, {
    String? title,
    String? subtitle,
    bool isAdmin = false,
    GestureDetector? onPressed,
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
                        subtitle ,
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
              if (isAdmin) ...{
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: AppColors.gry)),
                    child: const Icon(
                      Icons.remove,
                      color: AppColors.gry,
                      size: 16,
                    ),
                  ),
                ),
              },
            ],
          ),
          SB.h(5),
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
