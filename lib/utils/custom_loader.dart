import 'package:roomrounds/core/constants/imports.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key, this.isDialog = false});

  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: isDialog ? AppColors.white : AppColors.primary,
        // color: context.onPrimary,
        size: 80,
      ),
    );
  }
}
