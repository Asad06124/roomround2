import 'package:roomrounds/core/constants/imports.dart';

// ignore: must_be_immutable
class CustomContainer extends StatelessWidget {
  Widget? child;
  PreferredSize? appBar;
  bool isGradient;
  CustomContainer({Key? key, this.child, this.appBar, this.isGradient = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      decoration: BoxDecoration(
        gradient: isGradient ? AppColors.gradient : null,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}
