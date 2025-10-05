import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';

class HistoryBarWidget extends StatelessWidget {
  const HistoryBarWidget({
    super.key, required this.snapshot,
  });

  final QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    List<Color> colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange, Colors.purple, Colors.pink, Colors.brown];
    return Consumer<ParentProvider>(builder: (context, data, _){
      return SizedBox(
        height: size.height * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                child: Column(
                  children: List.generate(8, ((i){
                    return Flexible(
                      flex: data.historyBoxSizes(snapshot, i),
                      child: Container(
                        width: 80,
                        color: colors[i],
                      ),
                    );
                  })),
                ),
              ),
              Column(
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
                          color: colors[i],
                        ),
                      ),
                      Text(data.taskTypes[i], style: kTextStyle)
                    ],
                  );
                })),
              )
            ],
          ),
        ),
      );
    });
  }
}