import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_clean_architecture/core/extensions/context_extension.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture/widgets/button/rounded_button.dart';
import 'package:flutter_clean_architecture/widgets/button/button_label.dart';

@immutable
class RoundedTextButton extends StatelessWidget {
  const RoundedTextButton({
    super.key,
    this.onTap,
    this.foregroundColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    this.icon,
    this.suffixIcon,
    this.text = '視聴する',
  });

  final GestureTapCallback? onTap;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final Widget? suffixIcon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final appTheme = context.appTheme;
    final foregroundColor =
        this.foregroundColor ?? appTheme.colorScheme.materialsLabel;
    final backgroundColor = this.backgroundColor ?? appTheme.colorScheme.base;

    return RoundedButton(
      onTap: onTap,
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              SizedBox(
                width: 13,
                height: 13,
                child: IconTheme(
                  data: iconTheme.copyWith(color: foregroundColor),
                  child: icon!,
                ),
              ),
            if (icon != null) const Gap(4),
            ButtonLabel(
              text,
              style: appTheme.textTheme.p12.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (suffixIcon != null) const Gap(4),
            if (suffixIcon != null)
              SizedBox(
                width: 13,
                height: 13,
                child: IconTheme(
                  data: iconTheme.copyWith(color: foregroundColor),
                  child: suffixIcon!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
class PlayIcon extends StatelessWidget {
  const PlayIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.play_arrow, size: 13);
  }
}

@immutable
class ChevronRightIcon extends StatelessWidget {
  const ChevronRightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.chevron_right, size: 13);
  }
}
