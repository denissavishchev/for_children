import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import 'day_duration_widget.dart';

class DayNightWidget extends StatelessWidget {
  const DayNightWidget({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<KidProvider>(
        builder: (context, data, _){
          final h = size.height * 0.2;
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(email)
                  .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.data();
                return Container(
                  width: size.width,
                  height: h,
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: data.isDay ? [kLightBlue, kWhite] : [kBlue, kDarkBlue],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Stack(
                    children: [
                      _layer(
                        asset: 'assets/images/d1.png',
                        isVisible: data.isDay,
                        duration: 500,
                        hiddenOffset: h,
                      ),
                      _layer(
                        asset: 'assets/images/d2.png',
                        isVisible: data.isDay,
                        duration: 700,
                        hiddenOffset: h,
                      ),
                      _layer(
                        asset: 'assets/images/d3.png',
                        isVisible: data.isDay,
                        duration: 900,
                        hiddenOffset: h,
                      ),
                      _layer(
                        asset: 'assets/images/n1.png',
                        isVisible: !data.isDay,
                        duration: 500,
                        hiddenOffset: -h,
                      ),
                      _layer(
                        asset: 'assets/images/n2.png',
                        isVisible: !data.isDay,
                        duration: 700,
                        hiddenOffset: -h,
                      ),
                      _layer(
                        asset: 'assets/images/n3.png',
                        isVisible: !data.isDay,
                        duration: 900,
                        hiddenOffset: -h,
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutQuad,
                        top: 4,
                        left: data.isDay
                            ? 12
                            : size.width - 126,
                        width: 90,
                        child: GestureDetector(
                          onLongPress: () => data.switchDay(docs?['dayEnd']),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            transitionBuilder: (child, anim) {
                              return FadeTransition(
                                opacity: anim,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/images/${data.isDay ? 'sun' : 'moon'}.png',
                              key: ValueKey(data.isDay),
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: size.width - 24,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: kGrey.withValues(alpha: 0.3)
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: DayDurationWidget(
                            userStartTime: data.startDayTime,
                            userEndTime: data.endDateTime,
                            docs: docs,),
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}

Widget _layer({
  required String asset,
  required bool isVisible,
  required int duration,
  required double hiddenOffset,
}) {
  return AnimatedPositioned(
    duration: Duration(milliseconds: duration),
    curve: Curves.easeInOut,
    top: isVisible ? 0 : hiddenOffset,
    left: 0,
    right: 0,
    bottom: 0,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
      opacity: isVisible ? 1 : 0,
      child: Image.asset(
        asset,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

