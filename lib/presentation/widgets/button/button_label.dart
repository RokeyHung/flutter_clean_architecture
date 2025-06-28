import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/extensions/context_extension.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';

@immutable
class ButtonLabel extends StatelessWidget {
  const ButtonLabel(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.center,
    this.padding = const EdgeInsets.only(bottom: 1),
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final style = this.style ?? appTheme.textTheme.p12;

    return Padding(
      padding: padding,
      child: Text(
        text,
        style: style.copyWith(height: 1.0),
        textAlign: textAlign,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      ),
    );
  }
}
