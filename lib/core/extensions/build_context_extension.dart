// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roomrounds/core/extensions/app_theme_extension.dart';

extension BuildContextEntension<T> on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 1024.0 &&
      MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet =>
      MediaQuery.of(this).size.width < 650.0 &&
      MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall =>
      MediaQuery.of(this).size.width < 850.0 &&
      MediaQuery.of(this).size.width >= 560.0;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  double get paddingTop => MediaQuery.of(this).padding.top;

  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  double get paddingDefault => height * 0.02;

  // text styles

  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  TextStyle? get displaySmall =>
      Theme.of(this).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: onPrimary,
          );

  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;

  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: onPrimary,
      );

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium?.copyWith(
        fontSize: 22,
        color: onPrimary,
        fontWeight: FontWeight.w500,
      );

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall?.copyWith(
        fontSize: 20,
        color: onPrimary,
        fontWeight: FontWeight.w500,
      );

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get titleTextStyle => Theme.of(this).appBarTheme.titleTextStyle;

  TextStyle? get bodyExtraSmall => bodySmall?.copyWith(
        fontSize: 10,
        height: 1.6,
        letterSpacing: .5,
        color: onPrimary,
      );

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge?.copyWith(
        color: onPrimary,
      );

  TextStyle? get dividerTextSmall => bodySmall?.copyWith(
        letterSpacing: 0.5,
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        color: onPrimary,
      );

  TextStyle? get dividerTextLarge => bodySmall?.copyWith(
      letterSpacing: 1.5,
      fontWeight: FontWeight.w700,
      fontSize: 13.0,
      color: onPrimary,
      height: 1.23);

  // colors

  ThemeData get theme => Theme.of(this);

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get cardColor => Theme.of(this).cardColor;

  Color get error => Theme.of(this).colorScheme.error;

  Color get onError => Theme.of(this).colorScheme.onError;

  Color get background => Theme.of(this).colorScheme.background;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  // extensions
  Gradient get vertical =>
      Theme.of(this).extension<AppThemeExtension>()!.vertical;

  Gradient get horizontal =>
      Theme.of(this).extension<AppThemeExtension>()!.horizontal;

  Color get extraLightGrey =>
      Theme.of(this).extension<AppThemeExtension>()!.extraLightGrey;

  Color get lightGrey =>
      Theme.of(this).extension<AppThemeExtension>()!.lightGrey;

  Color get orange => Theme.of(this).extension<AppThemeExtension>()!.orange;

  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => Wrap(children: [child]),
    );
  }

  Future<dynamic> showOverlayPopup([bool barrierDismissible = false]) {
    return showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (context) => const AlertDialog(),
    );
  }

  void pop([T? result]) {
    Navigator.of(this).pop(result);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        // backgroundColor: primary,
      ),
    );
  }

  Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: primary,
      textColor: onPrimary,
    );
  }
}

class ExperimentOfContext extends StatelessWidget {
  const ExperimentOfContext({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Experiment Of Context', style: context.titleTextStyle),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: context.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('displayMedium', style: context.displayMedium),
              Text('displaySmall', style: context.displaySmall),
              Text('headlineLarge', style: context.headlineLarge),
              Text('headlineMedium', style: context.headlineMedium),
              Text('titleLarge', style: context.titleLarge),
              Text('titleMedium', style: context.titleMedium),
              Text('titleSmall', style: context.titleSmall),
              Text('labelLarge', style: context.labelLarge),
              Text('bodySmall', style: context.bodySmall),
              Text('titleTextStyle', style: context.titleTextStyle),
              Text('bodyExtraSmall', style: context.bodyExtraSmall),
              Text('bodyLarge', style: context.bodyLarge),
              Text('dividerTextSmall', style: context.dividerTextSmall),
              Text('dividerTextLarge', style: context.dividerTextLarge),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => context.showToast('Toast'),
                child: const Text('Toast'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => context.showSnackBar('SnackBar'),
                child: const Text('Show snack bar'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => context.showBottomSheet(const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Bottom Sheet'))),
                child: const Text('Bottom Sheet'),
              ),
              const SizedBox(height: 8.0),
              Text('width: ${context.width}'),
              Text('height: ${context.height}'),
              Container(
                height: 50.0,
                width: context.width,
                decoration: BoxDecoration(
                  gradient: context.vertical,
                ),
                child: Text('Gradient and height: ${context.height}'),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 50.0,
                width: context.width,
                decoration: BoxDecoration(
                  gradient: context.horizontal,
                ),
                child: Text('Gradient and width: ${context.width}'),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
