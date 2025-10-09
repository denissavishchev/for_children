import 'package:flutter/material.dart';
import '../constants.dart';

class TaskSquareWidget extends StatelessWidget {
  const TaskSquareWidget({
    super.key,
    required this.number, this.color = kBlue,
  });

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.035,
      height: size.width * 0.035,
      decoration: BoxDecoration(
        color: number == 0
            ? kBlue.withValues(alpha: 0.1)
            : color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(1, 1))
        ],
        border: Border.all(
            width: 2,
            color: kWhite.withValues(alpha: 0.7)),
      ),
    );
  }
}