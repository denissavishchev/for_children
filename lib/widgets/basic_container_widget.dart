import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/stars_widget.dart';
import 'package:for_children/widgets/status_widget.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class BasicContainerWidget extends StatelessWidget {
  const BasicContainerWidget({
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
                        color: kGrey,
                        border: Border.all(width: 1, color: kBlue.withValues(alpha: 0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 6)
                          ),
                          BoxShadow(
                            color: kGrey.withValues(alpha: 0.2),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data?.docs[index].get(nameOf),
                                style: kBigTextStyle,),
                              Text((snapshot.data!.docs[index].data().containsKey('type')
                                  ? snapshot.data?.docs[index].get('type')
                                  : ''),
                                style: kTextStyle,),
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kBlue.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(4)
                            ),
                          ),
                          child: Text(snapshot.data?.docs[index].get('taskName'),
                            style: kBigTextStyle,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text('taskPrice'.tr(),
                                style: kTextStyle.copyWith(
                                    color: kBlue.withValues(alpha: 0.6)),),
                              Text(snapshot.data?.docs[index].get('price'),
                                style: kTextStyle,),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(3, ((i){
                                  return SvgPicture.asset('assets/icons/pepper.svg',
                                    width: 12,
                                    colorFilter: ColorFilter.mode((2 - i) < (snapshot.data!.docs[index].data().containsKey('expQty')
                                        ? int.parse(snapshot.data?.docs[index].get('expQty'))
                                        : 1)
                                        ? kRed : kGrey, BlendMode.srcIn),
                                  );
                                })),
                              )
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
                        color: kGrey,
                        border: Border.all(width: 1, color: kBlue.withValues(alpha: 0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 6)
                          ),
                          BoxShadow(
                            color: kGrey.withValues(alpha: 0.2),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ]
                    ),
                    child: snapshot.data?.docs[index].get('status') == 'checked' ||
                        snapshot.data?.docs[index].get('status') == 'paid'
                        ? StarsWidget(
                            stars: double.parse(snapshot.data?.docs[index].get('stars')).toInt(),
                            snapshot: snapshot,
                            index: index,)
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(3, (i){
                            return StatusWidget(
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