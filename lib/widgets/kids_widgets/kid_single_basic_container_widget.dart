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
                    kLightGrey.withValues(alpha: 0.05),
                    kLightGrey.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              ),
              boxShadow: [
                BoxShadow(
                    color: kDarkBlue.withValues(alpha: 0.1),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(-2, 2)
                ),
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
                                  Image.asset('assets/images/person.png', width: 12,),
                                  Text(snapshot[nameOf], style: kTextStyle,),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: kDarkWhite.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlue.withValues(alpha: 0.2),
                                        blurRadius: 1,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.5, 0.5)
                                    )
                                  ]
                                ),
                                child: Text((snapshot['type']),
                                  style: kTextStyle,),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: kWhite.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/todo.png', width: 18,),
                              Expanded(
                                child: Text(
                                  snapshot['taskName'],
                                  style: kBigTextStyle,
                                ),
                              ),
                              snapshot['imageUrl'] == 'false'
                                  ? const SizedBox.shrink()
                                  : Container(
                                    height: 40,
                                    width: 40,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              kWhite.withValues(alpha: 0.4),
                                              kDarkWhite.withValues(alpha: 0.5),
                                              kWhite.withValues(alpha: 0.4),
                                            ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                              offset: const Offset(2, 2)
                                          )
                                        ]
                                    ),
                                    child: Image.network(snapshot['imageUrl'], fit: BoxFit.cover),
                                  )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              Image.asset('assets/images/medal.png', width: 18,),
                              const SizedBox(width: 4),
                              Text(snapshot['price'], style: kBigTextStyle,),
                              const SizedBox(width: 4),
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
                                      width: 16,
                                      colorFilter: ColorFilter.mode((2 - i) < int.parse(snapshot['expQty'])
                                          ? kRed : Colors.transparent, BlendMode.srcIn),
                                    ),
                                  );
                                })),
                              ),
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
                              : KidStatusWidget(snapshot: snapshot),
                  ),
                )
              ],
            ),
          );
        });
  }
}