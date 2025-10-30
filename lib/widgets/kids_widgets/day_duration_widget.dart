import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:for_children/widgets/kids_widgets/time_progress_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class DayDurationWidget extends StatelessWidget {
  const DayDurationWidget({
    super.key,
    required this.email,
    required this.userStartTime,
    required this.userEndTime,
  });

  final String email;
  final String userStartTime;
  final String userEndTime;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return CircularProgressIndicator();
          final docs = snapshot.data!.data();
          return Consumer2<ParentProvider, KidProvider>(
              builder: (context, data, kidsData, _){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('P ${docs?['dayStart']} - ${docs?['dayEnd']}', style: kTextKidStyle,),
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
                        containerWidth: size.width - 60 * (kidsData.isDay ? 1.5 : 1),
                        docs: docs,
                      ),
                      Text('K $userStartTime - $userEndTime', style: kTextKidStyle,),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}