import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ParentButtonWidget extends StatelessWidget {
  const ParentButtonWidget({
    super.key,
    required this.onTap,
    required this.text
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 0.8, color: kBlue),
          color: kWhite,
          boxShadow: [
            BoxShadow(
                color: kBlue.withValues(alpha: 0.3),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2)
            )
          ]
      ),
      child: Center(
        child: Text(text.tr(),
          style: kBigTextStyle,
          textAlign: TextAlign.center,),
      ),
    );
  }
}
