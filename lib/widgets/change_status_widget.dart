import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class ChangeStatusWidget extends StatelessWidget {
  const ChangeStatusWidget({super.key,
    required this.snapshot,
    required this.index
  });

  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return snapshot.data?.docs[index].get('status') == 'price' &&
              snapshot.data?.docs[index].get('priceStatus') == 'set' &&
              data.role == 'child'
              ? GestureDetector(
            onTap: () => data.priceStatus(snapshot, index, context),
            child: Container(
              width: size.width * 0.2,
              height: 50,
              margin: const EdgeInsets.fromLTRB(12, 0, 0, 4),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(width: 1, color: kBlue.withOpacity(0.8)),
                  gradient: LinearGradient(
                      colors: [
                        kBlue.withOpacity(0.4),
                        kBlue.withOpacity(0.6)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: const Offset(0, 1)
                    ),
                    BoxShadow(
                      color: kGrey.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]
              ),
              child: Center(
                child: Text('changeStatus'.tr(),
                  style: kTextStyleGrey,
                  textAlign: TextAlign.center,),
              ),
            ),
          )
              : const Text('Waiting fo parent');
        });
  }
}
