import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                return Text('${docs?['dayStart']} - ${docs?['dayEnd']}',
                  style: kBigTextStyleWhite,);
              }
          );
        }
    );
  }
}