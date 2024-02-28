/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/appIcon.svg
  SvgGenImage get appIcon => const SvgGenImage('assets/icons/appIcon.svg');

  /// File path: assets/icons/assigned_tasks.svg
  SvgGenImage get assignedTasks =>
      const SvgGenImage('assets/icons/assigned_tasks.svg');

  /// File path: assets/icons/bell.svg
  SvgGenImage get bell => const SvgGenImage('assets/icons/bell.svg');

  /// File path: assets/icons/bell_active.svg
  SvgGenImage get bellActive =>
      const SvgGenImage('assets/icons/bell_active.svg');

  /// File path: assets/icons/camera.svg
  SvgGenImage get camera => const SvgGenImage('assets/icons/camera.svg');

  /// File path: assets/icons/close.svg
  SvgGenImage get close => const SvgGenImage('assets/icons/close.svg');

  /// File path: assets/icons/emplyee_directory.svg
  SvgGenImage get emplyeeDirectory =>
      const SvgGenImage('assets/icons/emplyee_directory.svg');

  /// File path: assets/icons/grid_icon.svg
  SvgGenImage get gridIcon => const SvgGenImage('assets/icons/grid_icon.svg');

  /// File path: assets/icons/home_search.svg
  SvgGenImage get homeSearch =>
      const SvgGenImage('assets/icons/home_search.svg');

  /// File path: assets/icons/list_icon.svg
  SvgGenImage get listIcon => const SvgGenImage('assets/icons/list_icon.svg');

  /// File path: assets/icons/lock.svg
  SvgGenImage get lock => const SvgGenImage('assets/icons/lock.svg');

  /// File path: assets/icons/mail.svg
  SvgGenImage get mail => const SvgGenImage('assets/icons/mail.svg');

  /// File path: assets/icons/person.svg
  SvgGenImage get person => const SvgGenImage('assets/icons/person.svg');

  /// File path: assets/icons/room_map_view.svg
  SvgGenImage get roomMapView =>
      const SvgGenImage('assets/icons/room_map_view.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/splash_logo.svg
  SvgGenImage get splashLogo =>
      const SvgGenImage('assets/icons/splash_logo.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        appIcon,
        assignedTasks,
        bell,
        bellActive,
        camera,
        close,
        emplyeeDirectory,
        gridIcon,
        homeSearch,
        listIcon,
        lock,
        mail,
        person,
        roomMapView,
        search,
        splashLogo
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/home_image.svg
  SvgGenImage get homeImage =>
      const SvgGenImage('assets/images/home_image.svg');

  /// File path: assets/images/login_image.svg
  SvgGenImage get loginImage =>
      const SvgGenImage('assets/images/login_image.svg');

  /// File path: assets/images/mail_box_empty.svg
  SvgGenImage get mailBoxEmpty =>
      const SvgGenImage('assets/images/mail_box_empty.svg');

  /// File path: assets/images/person.png
  AssetGenImage get person => const AssetGenImage('assets/images/person.png');

  /// File path: assets/images/splash_bottom.svg
  SvgGenImage get splashBottom =>
      const SvgGenImage('assets/images/splash_bottom.svg');

  /// List of all assets
  List<dynamic> get values =>
      [homeImage, loginImage, mailBoxEmpty, person, splashBottom];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
