import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final int? initialValue;
  final int maxValue;
  final int currentValue;
  final double width;
  final double height;
  final bool showPercentText;
  final Color backgroundColor;
  final Color progressColor;
  final TextStyle? textStyle;
  final bool showValues;
  final bool showCurrentValue;
  final TextStyle? valueTextStyle;
  final String currentValueText;
  final bool showRestValue;

  const ProgressBarWidget({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.initialValue = 1,
    this.width = double.infinity,
    this.height = 20,
    this.showPercentText = true,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.black,
    this.textStyle = const TextStyle(fontSize: 15),
    this.valueTextStyle = const TextStyle(fontSize: 13),
    this.showCurrentValue = false,
    this.showValues = false,
    this.currentValueText = '',
    this.showRestValue = false,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (currentValue / maxValue).clamp(0.0, 1.0);
    if (currentValue == 0 && maxValue == 0 && percentage == 1) {
      percentage = 0;
    }
    int restValue = maxValue - currentValue;
    Size size = Utils.getTextSize(maxValue.toString(), textStyle ?? const TextStyle(fontSize: 15));
    double mainHeight = height;
    if (size.height > mainHeight) mainHeight = size.height + 5;
    mainHeight += 20;
    if (!showCurrentValue && !showValues) mainHeight -= 20;
    if (showRestValue) mainHeight += 20;
    double progressPosition = mainHeight - (showRestValue ? 40 : 20);
    return SizedBox(
      height: mainHeight,
      child: Stack(
        children: [
          if (showValues)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(initialValue.toString(), style: textStyle),
                Text(maxValue.toString(), style: textStyle),
              ],
            ),
          Positioned(
            // top: mainHeight - 20,
            top: progressPosition,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            // top: mainHeight - 20,
            top: progressPosition,
            child: AnimatedContainer(
              height: height,
              duration: const Duration(milliseconds: 500),
              width: percentage * width,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (showCurrentValue)
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              alignment: Alignment(percentage * 2 - 1, -1), // -1 = arriba
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Text(
                  currentValue.toStringAsFixed(
                          currentValue.truncateToDouble() == currentValue ? 0 : 1) +
                      currentValueText,
                  style: valueTextStyle,
                ),
              ),
            ),
          if (showRestValue)
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              alignment: Alignment(percentage, 1.5), // -1 = arriba
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Text(
                  restValue.toStringAsFixed(restValue.truncateToDouble() == restValue ? 0 : 1),
                  style: valueTextStyle,
                ),
              ),
            ),
          if (showPercentText)
            Positioned(
              // top: mainHeight - 20,
              top: progressPosition - 2,
              right: 0,
              left: 0,
              child: SizedBox(
                height: height,
                child: Center(
                  child: Text(
                    "${(percentage * 100).toStringAsFixed(1)}%",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
