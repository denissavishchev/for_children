import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class KidButtonWidget extends StatelessWidget {
  const KidButtonWidget({
    super.key,
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    kWhite,
                    kWhite.withValues(alpha: 0.01),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  stops: [0.1, 1]
              ),
              border: Border.all(color: kWhite, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(size.width * 0.45,)),
              boxShadow: [
                BoxShadow(
                    color: kGrey.withValues(alpha: 0.3),
                    blurRadius: 3,
                    spreadRadius: 1.5,
                    offset: Offset(0, 2)
                ),
              ]
          ),
          child: Center(child: Text(text.tr(), style: kBigTextStyle,)),
        ),
      ),
    );
  }
}