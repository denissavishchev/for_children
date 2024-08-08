import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'kid_stars_widget.dart';
import 'kid_status_widget.dart';


class KidBasicContainerWidget extends StatelessWidget {
  const KidBasicContainerWidget({
    super.key,
    this.height = 120,
    required this.snapshot,
    required this.index,
    required this.nameOf,
  });

  final double height;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int index;
  final String nameOf;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 3, 3, 12),
                    width: size.width,
                    height: height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            kLightBlue.withOpacity(0.8),
                            kDarkBlue.withOpacity(0.8),
                            kPurple.withOpacity(0.8),
                          ],
                          stops: const [0, 0.5, 1]
                        ),
                        border: Border.all(width: 1, color: kOrange.withOpacity(0.3)),
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                        boxShadow: [
                          BoxShadow(
                              color: kRed.withOpacity(0.6),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(-6, 6)
                          ),
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 0.5,
                              offset: const Offset(-0.5, 0.5)
                          ),
                        ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data?.docs[index].get(nameOf),
                                style: kBigTextStyleWhite,),
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kOrange.withOpacity(0.8),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(18)
                            ),
                            border: Border.all(width: 1, color: kDarkBlue),
                            boxShadow: [
                              BoxShadow(
                                color: kWhite.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2
                              )
                            ]
                          ),
                          child: Text(snapshot.data?.docs[index].get('taskName'),
                            style: kBigTextStyleWhite,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Row(
                            children: [
                              Text('taskPrice'.tr(),
                                style: kTextStyle.copyWith(
                                    color: kWhite.withOpacity(0.6)),),
                              Text(snapshot.data?.docs[index].get('price'),
                                style: kTextStyleWhite,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(3, 0, 12, 12),
                    width: size.width,
                    height: height,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              kPurple.withOpacity(0.8),
                              kDarkBlue.withOpacity(0.8),
                              kBlue.withOpacity(0.8),
                            ],
                            stops: const [0.1, 1, 0.1]
                        ),
                        border: Border.all(width: 1, color: kOrange.withOpacity(0.3)),
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                        boxShadow: [
                          BoxShadow(
                              color: kRed.withOpacity(0.6),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(-4, 6)
                          ),
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 0.5,
                              offset: const Offset(-0.5, 0.5)
                          ),
                        ]
                    ),
                    child: snapshot.data?.docs[index].get('status') == 'checked' ||
                        snapshot.data?.docs[index].get('status') == 'paid'
                        ? KidStarsWidget(
                      stars: double.parse(snapshot.data?.docs[index].get('stars')).toInt(),
                      snapshot: snapshot,
                      index: index,)
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (i){
                        return KidStatusWidget(
                          snapshot: snapshot,
                          index: index,
                          name: data.status[i],);
                      }),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}