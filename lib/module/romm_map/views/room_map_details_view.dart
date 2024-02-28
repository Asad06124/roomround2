import 'package:roomrounds/core/components/app_button.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/romm_map/components/room_map_components.dart';

class RoomMapDetailsView extends StatelessWidget {
  const RoomMapDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        backButtunColor: AppColors.primary,
        title: AppStrings.ticketDetails,
        notificationActive: false,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
        isHome: false,
        showMailIcon: false,
        showNotificationIcon: false,
        isBackButtun: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SB.w(context.width),
            RoomMapComponents.tile(context),
            RoomMapComponents.tile(context, title: "Floor", suffixDesc: "3rd"),
            RoomMapComponents.tile(context,
                title: "Manager", suffixDesc: "AnthonyRoy"),
            RoomMapComponents.tile(context,
                title: "Department", suffixDesc: "Department of Nursing, DON"),
            SB.h(10),
            Text(
              "Create Ticket",
              style: context.titleSmall!.copyWith(color: AppColors.black),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.black.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.w(context.width),
                  Text(
                    "Reply",
                    style:
                        context.titleSmall!.copyWith(color: AppColors.textGrey),
                  ),
                  SB.h(10),
                  CustomTextField(
                    maxLines: 8,
                    borderRadius: 8,
                    validator: (value) => null,
                    borderColor: AppColors.gry,
                    hintText: "Write message...",
                  ),
                  SB.h(10),
                  Text(
                    "Urgent",
                    style:
                        context.titleSmall!.copyWith(color: AppColors.textGrey),
                  ),
                  SB.h(10),

                  /// Two Radio button
                  SB.h(10),

                  ///
                  AppButton.primary(
                    title: AppStrings.send,
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
