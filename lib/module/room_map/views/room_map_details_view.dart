import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/room_map/controller/room_map_controller.dart';

class RoomMapDetailsView extends StatelessWidget {
  const RoomMapDetailsView({Key? key}) : super(key: key);

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
              title: AppStrings.ticketDetails,
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
                    RoomMapComponents.tile(context),
                    RoomMapComponents.tile(context,
                        title: "Floor", suffixDesc: "3rd"),
                    RoomMapComponents.tile(context,
                        title: "Manager", suffixDesc: "AnthonyRoy"),
                    RoomMapComponents.tile(context,
                        title: "Department",
                        suffixDesc: "Department of Nursing, DON"),
                    SB.h(10),
                    Text(
                      AppStrings.createTicket,
                      style:
                          context.titleSmall!.copyWith(color: AppColors.black),
                    ),
                    SB.h(10),
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
                            AppStrings.reply,
                            style: context.titleSmall!
                                .copyWith(color: AppColors.textGrey),
                          ),
                          SB.h(10),
                          CustomTextField(
                            maxLines: 8,
                            borderRadius: 8,
                            validator: (value) => null,
                            borderColor: AppColors.gry,
                            hintText: AppStrings.writeMessage,
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
                              RoomMapComponents.radioButton<YesNo>(
                                  context,
                                  YesNo.yes,
                                  controller.isUrgent,
                                  AppStrings.yes, (value) {
                                controller.onUrgentChange(value);
                              }),
                              RoomMapComponents.radioButton<YesNo>(
                                  context,
                                  YesNo.no,
                                  controller.isUrgent,
                                  AppStrings.no, (value) {
                                controller.onUrgentChange(value);
                              }),
                              const SizedBox.shrink()
                            ],
                          ),
                          SB.h(20),
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
            ),
          );
        });
  }
}
