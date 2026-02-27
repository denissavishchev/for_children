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
        height: size.width * 0.26,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.transparent,
                kWhite.withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: [0, 0.4, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
          border: Border.all(color: kWhite, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(size.width * 0.13)),
          boxShadow: [
            BoxShadow(
              color: kGrey.withValues(alpha: 0.55),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(-1, 1)
            ),
            BoxShadow(
              color: kDarkWhite.withValues(alpha: 0.15),
            ),
            const BoxShadow(
              color: kWhite,
              spreadRadius: -12.0,
              blurRadius: 20,
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: checked ? Alignment.topCenter : Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size.width * 0.13,
            height: size.width * 0.13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
                border: Border.all(
                    color: checked
                        ? kGrey.withValues(alpha: 0.7)
                        : kWhite.withValues(alpha: 0.8),
                    width: 1),
                boxShadow: [
                  BoxShadow(
                      color: kWhite.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 2)
                  )
                ],
                gradient: LinearGradient(
                    colors: [
                      checked ? kOrange : kGrey,
                      kWhite,
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft
                ),
            ),
            child: Center(
              child: AnimatedCrossFade(
                firstChild: ColorLine(color: kOrange,),
                secondChild: ColorLine(color: kGrey),
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
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kWhite,
              color,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
