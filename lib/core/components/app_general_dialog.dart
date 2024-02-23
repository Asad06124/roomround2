import 'package:roomrounds/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Future<bool?> showAppGeneralDialog(
  BuildContext context, {
  required Widget child,
  double width = 700.0,
  double? height,
  Color? backgroundColor,
  bool barrierDismissible = true,
}) {
  height = height ?? context.height;
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (_, __, ___) {
      return SafeArea(
        child: LayoutBuilder(
          builder: (context, state) {
            return Container(
              color: context.width <= width
                  ? (backgroundColor ?? context.scaffoldBackgroundColor)
                  : Colors.transparent,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                height: height,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    padding: context.width <= width
                        ? null
                        : const EdgeInsets.only(top: 100.0, bottom: 100.0),
                    child: ClipRRect(
                      borderRadius: context.width <= width
                          ? BorderRadius.zero
                          : BorderRadius.circular(16.0),
                      child: Material(child: child),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
