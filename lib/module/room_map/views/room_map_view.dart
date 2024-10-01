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
        title: userData.type == UserType.manager
            ? AppStrings.mapView
            : AppStrings.roommapView,
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
              child: CustomeDropDown.custome(context,
                  dropDownItems: getListOfIcons(5)),
            ),
            Container(
              width: 1,
              height: 45,
              color: AppColors.gry.withOpacity(0.24),
            ),
            SizedBox(
              width: context.width * 0.80 - 41,
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
        onTab: () => Get.toNamed(userData.type == UserType.manager
            ? AppRoutes.ROOM_MAP_MANAGER
            : AppRoutes.ROOM_MAP_DETAILS),
      ),
    );
  }

  List<Widget> getListOfIcons(int length) {
    List<Widget> w = <Widget>[];
    for (var i = 0; i < length; i++) {
      w.add(SizedBox(
        width: 20,
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Assets.icons.homeRound.svg(
              width: 20,
              height: 20,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ],
        ),
      ));
    }
    return w;
  }
}
