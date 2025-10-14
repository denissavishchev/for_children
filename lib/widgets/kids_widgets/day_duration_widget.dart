import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/widgets/kids_widgets/time_progress_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class DayDurationWidget extends StatelessWidget {
  const DayDurationWidget({
    super.key, required this.email,
  });

  final String email;

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
          return Consumer<ParentProvider>(
              builder: (context, data, _){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${docs?['dayStart']} - ${docs?['dayEnd']}', style: kBigTextKidStyle,),
                    TimeProgressContainer(
                      startTime: TimeOfDay(
                          hour: int.parse(docs?['dayStart'].split(':')[0]),
                          minute: int.parse(docs?['dayStart'].split(':')[1])),
                      endTime: TimeOfDay(
                          hour: int.parse(docs?['dayEnd'].split(':')[0]),
                          minute: int.parse(docs?['dayEnd'].split(':')[1])),
                      userStartTime: TimeOfDay(hour: 9, minute: 0),
                      userEndTime: TimeOfDay(hour: 22, minute: 0),
                      containerWidth: size.width * 0.45,
                    ),
                  ],
                );
              }
          );
        }
    );
  }
}