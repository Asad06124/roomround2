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
        notificationActive: false,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
        isHome: false,
        showMailIcon: false,
        showNotificationIcon: false,
        isBackButtun: true,
      ),
      body: Container(
        height: context.height - 75,
        width: context.width,
        color: AppColors.primary.withOpacity(0.1),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(
            left: 20, right: 20, top: context.paddingTop + 65 + 10),
        width: context.width - 40,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.width * 0.20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Assets.icons.homeSearch.svg(
                      // height: 25,
                      // width: 25,
                      ),
                  SB.w(5),
                  const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: AppColors.gry,
                  ),
                  SB.w(5),
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
