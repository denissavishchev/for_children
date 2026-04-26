import 'package:flutter/material.dart';
import '../constants.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final Function() onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  kWhite,
                  kWhite.withValues(alpha: 0.01),
                  kWhite,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topLeft,
                stops: [0.1, 0.8, 1]
            ),
            shape: BoxShape.circle,
            border: Border.all(color: kWhite, width: 1),
            boxShadow: [
              BoxShadow(
                  color: kGrey.withValues(alpha: 0.5),
                  blurRadius: 3,
                  spreadRadius: 1.5,
                  offset: Offset(-0.5, 2)
              ),
            ]
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: kBlue.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}