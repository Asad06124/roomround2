import 'package:roomrounds/core/constants/imports.dart';

class RoomMapView extends StatelessWidget {
  const RoomMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 60,
        backButtunColor: AppColors.primary,
        title: AppStrings.roommapView,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
        isHome: false,
        showMailIcon: true,
        showNotificationIcon: true,
        isBackButtun: true,
      ),
      body: Container(
        height: context.height - 75,
        width: context.width,
        color: AppColors.primary.withOpacity(0.1),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              width: context.width,
              height: context.height - context.height * 0.15,
              child: Assets.images.mapImage.svg(
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: (context.height - context.height * 0.15 - 100) / 2,
              child: Assets.icons.locationPinDrop.svg(),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(
            left: 20, right: 20, top: context.paddingTop + 65 + 10),
        width: context.width - 40,
        height: 60,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: const [
              BoxShadow(
                color: AppColors.gry,
                offset: Offset(0, 0),
                spreadRadius: 0.5,
                blurRadius: 10,
              )
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.width * 0.20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SB.w(0),
                  SB.w(0),
                  Assets.icons.homeSearch.svg(
                      // height: 25,
                      // width: 25,
                      ),
                  const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: AppColors.gry,
                  ),
                  Container(
                    width: 0.5,
                    height: 50,
                    color: AppColors.gry.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: context.width * 0.80 - 40,
              child: CustomTextField(
                hintText: AppStrings.searchRoom,
                suffixIcon: AppImages.close,
                sufficIconBackgroundColor: AppColors.white,
                borderRadius: 35,
                validator: (value) => null,
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      bottomSheet: RoomMapComponents.bottomSheet(
        context,
        onTab: () => Get.toNamed(AppRoutes.ROOMAMPDETAILS),
      ),
    );
  }
}
