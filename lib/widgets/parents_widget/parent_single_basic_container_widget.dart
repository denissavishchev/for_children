import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/stars_widget.dart';
import 'package:for_children/widgets/status_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class ParentSingleBasicContainerWidget extends StatelessWidget {
  const ParentSingleBasicContainerWidget({
    super.key,
    this.height = 124,
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 3, 3, 0),
                    width: size.width,
                    height: height,
                    decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(width: 1, color: kGrey.withValues(alpha: 0.3)),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                              color: kBlue.withValues(alpha: 0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 6)
                          ),
                        ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 4,
                                children: [
                                  Image.asset('assets/images/person.png', width: 12,),
                                  Text(snapshot[nameOf], style: kBigTextStyle,),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Image.asset('assets/images/medal.png', width: 18,),
                              const SizedBox(width: 4),
                              Text(snapshot['price'], style: kBigTextStyle,),
                              const SizedBox(width: 4),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(3, ((i){
                                  return SvgPicture.asset('assets/icons/pepper.svg',
                                    width: 12,
                                    colorFilter: ColorFilter.mode((2 - i) < (snapshot.containsKey('expQty')
                                        ? int.parse(snapshot['expQty'])
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
                    margin: const EdgeInsets.fromLTRB(3, 3, 12, 0),
                    width: size.width,
                    height: height,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(width: 1, color: kGrey.withValues(alpha: 0.3)),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                              color: kBlue.withValues(alpha: 0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 6)
                          ),
                        ]
                    ),
                    child: snapshot['status'] == 'checked' ||
                        snapshot['status'] == 'paid'
                        ? StarsWidget(
                            stars: double.parse(snapshot['stars']).toInt(),
                            snapshot: snapshot,
                            index: index,)
                        : StatusWidget(snapshot: snapshot)
                      ),
                    )
                  ],
                ),
              );
            });
  }
}