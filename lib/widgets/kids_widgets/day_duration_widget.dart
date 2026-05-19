import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:for_children/widgets/kids_widgets/time_progress_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

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
    return Consumer<KidProvider>(
        builder: (context, data, _){
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('yourDayStarted'.tr(args: [(userStartTime.split(':').take(2).join(':'))]), style: kTextStyle,),
                    Visibility(
                      visible: !data.isDay,
                        child: Text('andEnded'.tr(args: [(userEndTime.split(':').take(2).join(':'))]), style: kTextStyle,)),
                  ],
                ),
                TimeProgressContainer(
                  startTime: data.parseTime(docs?['dayStart']?.toString()),
                  endTime: data.parseTime(docs?['dayEnd']?.toString()),
                  userStartTime: data.parseTime(userStartTime),
                  userEndTime: data.parseTime(userEndTime),
                  containerWidth: size.width - 48,
                ),
              ],
            ),
          );
        }
    );
  }
}