import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';

class HistoryBarWidget extends StatelessWidget {
  const HistoryBarWidget({
    super.key,
    required this.snapshot,
    required this.kidName,
  });

  final QuerySnapshot<Map<String, dynamic>> snapshot;
  final String kidName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(builder: (context, data, _){
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Column(
              spacing: 12,
              children: [
                Container(
                  width: 80,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: const Offset(3, 3)
                        )
                      ]
                  ),
                  child: SizedBox(
                    height: size.height * 0.35,
                    child: Column(
                      children: List.generate(data.taskTypes.length, ((i){
                        return Flexible(
                          flex: data.historyBoxSums(snapshot, i, kidName),
                          child: Container(
                            width: 80,
                            color: data.taskTypes.values.elementAt(i),
                          ),
                        );
                      })),
                    ),
                  ),
                ),
                Text(kidName, style: kTextStyle)
              ],
            ),
            SizedBox(
              height: size.height * 0.35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(8, ((i){
                  return Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kBlue, width: 1),
                          color: data.taskTypes.values.elementAt(i),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: const Offset(3, 3)
                              )
                            ]
                        ),
                      ),
                      Text(data.taskTypes.keys.elementAt(i), style: kTextStyle)
                    ],
                  );
                })),
              ),
            )
          ],
        ),
      );
    });
  }
}