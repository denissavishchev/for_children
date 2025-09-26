import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';

class StarsWidget extends StatelessWidget {
  StarsWidget({super.key,
    required this.stars,
    required this.snapshot,
    required this.index
  });

  final int stars;
  final QuerySnapshot<Map<String, dynamic>> snapshot;
  final int index;

  final shadow = [
    const BoxShadow(
        color: kBlue,
        blurRadius: 9,
        spreadRadius: 6,
        offset: Offset(0.5, 0.5)
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        children: [
          Positioned(
            top: 10,
              left: 0,
              child: Icon(
                stars >= 1
                    ? Icons.star
                    : Icons.star_border,
                color: kGrey,
                size: 40,
                shadows: shadow,
              )),
          Align(
           alignment: Alignment.topCenter,
              child: Icon(
                stars >= 2
                    ? Icons.star
                    : Icons.star_border,
                color: kGrey,
                size: 45,
                shadows: shadow,
              )),
          Positioned(
            top: 10,
              right: 0,
              child: Icon(
                stars >= 3
                    ? Icons.star
                    : Icons.star_border,
                color: kGrey,
                size: 40,
                shadows: shadow,
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text('paid'.tr(),
                style: snapshot.docs[index].get('status') == 'paid'
                ? kGreenTextStyle : kRedTextStyle,)),
        ],
      ),
    );
  }
}
