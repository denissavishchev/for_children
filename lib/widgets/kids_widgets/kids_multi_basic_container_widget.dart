import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/providers/parent_provider.dart';
import 'package:for_children/widgets/kids_widgets/task_switch_button_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../task_square_widget.dart';
import 'kid_stars_widget.dart';
import 'kid_status_widget.dart';

class KidsMultiBasicContainerWidget extends StatelessWidget {
  const KidsMultiBasicContainerWidget({
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
    List<int> counts = [0, 0, 0, 0];
    for (var n in snapshot.docs[index].get('daysNumber')) {
      counts[n] += 1;
    }
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return Container(
            margin: const EdgeInsets.fromLTRB(12, 3, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: size.width,
            height: height,
            decoration: BoxDecoration(
                color: kWhite.withValues(alpha: 0.5),
                border: Border.all(width: 2, color: kDarkBlue),
                borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.docs[index].get('taskName'),
                              style: kBigTextStyle,),
                            Text(snapshot.docs[index].get(nameOf),
                              style: kTextStyle,),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.46,
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: List.generate(
                                snapshot.docs[index].get('daysNumber').length, (i) {
                                int number = snapshot.docs[index].get('daysNumber')[i];
                                return TaskSquareWidget(number: number, color: kOrange,);
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text('taskPrice'.tr(),
                              style: kTextStyle.copyWith(
                                  color: kBlue.withValues(alpha: 0.6)),),
                            Text(snapshot.docs[index].get('price'),
                              style: kTextStyle,),
                            Spacer(),
                            Text('taskType'.tr(),
                              style: kTextStyle.copyWith(
                                  color: kBlue.withValues(alpha: 0.6)),),
                            Text(snapshot.docs[index].get('type'),
                              style: kTextStyle,),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(5, ((i){
                                return SvgPicture.asset('assets/icons/pepper.svg',
                                  width: 14,
                                  colorFilter: ColorFilter.mode((4 - i) < (snapshot.docs[index].data().containsKey('expQty')
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
                Expanded(
                  flex: 1,
                    child: snapshot.docs[index].get('status') == 'checked' ||
                        snapshot.docs[index].get('status') == 'paid'
                        ? KidStarsWidget(
                      stars: double.parse(snapshot.docs[index].get('stars')).toInt(),
                      snapshot: snapshot,
                      index: index,)
                        : snapshot.docs[index].get('status') == 'inProgress'
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('inProgress'.tr(), style: kTextStyle),
                        TaskSwitchButtonWidget(
                          onTap: () {
                            data.switchTodayTask(data.whatDayIs(snapshot.docs[index].get('time')), snapshot.docs[index].id.toString());
                            if(snapshot.docs[index].get('status') == 'inProgress'
                                && snapshot.docs[index].get('daysNumber').length <= data.whatDayIs(snapshot.docs[index].get('time')) + 1){
                              data.changeToDone(snapshot, index, context, false, false);
                            }
                          },
                          checked: snapshot.docs[index].get('daysNumber')[data.whatDayIs(snapshot.docs[index].get('time'))] == 1,)
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (i){
                        return KidStatusWidget(
                          snapshot: snapshot,
                          index: index,
                          name: data.status[i],);
                      }),
                    ),
                )
              ],
            ),
          );
        });
  }
}