import 'package:flutter/material.dart';
import '../constants.dart';


class BasicContainerWidget extends StatelessWidget {
  const BasicContainerWidget({
    super.key,
    required this.child,
    this.height = 120,
    this.padding = 12,
  });

  final Widget child;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      margin: const EdgeInsets.all(12),
      width: size.width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: kGrey,
          border: Border.all(width: 1, color: kBlue.withOpacity(0.1)),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 6)
            ),
            BoxShadow(
              color: kGrey.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ]
      ),
      child: Center(
        child: child,
      ),
    );
  }
}