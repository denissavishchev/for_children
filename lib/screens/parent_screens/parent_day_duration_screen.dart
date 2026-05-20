import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/screens/parent_screens/parent_history_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/durations_model.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/parents_widget/parent_round_button.dart';

class ParentDayDurationScreen extends StatefulWidget {
  const ParentDayDurationScreen({super.key});

  @override
  State<ParentDayDurationScreen> createState() => _ParentDayDurationScreenState();
}

class _ParentDayDurationScreenState extends State<ParentDayDurationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final parentProvider = Provider.of<ParentProvider>(context, listen: false);
      await parentProvider.fetchAndStoreKidsDurations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Consumer<ParentProvider>(
          builder: (context, data, _) {
            if (data.kidsList.isEmpty || !data.kidsList.any((kid) => kid.accept == true)) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 24,
                  children: [
                    Row(
                      children: [
                        ParentRoundButton(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ParentHistoryScreen())),
                            icon: Icons.arrow_back_ios_new),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBlue, width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'noAddedOrAcceptedKids'.tr(),
                              style: kBigTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Image.asset('assets/images/playground.png', width: 140,)
                          ],
                        )),
                  ],
                ),
              );
            }if (data.durationsList.isEmpty) {
              return const Center(
                child: SpinKitSpinningLines(
                  color: kBlue,
                  size: 50,
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                spacing: 12,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Row(
                      spacing: 12,
                      children: [
                        ParentRoundButton(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ParentHistoryScreen())),
                            icon: Icons.arrow_back_ios_new),
                        Expanded(child: Text('dayDurationDescription'.tr(), style: kSmallTextStyle)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      spacing: 24,
                      children: List.generate(data.durationsList.length, (i) {
                        return DaysDurationWidget(
                          durations: data.durationsList[i],
                          kidName: data.kidsList[i].name,
                        );
                      }),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


class DaysDurationWidget extends StatefulWidget {
  final List<DurationsModel> durations;
  final String kidName;

  const DaysDurationWidget({
    super.key,
    required this.durations,
    required this.kidName,
  });

  @override
  State<DaysDurationWidget> createState() => _DaysDurationWidgetState();
}

class _DaysDurationWidgetState extends State<DaysDurationWidget> {
  bool _isMonthView = false;
  int _pageIndex = 0;

  double _timeToDouble(String time) {
    if (time.contains(' ')) time = time.split(' ')[1];
    final parts = time.split(':');
    return int.parse(parts[0]) + (int.parse(parts[1]) / 60);
  }

  String _doubleToTime(double value) {
    int hours = value.floor();
    int minutes = ((value - hours) * 60).round();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String _getDurationLabel(double start, double end) {
    double duration = (end - start).abs();
    int hours = duration.floor();
    int minutes = ((duration - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  String _getMonthName(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      String month = DateFormat('MMMM', context.locale.toString()).format(dt);
      if (month.isEmpty) return '';
      return '${month[0].toUpperCase()}${month.substring(1)}';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    final reversedData = widget.durations.reversed.toList();
    List displayList = [];
    String monthLabel = '';
    String weekRange = '';

    if (_isMonthView) {
      final monthData = reversedData.take(28).toList();
      if (monthData.isNotEmpty) {
        monthLabel = _getMonthName(monthData.first.start);

        for (int i = 0; i < 4; i++) {
          int startIdx = i * 7;
          if (startIdx >= monthData.length) break;

          final weekChunk = monthData.skip(startIdx).take(7).toList();
          double avgPS = 0, avgPE = 0, avgKS = 0, avgKE = 0;

          for (var e in weekChunk) {
            avgPS += _timeToDouble(e.parentStart);
            avgPE += _timeToDouble(e.parentEnd);
            avgKS += _timeToDouble(e.start);
            avgKE += _timeToDouble(e.end == '' ? DateFormat('HH:mm').format(DateTime.now()) : e.end);
          }

          String firstDay = DateFormat('dd.MM').format(DateTime.parse(weekChunk.last.start));
          String lastDay = DateFormat('dd.MM').format(DateTime.parse(weekChunk.first.start));

          displayList.add({
            'isAvg': true,
            'pStart': avgPS / weekChunk.length,
            'pEnd': avgPE / weekChunk.length,
            'kStart': avgKS / weekChunk.length,
            'kEnd': avgKE / weekChunk.length,
            'label': '$firstDay\n$lastDay',
            'avgKStartTime': _doubleToTime(avgKS / weekChunk.length),
            'avgKEndTime': _doubleToTime(avgKE / weekChunk.length),
          });
        }
        displayList = displayList.reversed.toList();
      }
    } else {
      var currentWeek = reversedData.skip(_pageIndex * 7).take(7).toList();
      displayList = currentWeek.reversed.toList();

      if (displayList.isNotEmpty) {
        final String startDate = DateFormat('dd.MM').format(DateTime.parse(displayList.first.start));
        final String endDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(displayList.last.start));
        weekRange = '$startDate - $endDate';
      }
    }

    double minY = 0;
    double maxY = 24;
    if (displayList.isNotEmpty) {
      List<double> allValues = [];
      for (var item in displayList) {
        if (_isMonthView) {
          allValues.addAll([item['pStart'], item['pEnd'], item['kStart'], item['kEnd']]);
        } else {
          allValues.add(_timeToDouble(item.parentStart));
          allValues.add(_timeToDouble(item.parentEnd));
          allValues.add(_timeToDouble(item.start));
          allValues.add(item.end == '' ? _timeToDouble(DateFormat('HH:mm').format(DateTime.now())) : _timeToDouble(item.end));
        }
      }
      minY = (allValues.reduce(min) - 1).clamp(0, 24).floorToDouble();
      maxY = (allValues.reduce(max) + 1).clamp(0, 24).ceilToDouble();
    }

    bool canGoBack = reversedData.length > (_pageIndex + 1) * 7;
    bool canGoForward = _pageIndex > 0;
    final int totalDays = widget.durations.length;
    final String weekButtonLabel = totalDays < 7
        ? '$totalDays ${totalDays == 1 ? 'day'.tr() : 'days'.tr()}'
        : 'week'.tr();

    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
          color: kWhite.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          border: Border.all(color: kGrey.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: kGrey.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ]
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.kidName, style: kBigTextStyle,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 12,
              children: [
                _filterButton(weekButtonLabel, false, size),
                _filterButton('month'.tr(), true, size),
              ],
            ),
          ),
          if (_isMonthView)
            Text(monthLabel, style: kBigTextStyle.copyWith(color: kGrey, fontSize: 26.sp))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: canGoBack ? kOrange : kGrey),
                  onPressed: canGoBack ? () => setState(() => _pageIndex++) : null,
                ),
                Text(weekRange, style: kTextStyle.copyWith(color: kGrey, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: canGoForward ? kOrange : kGrey),
                  onPressed: canGoForward ? () => setState(() => _pageIndex--) : null,
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              spacing: 4,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.circle, size: 12, color: kOrange),
                    Text(_isMonthView ? 'kidWeeklyAvgDuration'.tr() : 'kidDailyDuration'.tr(), style: kTextStyleOrange)
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.circle, size: 12, color: kBlue),
                    Text(_isMonthView ? 'parentWeeklyAvgDuration'.tr() : 'parentDailyDuration'.tr(), style: kTextStyle)
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            constraints: const BoxConstraints(maxHeight: 420, minHeight: 50),
            padding: const EdgeInsets.all(4),
            color: Colors.transparent,
            child: displayList.isEmpty
                ? const Center(
              child: SpinKitSpinningLines(
                color: kBlue,
                size: 40,
              ),
            )
                : BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => kWhite,
                    tooltipBorderRadius: BorderRadius.circular(12),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = displayList[groupIndex];
                      double ps, pe, ks, ke;
                      String title = "";

                      if (_isMonthView) {
                        ps = item['pStart']; pe = item['pEnd'];
                        ks = item['kStart']; ke = item['kEnd'];
                        title = "Weekly Avg:\n";
                      } else {
                        ps = _timeToDouble(item.parentStart);
                        pe = _timeToDouble(item.parentEnd);
                        ks = _timeToDouble(item.start);
                        ke = item.end == '' ? _timeToDouble(DateFormat('HH:mm').format(DateTime.now())) : _timeToDouble(item.end);
                        title = "${DateFormat('dd.MM').format(DateTime.parse(item.start))}\n";
                      }

                      String parentDur = _getDurationLabel(ps, pe);
                      String kidDur = _getDurationLabel(ks, ke);
                      String diffLabel = _getDurationLabel(0, ((pe - ps) - (ke - ks)).abs());

                      return BarTooltipItem(
                        title,
                        kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: 'parent'.tr(args: ['$parentDur\n']), style: kTextStyle),
                          TextSpan(text: 'kid'.tr(args: ['$kidDur\n']), style: kTextStyleOrange),
                          TextSpan(text: 'dif'.tr(args: [diffLabel]), style: kTextStyleGrey),
                        ],
                      );
                    },
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: minY,
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value <= minY || value >= maxY) return const SizedBox();
                        return Text('${value.toInt()}:00', style: kTextStyle.copyWith(color: kGrey));
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= displayList.length) return const SizedBox();
                        if (_isMonthView) {
                          return Column(
                            children: [
                              Text(displayList[index]['avgKStartTime'], style: kTextStyleOrange),
                              Text(displayList[index]['avgKEndTime'], style: kTextStyleOrange),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(displayList[index].start.split(' ')[1].substring(0, 5), style: kTextStyleOrange),
                            displayList[index].end == '' ? const SizedBox() : Text(displayList[index].end.split(' ')[1].substring(0, 5), style: kTextStyleOrange),
                          ],
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 80,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= displayList.length) return const SizedBox();

                        if (_isMonthView) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              displayList[index]['label'],
                              textAlign: TextAlign.center,
                              style: kTextStyle.copyWith(color: kGrey),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            spacing: 4,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Text(displayList[index].parentStart.substring(0, 5), style: kTextStyle),
                                  Text(displayList[index].parentEnd.substring(0, 5), style: kTextStyle),
                                ],
                              ),
                              Text(DateFormat('dd.MM').format(DateTime.parse(displayList[index].start)), style: kTextStyle.copyWith(color: kGrey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                    show: true,
                    horizontalInterval: 3,
                    getDrawingHorizontalLine: (value) {
                      if (value <= minY || value >= maxY) return const FlLine(color: Colors.transparent);
                      return FlLine(color: kGrey.withValues(alpha: 0.2), strokeWidth: 1);
                    }),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(displayList.length, (index) {
                  double ps, pe, ks, ke;
                  if (_isMonthView) {
                    ps = displayList[index]['pStart'];
                    pe = displayList[index]['pEnd'];
                    ks = displayList[index]['kStart'];
                    ke = displayList[index]['kEnd'];
                  } else {
                    ps = _timeToDouble(displayList[index].parentStart);
                    pe = _timeToDouble(displayList[index].parentEnd);
                    ks = _timeToDouble(displayList[index].start);
                    ke = displayList[index].end == '' ? _timeToDouble(DateFormat('HH:mm').format(DateTime.now())) : _timeToDouble(displayList[index].end);
                  }
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(fromY: ps, toY: pe, color: kBlue, width: _isMonthView ? 35 : 12),
                      BarChartRodData(fromY: ks, toY: ke, color: kOrange, width: _isMonthView ? 35 : 12),
                    ],
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _filterButton(String label, bool isMonth, Size size) {
    bool active = _isMonthView == isMonth;
    return GestureDetector(
      onTap: () => setState(() {
        _isMonthView = isMonth;
        _pageIndex = 0;
      }),
      child: Container(
        width: size.width * 0.42,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              kWhite,
              kWhite.withValues(alpha: 0.01),
            ], begin: Alignment.bottomRight, end: Alignment.topLeft, stops: const [0.1, 1]),
            border: Border.all(color: active ? kDarkWhite : kGrey.withValues(alpha: 0.2), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(size.width * 0.45)),
            boxShadow: [
              BoxShadow(
                  color: kGrey.withValues(alpha: 0.3),
                  blurRadius: active ? 3 : 0,
                  spreadRadius: active ? 0.5 : 0,
                  offset: Offset(0, active ? 2 : 0)),
            ]),
        child: Center(
          child: Text(
            label,
            style: kBigTextStyle.copyWith(
              fontSize: 22.sp,
              color: active ? kOrange.withValues(alpha: 0.8) : kBlue.withValues(alpha: 0.5),
              shadows: [
                Shadow(
                  color: active ? kOrange.withValues(alpha: 0.4) : Colors.transparent,
                  blurRadius: 10,
                ),
                Shadow(
                  color: active ? kOrange.withValues(alpha: 0.2) : Colors.transparent,
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
