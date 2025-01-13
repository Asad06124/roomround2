import 'package:roomrounds/core/constants/imports.dart';

import '../../../core/components/app_image.dart';
import '../controller/chat_controller.dart';

class MessageComponents {
  static Widget detailTile(
    BuildContext context, {
    String title = "Room No 1A",
    String subTitle = "Cleaning Department",
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  context.titleMedium!.copyWith(color: AppColors.textPrimary),
            ),
            Text(
              subTitle,
              style: context.bodyLarge!.copyWith(
                color: AppColors.gry.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: AppColors.gry.withOpacity(0.24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.icons.homeSearch.svg(
                colorFilter:
                    const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                height: 15,
                width: 15,
              ),
              SB.w(10),
              Text(
                'Floor',
                style: context.bodyLarge!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  static Widget messageTile(BuildContext context,
      {String msg =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
      String time = '1:03 PM',
      String date = '11/23/2023',
      bool sender = true,
      String? imageUrl,
      bool? isDelivered,
      bool? isSeen}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            sender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (sender) ...{
            AppImage.network(
              imageUrl:
                  profileController.user?.image ?? AppImages.personPlaceholder,
              borderRadius: BorderRadius.circular(20),
              fit: BoxFit.cover,
              height: 40,
              width: 40,
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
                    bottomLeft: Radius.circular(sender ? 0 : 15),
                    bottomRight: Radius.circular(!sender ? 0 : 15),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      Container(
                        height: context.width * 0.50,
                        width: context.width * 0.60,
                        decoration: BoxDecoration(
                          color: sender
                              ? AppColors.gry.withOpacity(0.24)
                              : AppColors.primary,

                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: Radius.circular( 15),
                            bottomRight: Radius.circular( 15),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Optional placeholder
                            errorWidget: (context, url, error) => Icon(Icons.error), // Optional error widget
                          ),
                        ),
                      ),
                    Text(
                      msg,
                      textAlign: TextAlign.justify,
                      style: context.bodySmall!.copyWith(
                        color:
                            sender ? AppColors.textGrey : AppColors.lightWhite,
                        fontWeight: sender ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    time,
                    style: context.bodySmall!.copyWith(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!sender) ...[
                    // Show different ticks based on message delivery and seen status
                    // if (isDelivered == false) // Not Delivered - Single tick
                    //   Icon(Icons.check, size: 16),
                    // Single tick
                    if (isSeen != true) // Delivered - Double tick
                      Icon(Icons.check_circle_outline, size: 16),
                    // Single tick
                    if (isSeen == true) // Seen - Double Blue tick
                      Icon(Icons.check_circle, color: Colors.blue, size: 16),
                    // Blue tick
                  ],
                ],
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

// ignore: must_be_immutable
class CustomePainterDialouge extends StatefulWidget {
  LayerLink link;
  OverlayPortalController controller;
  GestureTapCallback? onTap;
  Widget child;

  CustomePainterDialouge(
      {super.key,
      required this.link,
      required this.controller,
      this.onTap,
      required this.child});

  @override
  State<CustomePainterDialouge> createState() => _CustomePainterDialougeState();
}

class _CustomePainterDialougeState extends State<CustomePainterDialouge> {
  var chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: CompositedTransformTarget(
        link: widget.link,
        child: OverlayPortal(
          controller: widget.controller,
          overlayChildBuilder: (BuildContext context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: widget.onTap,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                ),
                CompositedTransformFollower(
                  link: widget.link,
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
                            GestureDetector(
                              onTap: () async {
                                await chatController.pickImageFromGallery();
                                chatController.overlayController.toggle();
                              },
                              child: Row(children: [
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
                            ),
                            Divider(
                              color: AppColors.gry.withOpacity(0.24),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Call the pickImage function
                                await chatController.pickImageFromCamera();
                                chatController.overlayController.toggle();
                              },
                              child: Row(children: [
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
                            ),
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
          child: widget.child,
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
