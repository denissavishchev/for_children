import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import '../../providers/parent_provider.dart';
import '../../screens/kid_screens/days_duration_screen.dart';
import '../round_button.dart';
import 'day_duration_widget.dart';

class DayNightWidget extends StatefulWidget {
  const DayNightWidget({
    super.key,
  });

  @override
  State<DayNightWidget> createState() => _DayNightWidgetState();
}

class _DayNightWidgetState extends State<DayNightWidget> {

  Timer? timer;

  @override
  void initState() {
    final data = Provider.of<KidProvider>(context, listen: false);
    data.updateTimer();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        data.updateTimer();
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer2<KidProvider, ParentProvider>(
        builder: (context, data, parentData, _){
          final h = size.height * 0.2;
          return StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from('users')
                  .stream(primaryKey: ['id'])
                  .eq('email', parentData.email.toString())
                  .order('time', ascending: false),
              builder: (context, snapshot){
                if(!snapshot.hasData) {
                  return SpinKitSpinningLines(
                  color: kBlue,
                  size: 40,
                );
                }
                final docs = snapshot.data!.first;
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
                  ),
                  child: Stack(
                    alignment: Alignment.center,
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
                          onLongPress: () => data.switchDay(context, docs['dayEnd']),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            transitionBuilder: (child, anim) {
                              return FadeTransition(
                                opacity: anim,
                                child: child,
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/${data.isDay ? 'sun' : 'moon'}.png',
                                  key: ValueKey(data.isDay),
                                  width: 100,
                                ),
                                Visibility(
                                  visible: data.isDay,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(data.dayDuration.substring(0, 2),
                                        style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.5))
                                            ),
                                            child: Text(data.dayDuration.substring(6, 7),
                                              style: kTextStyleOrange.copyWith(height: 1),),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1, color: kOrange.withValues(alpha: 0.5))
                                            ),
                                            child: Text(data.dayDuration.substring(7, 8),
                                              style: kTextStyleOrange.copyWith(height: 1),),
                                          ),
                                        ],
                                      ),
                                      Text(data.dayDuration.substring(3, 5),
                                          style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.height * 0.03,
                        child: Container(
                          width: size.width - 24,
                          decoration: BoxDecoration(
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                    color: kGrey.withValues(alpha: 0.5),
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    offset: const Offset(1, 3)
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: DayDurationWidget(
                            userStartTime: data.startDayTime,
                            userEndTime: data.endDateTime,
                            docs: docs,),
                        ),
                      ),
                      Positioned(
                        top: 4,
                          right: data.isDay ? 12 : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                              boxShadow: [
                                BoxShadow(
                                  color: kWhite.withValues(alpha: 0.5),
                                  blurRadius: 3,
                                  spreadRadius: 3,
                                )
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              child: Text(
                                data.isDay
                                    ? 'helloName'.tr(args: [docs['name']])
                                    : 'goodNightName'.tr(args: [docs['name']]),
                                key: ValueKey<bool>(data.isDay),
                                style: kBigTextStyle,
                              ),
                            ),
                          )
                      ),
                      Positioned(
                        right: 12,
                        top: 38,
                        child: Visibility(
                          visible: data.isDay,
                          child: RoundButton(
                              onTap: () => Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const DaysDurationScreen())),
                              icon: Icons.stacked_bar_chart_sharp
                          ),
                        ),
                      ),
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

