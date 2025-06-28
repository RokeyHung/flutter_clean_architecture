import 'package:blueprint/context.dart';
import 'package:flutter/material.dart';

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
    final oemTheme = context.oemTheme;
    final style = this.style ?? oemTheme.textTheme.p12;

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
