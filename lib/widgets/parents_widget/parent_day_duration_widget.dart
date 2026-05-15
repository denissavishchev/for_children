import 'package:flutter/material.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:for_children/widgets/parents_widget/parent_time_progress_container.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/kid_model.dart';
import '../../providers/parent_provider.dart';

class ParentDayDurationWidget extends StatelessWidget {
  const ParentDayDurationWidget({
    super.key,
    required this.userStartTime,
    required this.userEndTime,
    required this.docs,
    required this.kidsList,
    required this.index,
  });

  final String userStartTime;
  final String userEndTime;
  final Map<String, dynamic>? docs;
  final List<KidModel> kidsList;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer2<ParentProvider, KidProvider>(
        builder: (context, data, kidsData, _){
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 8, 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(kidsList[index].name, style: kTextStyle,),
                ParentTimeProgressContainer(
                  startTime: TimeOfDay(
                      hour: int.parse(docs?['parentStart'].split(':')[0]),
                      minute: int.parse(docs?['parentStart'].split(':')[1])),
                  endTime: TimeOfDay(
                      hour: int.parse(docs?['parentEnd'].split(':')[0]),
                      minute: int.parse(docs?['parentEnd'].split(':')[1])),
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