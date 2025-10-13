import 'package:flutter/material.dart';
import 'dart:math';

import 'package:for_children/constants.dart';

class TimeProgressContainer extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double containerWidth;

  const TimeProgressContainer({
    super.key,
    required this.startTime,
    required this.endTime,
    this.containerWidth = 300,
  });

  int _toMinutesOfDay(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final int nowMinutes = _toMinutesOfDay(now);
    final int startMinutes = _toMinutesOfDay(startTime);
    final int endMinutes = _toMinutesOfDay(endTime);
    final int totalDurationMinutes = endMinutes - startMinutes;
    final int elapsedMinutes = nowMinutes - startMinutes;
    double progressRatio;

    if (nowMinutes < startMinutes) {
      progressRatio = 0.0;
    } else if (nowMinutes > endMinutes) {
      progressRatio = 1.0;
    } else {
      progressRatio = elapsedMinutes / totalDurationMinutes;
    }
    progressRatio = max(0.0, min(1.0, progressRatio));

    final double filledWidth = containerWidth * progressRatio;
    return Container(
      width: containerWidth,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: kGrey, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            width: filledWidth,
            height: 20,
            decoration: BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Second child
        ],
      ),
    );
  }
}