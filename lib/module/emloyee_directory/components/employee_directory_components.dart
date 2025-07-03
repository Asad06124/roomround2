// import 'package:roomrounds/core/constants/imports.dart';
// 
// class EmployeeDirectoryComponents {
//   static Widget tile(BuildContext context,
//       {String? title,
//       String? status,
//       bool showIsActiveDot = false,
//       bool showPrefixDropdown = false,
//       bool titleActive = true,
//       bool isUnderline = true,
//       Color fillColor = AppColors.white,
//       Color statusTextColor = AppColors.black,
//       Widget? trailingWidget,
//       Widget? subtitleWidget,
//       GestureTapCallback? onStatusPressed,
//       GestureTapCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: fillColor,
//           border: Border.all(
//             color: AppColors.gry.withOpacity(0.5),
//           ),
//         ),
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // if (showPrefixDropdown)
//                 //   Container(
//                 //     margin: const EdgeInsets.only(right: 5),
//                 //     child: const Icon(
//                 //       Icons.keyboard_arrow_down_outlined,
//                 //       color: AppColors.gry,
//                 //       size: 20,
//                 //     ),
//                 //   ),
//                 // Expanded(
//                 //   child: Text(
//                 //     title ?? '',
//                 //     maxLines: 2,
//                 //     overflow: TextOverflow.ellipsis,
//                 //     style: context.bodyLarge!.copyWith(
//                 //       color:
//                 //           titleActive ? AppColors.textPrimary : AppColors.gry,
//                 //       fontWeight: FontWeight.w600,
//                 //     ),
//                 //   ),
//                 // ),
//                 Expanded(
//                   child: _ExpandableText(
//                     text: title ?? '',
//                     maxLines: 2,
//                     style: context.bodyLarge!.copyWith(
//                       color:
//                           titleActive ? AppColors.textPrimary : AppColors.gry,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 if (trailingWidget != null) trailingWidget,
//                 if (status != null && status.isNotEmpty)
//                   InkWell(
//                     onTap: onStatusPressed,
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 5),
//                       child: Text(
//                         status,
//                         style: context.bodyLarge!.copyWith(
//                           color: Colors.transparent,
//                           decoration:
//                               isUnderline ? TextDecoration.underline : null,
//                           decorationColor: isUnderline ? statusTextColor : null,
//                           fontWeight: FontWeight.w600,
//                           shadows: [
//                             Shadow(
//                               color: statusTextColor,
//                               offset: Offset(0, isUnderline ? -2 : 0.01),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 // CircleAvatar(
//                 //   radius: 4,
//                 //   backgroundColor:
//                 //       showIsActiveDot ? AppColors.orange : Colors.red,
//                 // ),
//               ],
//             ),
//             if (subtitleWidget != null) subtitleWidget,
//           ],
//         ),
//       ),
//     );
//   }
// }
// 
// class _ExpandableText extends StatefulWidget {
//   final String text;
//   final int maxLines;
//   final TextStyle? style;
// 
//   const _ExpandableText({
//     required this.text,
//     required this.maxLines,
//     this.style,
//   });
// 
//   @override
//   State<_ExpandableText> createState() => _ExpandableTextState();
// }
// 
// class _ExpandableTextState extends State<_ExpandableText> {
//   bool _isExpanded = false;
// 
//   @override
//   Widget build(BuildContext context) {
//     final span = TextSpan(text: widget.text, style: widget.style);
//     final tp = TextPainter(
//       text: span,
//       maxLines: widget.maxLines,
//       textDirection: TextDirection.ltr,
//     )..layout(maxWidth: MediaQuery.of(context).size.width);
// 
//     final isOverflowing = tp.didExceedMaxLines;
// 
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.text,
//           maxLines: _isExpanded ? null : widget.maxLines,
//           overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//           style: widget.style,
//         ),
//         if (isOverflowing)
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//               });
//             },
//             child: Text(
//               _isExpanded ? 'Show less' : 'Show more',
//               style: widget.style?.copyWith(
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w600,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
import 'package:roomrounds/core/constants/imports.dart';

class EmployeeDirectoryComponents {
  static Widget tile(BuildContext context,
      {String? title,
      String? status,
      bool showIsActiveDot = false,
      bool showPrefixDropdown = false,
      bool titleActive = true,
      bool isUnderline = true,
      Color fillColor = AppColors.white,
      Color statusTextColor = AppColors.black,
      Widget? trailingWidget,
      Widget? subtitleWidget,
      GestureTapCallback? onStatusPressed,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: fillColor,
          border: Border.all(
            color: AppColors.gry.withOpacity(0.5),
          ),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ExpandableTextWithGetX(
                    text: title ?? '',
                    maxLines: 2,
                    style: context.bodyLarge!.copyWith(
                      color:
                          titleActive ? AppColors.textPrimary : AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailingWidget != null) trailingWidget,
                if (status != null && status.isNotEmpty)
                  InkWell(
                    onTap: onStatusPressed,
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        status,
                        style: context.bodyLarge!.copyWith(
                          color: Colors.transparent,
                          decoration:
                              isUnderline ? TextDecoration.underline : null,
                          decorationColor: isUnderline ? statusTextColor : null,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: statusTextColor,
                              offset: Offset(0, isUnderline ? -2 : 0.01),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (subtitleWidget != null) subtitleWidget,
          ],
        ),
      ),
    );
  }
}

class ExpandableTextWithGetX extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  ExpandableTextWithGetX({
    super.key,
    required this.text,
    required this.maxLines,
    this.style,
  });

  final ExpandableTextController _controller = ExpandableTextController();

  @override
  Widget build(BuildContext context) {
    final trimmedText = text.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: trimmedText, style: style);
        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor, // Match text scaling
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return InkWell(
                onTap: isOverflowing ? () => _controller.toggle() : null,
                child: Text(
                  trimmedText,
                  maxLines: _controller.isExpanded.value ? null : maxLines,
                  overflow: _controller.isExpanded.value
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: style,
                ),
              );
            }),
            if (isOverflowing && !_controller.isExpanded.value)
              InkWell(
                onTap: () => _controller.toggle(),
                child: Obx(() {
                  return Text(
                    _controller.isExpanded.value ? 'read less' : 'read more',
                    style: style?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  );
                }),
              ),
          ],
        );
      },
    );
  }
}

class ExpandableTextController extends GetxController {
  RxBool isExpanded = false.obs;

  void toggle() {
    isExpanded.value = !isExpanded.value;
  }
}
