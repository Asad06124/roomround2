import 'package:get/get.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MainFeaturesCompinents {
  static Widget mainCards(BuildContext context, List<String> titles,
      bool isGridView, List<SvgGenImage> images,
      {required Function(int index) onPressed}) {
    return isGridView
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isPhone ? 2 : 3,
              mainAxisSpacing: 30,
              crossAxisSpacing: 20,
            ),
            shrinkWrap: true,
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => onPressed(index),
                child: _boxTile(context, titles, images, index),
              );
            },
          )
        : ListView.builder(
            itemCount: titles.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _rowTile(context, titles, images, index);
            },
          );
  }

  static Widget _rowTile(BuildContext context, List<String> titles,
      List<SvgGenImage> images, int index) {
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
              spreadRadius: 1,
              color: AppColors.gry.withOpacity(0.4),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          images[index].svg(
            fit: BoxFit.cover,
          ),
          SB.w(5),
          Text(
            titles[index],
            style: context.titleSmall!
                .copyWith(color: AppColors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }

  static Widget _boxTile(BuildContext context, List<String> titles,
      List<SvgGenImage> images, int index) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 150,
            height: 130,
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
                ]),
            child: images[index].svg(
              fit: BoxFit.cover,
            ),
          ),
          Text(
            titles[index],
            style: context.titleSmall!
                .copyWith(color: AppColors.black, fontSize: 18),
          )
        ],
      ),
    );
  }
}
