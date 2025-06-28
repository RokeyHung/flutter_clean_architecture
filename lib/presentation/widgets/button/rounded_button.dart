import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.onTap,
    this.color,
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final GestureTapCallback? onTap;
  final Color? color;
  final Widget? child;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Theme.of(context).primaryColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
