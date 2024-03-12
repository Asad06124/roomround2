import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/romm_map/controller/room_map_controller.dart';

class RoomMapManagerView extends StatelessWidget {
  const RoomMapManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomMapController>(
        init: RoomMapController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppbar.simpleAppBar(
              context,
              height: 70,
              backButtunColor: AppColors.primary,
              title: AppStrings.mapView,
              notificationActive: true,
              titleStyle:
                  context.titleLarge!.copyWith(color: AppColors.primary),
              iconsClor: AppColors.primary,
              isHome: false,
              showMailIcon: true,
              showNotificationIcon: true,
              isBackButtun: true,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SB.w(context.width),
                    SB.h(10),
                    Text(
                      AppStrings.writeComment,
                      style: context.titleSmall!
                          .copyWith(color: AppColors.textGrey),
                    ),
                    SB.h(10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.lightWhite,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            maxLines: 4,
                            borderRadius: 0,
                            borderColor: AppColors.lightWhite,
                            hintText: AppStrings.writeComment,
                            isRequiredField: false,
                            validator: (value) => null,
                            fillColor: AppColors.lightWhite,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SB.w(10),
                              Assets.icons.cameraCircle.svg(),
                              SB.w(10),
                              Assets.icons.mic.svg(),
                            ],
                          ),
                          SB.h(5),
                        ],
                      ),
                    ),
                    SB.h(20),
                    Text(
                      AppStrings.assignRoom,
                      style: context.titleSmall!
                          .copyWith(color: AppColors.textGrey),
                    ),
                    SB.h(20),
                    Text(
                      AppStrings.member,
                      style: context.titleSmall!
                          .copyWith(color: AppColors.textGrey),
                    ),
                    SB.h(20),
                    Text(
                      AppStrings.urgent,
                      style: context.titleSmall!
                          .copyWith(color: AppColors.textGrey),
                    ),
                    SB.h(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoomMapComponents.radioButtton<YesNo>(
                            context,
                            YesNo.yes,
                            controller.isUrgent,
                            AppStrings.yes, (value) {
                          controller.onUrgentChange(value);
                        }),
                        RoomMapComponents.radioButtton<YesNo>(context, YesNo.no,
                            controller.isUrgent, AppStrings.no, (value) {
                          controller.onUrgentChange(value);
                        }),
                        const SizedBox.shrink()
                      ],
                    ),
                    SB.h(20),
                    AppButton.primary(
                      title: AppStrings.assign,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
