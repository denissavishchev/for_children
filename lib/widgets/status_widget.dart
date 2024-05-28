import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
    required this.snapshot,
    required this.index, required this.name,
    this.border = true,
  });

  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int index;
  final String name;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: border ? Border.all(
          width: 0.5,
          color: snapshot.data?.docs[index].get('status') == name
            ? kBlue : Colors.transparent,) : null
      ),
      child: Text(name.tr(),
        style: snapshot.data?.docs[index].get('status') == name
            ? kGreenTextStyle : kSmallTextStyle,),
    );
  }
}