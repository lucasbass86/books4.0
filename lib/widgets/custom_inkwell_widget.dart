import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? splashColor;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.splashColor,
    this.borderRadius = 20,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        splashColor: splashColor ?? Utils.circulo2,
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        onLongPress: onLongPress,
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}
