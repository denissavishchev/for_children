import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/stars_widget.dart';
import 'package:for_children/widgets/status_widget.dart';
import 'package:for_children/widgets/task_square_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class ParentMultiBasicContainerWidget extends StatelessWidget {
  const  ParentMultiBasicContainerWidget({
    super.key,
    this.height = 144,
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
    List<int> counts = [0, 0, 0, 0];
    for (var n in snapshot['daysNumber']) {
      counts[n] += 1;
    }
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
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Row(
                            spacing: 4,
                            children: [
                              Image.asset('assets/images/todo.png', width: 16,),
                              Text(snapshot['taskName'], style: kBigTextStyle,),
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: kBlue.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                              width: size.width * 0.46,
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: List.generate(
                                    snapshot['daysNumber'].length, (i) {
                                    int number = snapshot['daysNumber'][i];
                                    return TaskSquareWidget(number: number);
                                  },
                                  ),
                                ),
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          TaskSquareWidget(number: 0),
                                          Text('-', style: kTextStyle,),
                                          Text(counts[0].toString(), style: kTextStyle,),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          TaskSquareWidget(number: 1),
                                          Text('-', style: kTextStyle,),
                                          Text(counts[1].toString(), style: kTextStyle,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/images/medal.png', width: 14,),
                                  const SizedBox(width: 4),
                                  Text(snapshot['price'], style: kBigTextStyle,),
                                  const SizedBox(width: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: List.generate(5, ((i) {
                                      final int expQty = snapshot.containsKey('expQty')
                                          ? int.parse(snapshot['expQty'].toString())
                                          : 1;
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: i < expQty
                                                      ? kWhite.withValues(alpha: 0.2)
                                                      : Colors.transparent,
                                                  blurRadius: 2,
                                                  spreadRadius: 2
                                              )
                                            ]
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/pepper.svg',
                                          width: 14,
                                          colorFilter: ColorFilter.mode(
                                              i < expQty ? kRed : Colors.transparent,
                                              BlendMode.srcIn
                                          ),
                                        ),
                                      );
                                    })),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Image.asset('assets/images/person.png', width: 14,),
                                  Text(snapshot[nameOf], style: kTextKidStyle,),
                                ],
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
                    child: snapshot['status'] == 'checked' || snapshot['status'] == 'paid'
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
