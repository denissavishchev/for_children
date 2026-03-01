import 'package:flutter/material.dart';

import '../../constants.dart';

class SquareButtonWidget extends StatelessWidget {
  const SquareButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  kOrange,
                  kWhite
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: kWhite, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(2, 2)
              )
            ]
        ),
        child: Icon(icon, size: 32, color: kDarkWhite),
      ),
    );
  }
}