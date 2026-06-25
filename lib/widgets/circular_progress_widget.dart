import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  final int currentValue;
  final int totalValue;
  const CircularProgressWidget({
    super.key,
    this.backgroundColor,
    this.progressColor,
    required this.currentValue,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          color: backgroundColor ?? Utils.circulo1,
          value: 1,
          strokeWidth: 2,
        ),
        CircularProgressIndicator(
          color: progressColor ?? Utils.circulo3,
          value: currentValue / totalValue,
          strokeWidth: 3,
        ),
        Text(
          '${((currentValue / totalValue) * 100).round()}%',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
