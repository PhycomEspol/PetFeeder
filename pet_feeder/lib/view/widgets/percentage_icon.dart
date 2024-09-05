import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';

class PercentageIcon extends StatelessWidget {
  final double percentage;
  final double size;
  final IconData icon;
  final Color filledColor;
  final Color unfilledColor;
  /// Additional information to display
  /// If not provided, shows the percentage
  final String? info;


  const PercentageIcon({
    super.key,
    required this.percentage,
    required this.size,
    required this.icon,
    required this.filledColor,
    required this.unfilledColor,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GradientIcon(
          icon: icon,
          size: 70,
          gradient: LinearGradient(
            colors: percentage == 100 ? [filledColor] :[
              unfilledColor,
              filledColor,
            ],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            stops: percentage == 100 ? [1] : [1, percentage / 100],
          ),
        ),
        Text(
          info ?? '$percentage%',
          style: const TextStyle(color: Colors.white, fontSize: 8),
        ),
      ],
    );
  }
}
