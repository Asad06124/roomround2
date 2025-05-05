import 'package:roomrounds/core/components/app_image.dart';
import 'package:roomrounds/core/constants/imports.dart';

class FloorPlanView extends StatelessWidget {
  const FloorPlanView(
      {super.key,
      this.markerPosition,
      this.onMarkerChange,
      this.image,
      this.onDoneTap,
      this.boundaryKey});

  final String? image;
  final GlobalKey? boundaryKey;
  final Offset? markerPosition;
  final void Function(Offset)? onMarkerChange;
  final VoidCallback? onDoneTap;

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle =
        context.titleLarge!.copyWith(color: AppColors.primary);
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        titleStyle: titleTextStyle,
        title: AppStrings.roommapView,
        backButtunColor: AppColors.primary,
        iconsClor: AppColors.primary,
        isHome: false,
        isBackButtun: true,
        showMailIcon: false,
        notificationActive: false,
        showNotificationIcon: false,
        actionWidget: TextButton(
          onPressed: onDoneTap,
          child: Text(AppStrings.done, style: titleTextStyle),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              if (onMarkerChange != null) {
                onMarkerChange!(details.localPosition);
                // Call the function with the new marker position when clicked.
                // You can then update your state and save the new marker position.
                // Example:
                // setState(() {
                //   _markerPosition = details.localPosition;
                // });
              }
            },
            child: RepaintBoundary(
              key: boundaryKey,
              child: Stack(
                children: [
                  InteractiveViewer(
                    constrained: false,
                    child: image != null && image?.trim().isNotEmpty == true
                        ? AppImage.network(
                            imageUrl: image!,
                            width: context.width,
                            height: context.height,
                            fit: BoxFit.fill,
                            errorWidget: (p0, p1, p2) =>
                                _mapPlaceHolderImage(p0),
                          )
                        : _mapPlaceHolderImage(context),
                  ),
                  if (markerPosition != null)
                    Positioned(
                      left: markerPosition!.dx - 20, // Center the marker
                      top: markerPosition!.dy - 60, // Center the marker
                      child: Assets.icons.marker.svg(
                        height: 70,
                      ),
                      // Icon(
                      //   Icons.location_on,
                      //   size: 30,
                      //   color: Colors.red,
                      // ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mapPlaceHolderImage(BuildContext context) {
    return Assets.images.mapImage.svg(
      width: context.width,
      height: context.height,
      fit: BoxFit.cover,
    );
  }
}
