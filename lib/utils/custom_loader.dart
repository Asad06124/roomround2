import 'package:roomrounds/core/constants/imports.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: context.onPrimary,
        size: 80,
      ),
    );
  }
}
