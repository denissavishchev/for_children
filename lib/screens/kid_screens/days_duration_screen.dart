import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/screens/kid_screens/kids_settings_screen.dart';
import 'package:for_children/widgets/round_button.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';

class DaysDurationScreen extends StatefulWidget {
  const DaysDurationScreen({super.key});

  @override
  State<DaysDurationScreen> createState() => _DaysDurationScreenState();
}

class _DaysDurationScreenState extends State<DaysDurationScreen> {

  @override
  void initState() {
    final data = Provider.of<KidProvider>(context, listen: false);
    data.getDayDurationData(context);();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
          child: Consumer<KidProvider>(
            builder: (context, data, _){
              return SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundButton(
                              onTap: () => Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const KidsSettingsScreen())),
                              icon: Icons.close
                          ),
                          Text('dailyDuration'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                          const SizedBox(width: 40,),
                        ],
                      ),
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
                              Text('kidDailyDuration'.tr(), style: kTextStyleOrange,),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.circle, size: 12, color: kBlue),
                              Text('parentDailyDuration'.tr(), style: kTextStyle,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: size.width,
                        constraints: BoxConstraints(
                          maxHeight: 400,
                          minHeight: 50,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kWhite.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: kGrey),
                        ),
                        child: BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => kDarkWhite,
                                tooltipBorderRadius: BorderRadius.circular(12),
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final pStartParts = data.durationsList[groupIndex].parentStart.split(':');
                                  final pEndParts = data.durationsList[groupIndex].parentEnd.split(':');

                                  final pDur = Duration(
                                    hours: int.parse(pEndParts[0]) - int.parse(pStartParts[0]),
                                    minutes: int.parse(pEndParts[1]) - int.parse(pStartParts[1]),
                                  );

                                  final kStart = DateTime.parse(data.durationsList[groupIndex].start);
                                  final kEnd = data.durationsList[groupIndex].end.isEmpty
                                      ? DateTime.now()
                                      : DateTime.parse(data.durationsList[groupIndex].end);

                                  final kDur = kEnd.difference(kStart);
                                  final diff = kDur - pDur;
                                  final isPositive = !diff.isNegative;
                                  final diffSign = isPositive ? '+' : '-';

                                  String formatDur(Duration d) {
                                    final hours = d.inHours.abs();
                                    final minutes = d.inMinutes.abs().remainder(60);
                                    return '${hours}h ${minutes}m';
                                  }

                                  String label = rodIndex == 0 ? 'Parent: ' : 'Kid: ';
                                  String currentDurStr = rodIndex == 0 ? formatDur(pDur) : formatDur(kDur);

                                  return BarTooltipItem(
                                    '$label$currentDurStr\n',
                                    kTextStyle,
                                    children: [
                                      TextSpan(
                                        text: 'Difference: $diffSign${formatDur(diff)}',
                                        style: TextStyle(
                                          color: diff.inMinutes == 0 ? kWhite : (isPositive ? kRed : kGreen),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 24,
                            minY: 5,
                            titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value == meta.min || value == meta.max) {
                                      return const SizedBox();
                                    }
                                    return Text(
                                      '${value.toInt()}:00',
                                      style: kTextStyle.copyWith(color: kGrey),
                                    );
                                  },
                                  interval: 3,
                                  reservedSize: 35,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 36,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= data.durationsList.length) return const SizedBox();
                                    return Column(
                                      children: [
                                        Text(data.durationsList[index].start.split(' ')[1].substring(0, 5), style: kTextStyleOrange),
                                        data.durationsList[index].end == ''
                                        ? const SizedBox()
                                        : Text(data.durationsList[index].end.split(' ')[1].substring(0, 5), style: kTextStyleOrange,),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Column(
                                        spacing: 4,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            children: [
                                              Text(data.durationsList[index].parentStart.substring(0, 5), style: kTextStyle),
                                              Text(data.durationsList[index].parentEnd.substring(0, 5), style: kTextStyle),
                                            ],
                                          ),
                                          Text(DateFormat('dd.MM').format(DateTime.parse(data.durationsList[index].start)),
                                              style: kTextStyle.copyWith(color: kGrey),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: 2,
                              getDrawingHorizontalLine: (value) => FlLine(
                                  color: kGrey,
                                  strokeWidth: 1
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(data.durationsList.length, (index) {
                              final pStart = double.parse(data.durationsList[index].parentStart.split(':')[0]);
                              final pEnd = double.parse(data.durationsList[index].parentEnd.split(':')[0]);
                              final kStart = double.parse(data.durationsList[index].start.split(' ')[1].split(':')[0]);
                              final kEnd = data.durationsList[index].end == ''
                                  ? DateTime.now().hour.toDouble()
                                  : double.parse(data.durationsList[index].end.split(' ')[1].split(':')[0]);

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    fromY: pStart,
                                    toY: pEnd,
                                    color: kBlue,
                                    width: 12,
                                  ),
                                  BarChartRodData(
                                    fromY: kStart,
                                    toY: kEnd,
                                    color: kOrange,
                                    width: 12,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                    )
                  ],
                ),
              );
            },
          )
      ),
    );
  }
}

