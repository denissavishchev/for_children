import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';

class HistoryTilesListWidget extends StatelessWidget {
  const HistoryTilesListWidget({super.key, required this.snapshot});

  final List<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ParentProvider>(
        builder: (context, data, _){
          return SizedBox(
              height: size.height * 0.4,
              child: ListView.builder(
                  itemCount: snapshot.length,
                  itemBuilder: (context, index){
                    final history = snapshot[index];
                    if(history['parentEmail'].toLowerCase() == data.email){
                      return GestureDetector(
                        onTap: () => data.historyDescription(context,
                            history['price'],
                            history['description'],
                            history, index),
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            width: size.width,
                            height: 60,
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                            decoration: BoxDecoration(
                                color: kWhite,
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
                                    ? history['kidName']
                                    : history['parentName'], style: kTextStyle,),
                                Text(history['taskName'], style: kTextStyle,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(5, ((i){
                                    return SvgPicture.asset('assets/icons/pepper.svg',
                                      width: 12,
                                      colorFilter: ColorFilter.mode((4 - i) < int.parse(history['expQty'])
                                          ? kRed : kWhite, BlendMode.srcIn),
                                    );
                                  })),
                                ),
                                Text(history['type'],
                                  style: kTextStyle.copyWith(color: data.taskTypes[history['type']]),),
                                Text(history['daysNumber'] != null
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
                                            double.parse(history['stars']).toInt() >= 1
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: kWhite,
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
                                            double.parse(history['stars']).toInt() >= 2
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: kWhite,
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
                                            double.parse(history['stars']).toInt() >= 3
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: kWhite,
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
