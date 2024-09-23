import 'package:get/get.dart';
import 'package:roomrounds/core/apis/models/feature/main_feature.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MainFeaturesComponents {
  static Widget mainCards(
    BuildContext context, {
    bool isGridView = false,
    List<MainFeature> features = const [],
    required Function(String? page) onPressed,
  }) {
    if (features.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noResultsFound,
          style: context.bodyLarge!.copyWith(color: AppColors.black),
        ),
      );
    }
    return isGridView
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isPhone ? 2 : 3,
              mainAxisSpacing: 0,
              childAspectRatio: 0.75,
              crossAxisSpacing: 20,
            ),
            shrinkWrap: true,
            itemCount: features.length,
            itemBuilder: (context, index) {
              MainFeature feature = features[index];
              return InkWell(
                child: _boxTile(context, feature),
                onTap: () => onPressed(feature.page),
              );
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: features.length,
            itemBuilder: (context, index) {
              MainFeature feature = features[index];
              return InkWell(
                child: _rowTile(context, feature),
                onTap: () => onPressed(feature.page),
              );
            },
          );
  }

  static Widget _rowTile(BuildContext context, MainFeature? feature) {
    if (feature != null) {
      return Container(
        // width: 150,
        margin: const EdgeInsets.only(bottom: 10, left: 0, right: 0, top: 10),
        height: 130,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0.5,
                color: AppColors.gry.withOpacity(0.4),
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (feature.image != null)
              feature.image!.svg(
                fit: BoxFit.cover,
                height: 90,
                width: 90,
              ),
            SB.w(5),
            Text(
              feature.title ?? '',
              style: context.titleSmall!
                  .copyWith(color: AppColors.black, fontSize: 18),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  static Widget _boxTile(BuildContext context, MainFeature? feature) {
    if (feature != null) {
      return Container(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              // height: 130,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: AppColors.gry.withOpacity(0.4),
                  ),
                ],
              ),
              child: feature.image?.svg(
                fit: BoxFit.contain,
                height: 90,
                width: 90,
              ),
            ),
            SB.h(15),
            Text(
              feature.title ?? '',
              maxLines: 2,
              style: context.titleSmall!
                  .copyWith(color: AppColors.black, fontSize: 18),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
