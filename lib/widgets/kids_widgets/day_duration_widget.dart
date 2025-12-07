import 'package:flutter/material.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:for_children/widgets/kids_widgets/time_progress_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class DayDurationWidget extends StatelessWidget {
  const DayDurationWidget({
    super.key,
    required this.userStartTime,
    required this.userEndTime,
    required this.docs,
  });

  final String userStartTime;
  final String userEndTime;
  final Map<String, dynamic>? docs;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer2<ParentProvider, KidProvider>(
        builder: (context, data, kidsData, _){
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('P ${docs?['dayStart']} - ${docs?['dayEnd']}', style: kTextStyle,),
                    Text('K $userStartTime - $userEndTime', style: kTextStyle,),
                  ],
                ),
                TimeProgressContainer(
                  startTime: TimeOfDay(
                      hour: int.parse(docs?['dayStart'].split(':')[0]),
                      minute: int.parse(docs?['dayStart'].split(':')[1])),
                  endTime: TimeOfDay(
                      hour: int.parse(docs?['dayEnd'].split(':')[0]),
                      minute: int.parse(docs?['dayEnd'].split(':')[1])),
                  userStartTime: TimeOfDay(
                      hour: int.parse(userStartTime.split(':')[0]),
                      minute: int.parse(userStartTime.split(':')[1])),
                  userEndTime: TimeOfDay(hour: int.parse(userEndTime.split(':')[0]),
                      minute: int.parse(userEndTime.split(':')[1])),
                  containerWidth: size.width - 48,
                ),
              ],
            ),
          );
        }
    );
  }
}