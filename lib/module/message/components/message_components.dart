import 'package:roomrounds/core/constants/imports.dart';

class MessageComponents {
  static Widget detailTile(
    BuildContext context, {
    String title = "Room No 1A",
    String subTitle = "Cleaning Department",
  }) {
    List<DropDownItems> dropdownList = [
      DropDownItems("Floor", Assets.icons.homeSearch.svg()),
      DropDownItems("Roof", Assets.icons.homeSearch.svg())
    ];
    return Row(
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
              title,
              style:
                  context.titleMedium!.copyWith(color: AppColors.textPrimary),
            ),
            Text(
              subTitle,
              style: context.bodyLarge!
                  .copyWith(color: AppColors.gry.withOpacity(0.7)),
            ),
          ],
        ),
        CustomeDropDown.simple(
          context,
          list: dropdownList.map((e) => e.label).toList(),
          onSelect: (value) {},
          showShadow: false,
          borderRadius: 35,
          borderRadiusBoth: false,
          closedFillColor: AppColors.gry.withOpacity(0.24),
        ),
      ],
    );
  }

  static Widget messageTile(
    BuildContext context, {
    String msg =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
    String time = '1:03 PM',
    String date = '11/23/2023',
    bool sender = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            sender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (sender) ...{
            CircleAvatar(
              child: Assets.images.person.image(height: 40, width: 40),
            ),
            SB.w(5),
          },
          Column(
            crossAxisAlignment:
                sender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Container(
                width: context.width * 0.60,
                decoration: BoxDecoration(
                  color: sender
                      ? AppColors.gry.withOpacity(0.24)
                      : AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: Radius.circular(sender ? 0 : 10),
                    bottomRight: Radius.circular(!sender ? 0 : 15),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  msg,
                  textAlign: TextAlign.justify,
                  style: context.bodySmall!.copyWith(
                    color: sender ? AppColors.textGrey : AppColors.lightWhite,
                    fontWeight: sender ? FontWeight.w600 : null,
                  ),
                ),
              ),
              Text(
                time,
                style: context.bodySmall!.copyWith(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          if (!sender) ...{
            SB.w(5),
            CircleAvatar(
              child: Assets.images.person.image(height: 40, width: 40),
            ),
          },
        ],
      ),
    );
  }

  static Widget popMenue(BuildContext context, Function(int type) onTap) {
    return PopupMenuButton(
        icon: Assets.icons.add.svg(),
        onSelected: (value) {
          onTap(value);
        },
        offset: const Offset(10, -120),
        shadowColor: AppColors.gry,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              onTap: () => onTap(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Assets.icons.upload
                        .svg(height: 25, width: 25, fit: BoxFit.cover),
                    SB.w(8),
                    Text(
                      AppStrings.uploadfromDevice,
                      style: context.bodyLarge!.copyWith(color: AppColors.gry),
                    ),
                  ]),
                  Divider(
                    color: AppColors.gry.withOpacity(0.24),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => onTap(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Assets.icons.cameraAlt
                          .svg(height: 20, width: 25, fit: BoxFit.cover),
                      SB.w(8),
                      Text(
                        AppStrings.takePhoto,
                        style:
                            context.bodyLarge!.copyWith(color: AppColors.gry),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.gry.withOpacity(0.24),
                  )
                ],
              ),
            ),
          ];
        });
  }
}

class DropDownItems {
  String label;
  Widget icon;
  DropDownItems(this.label, this.icon);
}
