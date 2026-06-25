import 'dart:math';

import 'package:flutter/material.dart';

extension ShakeExtension on Widget {
  Widget shake({int duration = 800, double offset = 8.0}) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0, end: offset),
      duration: Duration(milliseconds: duration),
      builder: (context, value, child) {
        double val = double.parse(value.toString());
        return Transform.translate(
          offset: Offset(sin(val * pi) * offset, 0),
          child: child,
        );
      },
      child: this,
    );
  }
}
