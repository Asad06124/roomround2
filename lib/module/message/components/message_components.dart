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
}

class DropDownItems {
  String label;
  Widget icon;
  DropDownItems(this.label, this.icon);
}

// ignore: must_be_immutable
class CustomePainterDialouge extends StatelessWidget {
  LayerLink link;
  OverlayPortalController controller;
  GestureTapCallback? onTap;
  Widget child;
  CustomePainterDialouge(
      {Key? key,
      required this.link,
      required this.controller,
      this.onTap,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CompositedTransformTarget(
        link: link,
        child: OverlayPortal(
          controller: controller,
          overlayChildBuilder: (BuildContext context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: onTap,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                ),
                CompositedTransformFollower(
                  link: link,
                  offset: const Offset(-7, -20),
                  targetAnchor: Alignment.topLeft,
                  followerAnchor: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 125,
                    width: 250,
                    child: CustomPaint(
                      size: const Size(250, 125),
                      painter: MessageIconPainter(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Column(
                          children: [
                            Row(children: [
                              Assets.icons.upload.svg(
                                  height: 25, width: 25, fit: BoxFit.cover),
                              SB.w(8),
                              Text(
                                AppStrings.uploadfromDevice,
                                style: context.bodyLarge!.copyWith(
                                  color: AppColors.gry,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                            Divider(
                              color: AppColors.gry.withOpacity(0.24),
                            ),
                            Row(children: [
                              Assets.icons.cameraAlt.svg(
                                  height: 20, width: 25, fit: BoxFit.cover),
                              SB.w(8),
                              Text(
                                AppStrings.takePhoto,
                                style: context.bodyLarge!.copyWith(
                                  color: AppColors.gry,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                            Divider(
                              color: AppColors.gry.withOpacity(0.24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: child,
        ),
      ),
    );
  }
}

class MessageIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(8, 8)
      ..lineTo(size.width - 8, 8)
      ..quadraticBezierTo(size.width, 8, size.width, 16)
      ..lineTo(size.width, size.height - 16)
      ..quadraticBezierTo(
          size.width, size.height - 8, size.width - 8, size.height - 8)
      ..lineTo(8, size.height - 8)
      ..lineTo(28, size.height - 8)
      ..lineTo(20, size.height - 0)
      ..lineTo(12, size.height - 8)
      ..lineTo(8, size.height - 8)
      ..quadraticBezierTo(0, size.height - 8, 0, size.height - 16)
      ..lineTo(0, 16)
      ..quadraticBezierTo(0, 8, 8, 8)
      ..close();
    canvas.drawShadow(path, Colors.black, 10.0, true);
    canvas.translate(2, 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
