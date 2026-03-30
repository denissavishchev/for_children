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
  final Map<String, dynamic> snapshot;
  final int index;
  final String nameOf;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container(
            margin: const EdgeInsets.fromLTRB(12, 0,12, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    kLightGrey.withValues(alpha: 0.35),
                    kLightGrey
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              ),
              boxShadow: [
                BoxShadow(
                  color: kGrey.withValues(alpha: 0.1),
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(2, 2)
                )
              ],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    width: size.width,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            kWhite.withValues(alpha: 0.75),
                            kWhite.withValues(alpha: 0.35),
                            kWhite.withValues(alpha: 0.55)
                          ],
                          stops: [0, 0.4, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: kGrey.withValues(alpha: 0.1),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(2, 0)
                        )
                      ],
                      border: Border.all(width: 2,
                          color: kDarkWhite),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 4,
                                children: [
                                  Text('taskFrom'.tr(),
                                    style: kTextStyle,),
                                  Text(snapshot[nameOf],
                                    style: kBigTextStyle,),
                                ],
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Text(('type'.tr()),
                                    style: kTextStyle,),
                                  Text((snapshot['type']),
                                    style: kTextStyle,),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(snapshot['taskName'],
                            style: kBigTextStyle,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text('taskPrice'.tr(),
                                style: kTextStyle.copyWith(
                                    color: kBlue.withValues(alpha: 0.6)),),
                              Text(snapshot['price'],
                                style: kTextStyle,),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(3, ((i){
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: (2 - i) < (snapshot.containsKey('expQty')
                                                  ? int.parse(snapshot['expQty'])
                                                  : 1)
                                                  ? kWhite.withValues(alpha: 0.2) : Colors.transparent,
                                              blurRadius: 2,
                                              spreadRadius: 2
                                          )
                                        ]
                                    ),
                                    child: SvgPicture.asset('assets/icons/pepper.svg',
                                      width: 22,
                                      colorFilter: ColorFilter.mode((2 - i) < int.parse(snapshot['expQty'])
                                          ? kRed : Colors.transparent, BlendMode.srcIn),
                                    ),
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
                const SizedBox(width: 4),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: size.width,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            kWhite.withValues(alpha: 0.75),
                            kLightGrey.withValues(alpha: 0.35),
                            kWhite.withValues(alpha: 0.55)
                          ],
                          stops: [0, 0.4, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: kGrey.withValues(alpha: 0.1),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(-2, 0)
                        )
                      ],
                      border: Border.all(width: 2,
                          color: kDarkWhite),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: snapshot['status'] == 'checked' ||
                        snapshot['status'] == 'paid'
                        ? KidStarsWidget(
                            stars: double.parse(snapshot['stars']).toInt(),
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