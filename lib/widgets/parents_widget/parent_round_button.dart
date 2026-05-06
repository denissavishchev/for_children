import 'package:flutter/material.dart';

import '../../constants.dart';

class ParentRoundButton extends StatelessWidget {
  const ParentRoundButton({
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
            color: kWhite,
            shape: BoxShape.circle,
            border: Border.all(color: kBlue, width: 0.8),
            boxShadow: [
              BoxShadow(
                  color: kBlue.withValues(alpha: 0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(2, 4)
              )
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