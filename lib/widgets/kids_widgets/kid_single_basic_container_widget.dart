import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'kid_stars_widget.dart';
import 'kid_status_widget.dart';


class KidSingleBasicContainerWidget extends StatelessWidget {
  const KidSingleBasicContainerWidget({
    super.key,
    this.height = 120,
    required this.snapshot,
    required this.index,
    required this.nameOf,
  });

  final double height;
  final QuerySnapshot<Map<String, dynamic>> snapshot;
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
                            kLightBlue.withValues(alpha: 0.8),
                            kDarkBlue.withValues(alpha: 0.8),
                            kPurple.withValues(alpha: 0.8),
                          ],
                          stops: const [0, 0.5, 1]
                        ),
                        border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.3)),
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                        boxShadow: [
                          BoxShadow(
                              color: kRed.withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(-6, 6)
                          ),
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.docs[index].get(nameOf),
                                style: kBigTextStyleWhite,),
                              Text((snapshot.docs[index].data().containsKey('type')
                                  ? snapshot.docs[index].get('type')
                                  : ''),
                                style: kTextStyleWhite,),
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kOrange.withValues(alpha: 0.8),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(18)
                            ),
                            border: Border.all(width: 1, color: kDarkBlue),
                            boxShadow: [
                              BoxShadow(
                                color: kWhite.withValues(alpha: 0.3),
                                spreadRadius: 2,
                                blurRadius: 2
                              )
                            ]
                          ),
                          child: Text(snapshot.docs[index].get('taskName'),
                            style: kBigTextStyleWhite,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text('taskPrice'.tr(),
                                style: kTextStyle.copyWith(
                                    color: kWhite.withValues(alpha: 0.6)),),
                              Text(snapshot.docs[index].get('price'),
                                style: kTextStyleWhite,),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(3, ((i){
                                  return SvgPicture.asset('assets/icons/pepper.svg',
                                    width: 14,
                                    colorFilter: ColorFilter.mode((2 - i) < (snapshot.docs[index].data().containsKey('expQty')
                                        ? int.parse(snapshot.docs[index].get('expQty'))
                                        : 1)
                                        ? kRed : Colors.transparent, BlendMode.srcIn),
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
                        gradient: LinearGradient(
                            colors: [
                              kPurple.withValues(alpha: 0.8),
                              kDarkBlue.withValues(alpha: 0.8),
                              kBlue.withValues(alpha: 0.8),
                            ],
                            stops: const [0.1, 1, 0.1]
                        ),
                        border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.3)),
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                        boxShadow: [
                          BoxShadow(
                              color: kRed.withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(-4, 6)
                          ),
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 1,
                              spreadRadius: 0.5,
                              offset: const Offset(-0.5, 0.5)
                          ),
                        ]
                    ),
                    child: snapshot.docs[index].get('status') == 'checked' ||
                        snapshot.docs[index].get('status') == 'paid'
                        ? KidStarsWidget(
                            stars: double.parse(snapshot.docs[index].get('stars')).toInt(),
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