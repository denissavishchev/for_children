import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/main_provider.dart';
import 'package:for_children/widgets/status_widget.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'basic_container_widget.dart';

class TilesListWidget extends StatelessWidget {
  const TilesListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<MainProvider>(
        builder: (context, data, _){
          return SizedBox(
              height: size.height * 0.8,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                // .orderBy('', descending: false)
                    .snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index){
                        return BasicContainerWidget(
                          padding: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data?.docs[index].get('kidName'),
                                              style: kBigTextStyle,),
                                            Visibility(
                                              // visible: snapshot.data?.docs[index].get('status') == 'Checked'
                                              //           || snapshot.data?.docs[index].get('status') == 'Paid',
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List.generate(3, (i){
                                                  return Icon(
                                                    Icons.star,
                                                    color: i < int.parse(snapshot.data?.docs[index].get('stars'))
                                                        ? kGreen : kBlue.withOpacity(0.25),);
                                                }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: kBlue.withOpacity(0.1),
                                          borderRadius: const BorderRadius.horizontal(
                                              right: Radius.circular(4)
                                          ),
                                        ),
                                        child: Text(snapshot.data?.docs[index].get('taskName'),
                                          style: kBigTextStyle,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            Text('taskPrice'.tr(),
                                              style: kTextStyle.copyWith(
                                                  color: kBlue.withOpacity(0.6)),),
                                            Text(snapshot.data?.docs[index].get('price'),
                                              style: kTextStyle,),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(5, (i){
                                      return StatusWidget(
                                        snapshot: snapshot,
                                        index: index,
                                        name: data.status[i],);
                                    }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              )
          );
        });
  }
}


