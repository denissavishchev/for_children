import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';

class HistoryTilesListWidget extends StatelessWidget {
  const HistoryTilesListWidget({super.key, required this.snapshot});

  final QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return SizedBox(
              height: size.height * 0.4,
              child: ListView.builder(
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index){
                    if(snapshot.docs[index].get('parentEmail').toLowerCase() == data.email){
                      return GestureDetector(
                        onTap: () => data.historyDescription(context,
                            snapshot.docs[index].get('price'),
                            snapshot.docs[index].get('description'),
                            snapshot, index),
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            width: size.width,
                            height: 60,
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                            decoration: BoxDecoration(
                                color: kGrey,
                                border: Border.all(width: 1, color: kBlue.withValues(alpha: 0.2)),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 6)
                                  ),
                                  BoxShadow(
                                    color: kGrey.withValues(alpha: 0.2),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                  ),
                                ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data.role == 'parent'
                                    ? snapshot.docs[index].get('kidName')
                                    : snapshot.docs[index].get('parentName'), style: kTextStyle,),
                                Text(snapshot.docs[index].get('taskName'), style: kTextStyle,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(5, ((i){
                                    return SvgPicture.asset('assets/icons/pepper.svg',
                                      width: 12,
                                      colorFilter: ColorFilter.mode((4 - i) < (snapshot.docs[index].data().containsKey('expQty')
                                          ? int.parse(snapshot.docs[index].get('expQty'))
                                          : 1)
                                          ? kRed : kGrey, BlendMode.srcIn),
                                    );
                                  })),
                                ),
                                Text(snapshot.docs[index].data().containsKey('type')
                                    ? snapshot.docs[index].get('type')
                                    : 'home', style: kTextStyle,),
                                Text(snapshot.docs[index].data().containsKey('daysNumber')
                                    ? 'M'
                                    : 'S', style: kTextStyle,),
                                SizedBox(
                                  width: 85,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 10,
                                          left: 0,
                                          child: Icon(
                                            double.parse(snapshot.docs[index].get('stars')).toInt() >= 1
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: kGrey,
                                            size: 40,
                                            shadows: const [
                                              BoxShadow(
                                                  color: kBlue,
                                                  blurRadius: 9,
                                                  spreadRadius: 6,
                                                  offset: Offset(0.5, 0.5)
                                              )
                                            ],
                                          )),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: Icon(
                                            double.parse(snapshot.docs[index].get('stars')).toInt() >= 2
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: kGrey,
                                            size: 45,
                                            shadows: const [
                                              BoxShadow(
                                                  color: kBlue,
                                                  blurRadius: 9,
                                                  spreadRadius: 6,
                                                  offset: Offset(0.5, 0.5)
                                              )
                                            ],
                                          )),
                                      Positioned(
                                          top: 10,
                                          right: 0,
                                          child: Icon(
                                            double.parse(snapshot.docs[index].get('stars')).toInt() >= 3
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: kGrey,
                                            size: 40,
                                            shadows: const [
                                              BoxShadow(
                                                  color: kBlue,
                                                  blurRadius: 9,
                                                  spreadRadius: 6,
                                                  offset: Offset(0.5, 0.5)
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
          );
        });
  }
}
