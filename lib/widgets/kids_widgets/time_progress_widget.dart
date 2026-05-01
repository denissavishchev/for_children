import 'package:flutter/material.dart';
import 'dart:math';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:provider/provider.dart';

class TimeProgressContainer extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay userStartTime;
  final TimeOfDay userEndTime;
  final double containerWidth;

  const TimeProgressContainer({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.userStartTime,
    required this.userEndTime,
    required this.containerWidth,
  });

  int _toMinutesOfDay(TimeOfDay time) => time.hour * 60 + time.minute;

  @override
  Widget build(BuildContext context) {
    final int nowM = _toMinutesOfDay(TimeOfDay.now());

    final int parentStart = _toMinutesOfDay(startTime);
    final int parentEnd = _toMinutesOfDay(endTime);
    final int kidStart = _toMinutesOfDay(userStartTime);
    final int kidEnd = _toMinutesOfDay(userEndTime);
    final int globalStart = min(parentStart, kidStart);
    final int globalEnd = max(parentEnd, max(kidEnd, nowM));
    final int totalSpan = globalEnd - globalStart;

    if (totalSpan <= 0) return const SizedBox.shrink();

    double pxPerMin = (containerWidth) / totalSpan;

    return Consumer<KidProvider>(
      builder: (context, kidsData, _) {
        return Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKidBar(context, kidStart, kidEnd, nowM, globalStart, pxPerMin),
            _buildParentBar(context, parentStart, parentEnd, globalStart, pxPerMin),
          ],
        );
      },
    );
  }

  Widget _buildParentBar(context, int start, int end, int globalStart, double pxPerMin) {
    double leftOffset = (start - globalStart) * pxPerMin;
    double width = (end - start) * pxPerMin;
    double rightOffset = (containerWidth - (leftOffset + width)) + 2;

    return SizedBox(
      width: containerWidth,
      height: 8,
      child: Stack(
        children: [
          Positioned(
            left: leftOffset,
            child: Container(
              width: width,
              height: 8,
              decoration: BoxDecoration(
                color: kBlue,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            left: leftOffset + 2,
            child: Text(startTime.format(context), style: kSmallTextStyleWhite.copyWith(
              height: 0.9,
              ),
            ),
          ),
          Positioned(
            right: rightOffset,
            child: Text(endTime.format(context), style: kSmallTextStyleWhite.copyWith(
              height: 0.9,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildKidBar(BuildContext context, int start, int end, int now, int globalStart, double pxPerMin) {
    double leftOffset = (start - globalStart) * pxPerMin;

    int effectiveEnd = max(start, now);
    double progressWidth = (effectiveEnd - start) * pxPerMin;

    return SizedBox(
      width: containerWidth,
      height: 12,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: leftOffset,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: progressWidth,
              height: 12,
              padding: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: kOrange,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  if (now > end)
                    BoxShadow(
                      color: kOrange.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                ],
              ),
              child: progressWidth > 45 && now < end
                  ? Align(
                alignment: Alignment.centerRight,
                child: Text(
                  TimeOfDay.now().format(context),
                  style: kSmallTextStyleWhite.copyWith(
                    height: 0.9,
                  ),
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}