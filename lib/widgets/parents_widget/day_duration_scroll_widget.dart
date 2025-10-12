import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class DayDurationScrollWidget extends StatelessWidget {
  const DayDurationScrollWidget({
    super.key,
    required this.controller,
    required this.timeValue,
    required this.from,
    required this.to,
  });

  final FixedExtentScrollController controller;
  final String timeValue;
  final int from;
  final int to;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return SizedBox(
            width: 30,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: 60,
                perspective: 0.005,
                diameterRatio: 2.5,
                onSelectedItemChanged: (value) => data.changeTimeValue(value + from, timeValue),
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                    childCount: to - from + 1,
                    builder: (context, index) {
                      final t = from + index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Center(
                          child: Text(
                              t < 10 ? '0$t' : t.toString(),
                              style: kTextStyle),
                        ),
                      );
                    }
                ),
              ),
            ),
          );
        }
    );
  }
}