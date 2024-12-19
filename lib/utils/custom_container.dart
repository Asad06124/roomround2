import 'package:roomrounds/core/constants/imports.dart';

// ignore: must_be_immutable
class CustomContainer extends StatelessWidget {
  Widget? child;
  PreferredSize? appBar;
  bool isGradient;
  EdgeInsetsGeometry padding;
  CustomContainer(
      {super.key,
      this.child,
      this.appBar,
      this.padding = const EdgeInsets.symmetric(horizontal: 20),
      this.isGradient = true});

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
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
