import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class KidStatusWidget extends StatelessWidget {
  const KidStatusWidget({
    super.key,
    required this.snapshot,
    required this.index,
    required this.name,
    this.border = true,
  });

  final QuerySnapshot<Map<String, dynamic>> snapshot;
  final int index;
  final String name;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: border ? Border.all(
            width: 0.5,
            color: snapshot.docs[index].get('status') == name
                ? kWhite : Colors.transparent,) : null
      ),
      child: Text(name.tr(),
        style: snapshot.docs[index].get('status') == name &&
            snapshot.docs[index].get('priceStatus') == 'changed'
            ? kOrangeTextStyle
            : snapshot.docs[index].get('status') == name &&
            snapshot.docs[index].get('priceStatus') == 'set'
            ? kTextStyleWhite
            : kSmallTextStyleWhite,),
    );
  }
}