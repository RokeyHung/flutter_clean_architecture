import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:flutter_clean_architecture/gen/assets.gen.dart' as bp;

class AppIcon extends StatelessWidget {
  AppIcon.blueprint({
    super.key,
    required bp.SvgGenImage icon,
    this.iconSize,
    this.color,
    this.clipBehavior,
    this.fit,
    bool? allowDrawingOutsideViewBox,
  }) : iconProvider = AppIconProvider.blueprint(
          icon,
          allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        );

  AppIcon.asset({
    super.key,
    required String assetName,
    this.iconSize,
    this.color,
    this.clipBehavior,
    this.fit,
    bool? allowDrawingOutsideViewBox,
  }) : iconProvider = assetName.endsWith('.svg')
            ? AppIconProvider.asset(
                assetName,
                allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
              )
            : AppIconProvider.assetRaster(
                assetName,
              );

  const AppIcon.appProvider({
    super.key,
    required this.iconProvider,
    this.iconSize,
    this.color,
    this.clipBehavior,
    this.fit,
  });

  AppIcon({
    super.key,
    required bp.SvgGenImage icon,
    this.iconSize,
    this.color,
    this.clipBehavior,
    this.fit,
  }) : iconProvider = AppIconProvider.blueprint(icon);

  final AppIconProvider iconProvider;
  final Size? iconSize;
  final Color? color;
  final Clip? clipBehavior;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    final iconSize = this.iconSize ?? const Size.square(24);
    final color = this.color ?? iconTheme.color;
    final clipBehavior = this.clipBehavior ?? Clip.hardEdge;
    final fit = this.fit ?? BoxFit.contain;

    return iconProvider.build(
      context,
      width: iconSize.width,
      height: iconSize.height,
      color: color,
      clipBehavior: clipBehavior,
      fit: fit,
    );
  }
}

abstract class AppIconProvider {
  const factory AppIconProvider.blueprint(
    bp.SvgGenImage image, {
    bool? allowDrawingOutsideViewBox,
  }) = _AppBlueprintIconProvider;

  const factory AppIconProvider.asset(
    String assetName, {
    bool? allowDrawingOutsideViewBox,
  }) = _AppSvgIconProvider;

  const factory AppIconProvider.assetRaster(
    String assetName,
  ) = _AppRasterIconProvider;

  @protected
  const AppIconProvider();

  Widget build(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    Clip? clipBehavior,
    BoxFit? fit,
  });
}

class _AppBlueprintIconProvider extends AppIconProvider {
  const _AppBlueprintIconProvider(
    this.image, {
    this.allowDrawingOutsideViewBox,
  });

  final bp.SvgGenImage image;
  final bool? allowDrawingOutsideViewBox;

  @override
  Widget build(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    Clip? clipBehavior,
    BoxFit? fit,
  }) {
    return image.svg(
      width: width,
      height: height,
      clipBehavior: clipBehavior ?? Clip.none,
      fit: fit ?? BoxFit.contain,
      colorFilter:
          color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox ?? false,
    );
  }
}

class _AppSvgIconProvider extends AppIconProvider {
  const _AppSvgIconProvider(
    this.assetName, {
    this.allowDrawingOutsideViewBox,
  });

  final String assetName;
  final bool? allowDrawingOutsideViewBox;

  @override
  Widget build(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    Clip? clipBehavior,
    BoxFit? fit,
  }) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      clipBehavior: clipBehavior ?? Clip.none,
      fit: fit ?? BoxFit.contain,
      colorFilter:
          color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox ?? false,
    );
  }
}

class _AppRasterIconProvider extends AppIconProvider {
  const _AppRasterIconProvider(this.assetName);

  final String assetName;

  @override
  Widget build(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    Clip? clipBehavior,
    BoxFit? fit,
  }) {
    final image = Image.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
    );

    if (color != null && color != Colors.white) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: image,
      );
    }
    return image;
  }
}
