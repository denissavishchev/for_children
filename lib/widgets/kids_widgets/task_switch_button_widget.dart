import 'package:flutter/material.dart';
import '../../constants.dart';

class TaskSwitchButtonWidget extends StatelessWidget {
  const TaskSwitchButtonWidget({
    super.key,
    required this.onTap,
    required this.checked,
  });

  final VoidCallback onTap;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.13,
        height: size.width * 0.18,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: kWhite.withValues(alpha: 0.7), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: kWhite.withValues(alpha: 0.3),
            ),
            const BoxShadow(
              color: kWhite,
              spreadRadius: -4.0,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: checked ? Alignment.topCenter : Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size.width * 0.12,
            height: size.width * 0.08,
            decoration: BoxDecoration(
                border: Border.all(
                    color: checked
                        ? kOrange.withValues(alpha: 0.8)
                        : kWhite.withValues(alpha: 0.8),
                    width: 1),
                boxShadow: [
                  BoxShadow(
                      color: kWhite.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 2)
                  )
                ],
                gradient: LinearGradient(
                    colors: [
                      kWhite,
                      kGrey
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8))
            ),
            child: Center(
              child: AnimatedCrossFade(
                firstChild: ColorLine(color: kOrange,),
                secondChild: ColorLine(color: kWhite),
                crossFadeState: checked ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorLine extends StatelessWidget {
  const ColorLine({
    super.key, 
    required this.color,
  });
  
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: kWhite, width: 1),
      ),
    );
  }
}
