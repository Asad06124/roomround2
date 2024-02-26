import 'package:roomrounds/core/constants/imports.dart';

class MainFeaturesCompinents {
  static Widget mainCards(
    BuildContext context,
    List<String> titles,
    List<SvgGenImage> images,
  ) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of items in each row
        mainAxisSpacing: 50, // spacing between rows
        crossAxisSpacing: 20, // spacing between columns
      ),
      // padding around the grid
      shrinkWrap: true,
      itemCount: 3, // total number of items
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: AppColors.gry,
                    ),
                  ]),
              child: images[index].svg(
                fit: BoxFit.contain,
              ),
            ),
            Text(
              titles[index],
              style: context.titleSmall!.copyWith(color: AppColors.black),
            )
          ],
        );
      },
    );
  }
}
