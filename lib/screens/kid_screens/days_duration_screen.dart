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
    // final data = Provider.of<KidProvider>(context, listen: false);
    // data.getParentsData();
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
                          maxHeight: 300,
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
                                getTooltipColor: (group) => Colors.blueGrey.withValues(alpha: 0.9),
                                tooltipBorderRadius: BorderRadius.circular(12),
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final pParts = data.parentDurations[groupIndex].split('-').map(double.parse).toList();
                                  final kParts = data.durations[groupIndex].split('-').map(double.parse).toList();
                                  final pDuration = pParts[1] - pParts[0];
                                  final kDuration = kParts[1] - kParts[0];
                                  final difference = kDuration - pDuration;
                                  final diffSign = difference >= 0 ? '+' : '';

                                  String label = rodIndex == 0 ? 'Parent: ' : 'Kid: ';
                                  double currentDur = rodIndex == 0 ? pDuration : kDuration;

                                  return BarTooltipItem(
                                    '$label${currentDur.toStringAsFixed(1)}h\n',
                                    kTextStyleWhite,
                                    children: [
                                      TextSpan(
                                        text: 'Difference: $diffSign${difference.toStringAsFixed(1)}h',
                                        style: TextStyle(
                                          color: difference == 0 ? kWhite : (difference > 0 ? kGreen : kOrange),
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
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
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= data.durations.length) return const SizedBox();
                                    return Text(
                                      data.durations[index],
                                      style: kTextStyleOrange,
                                    );
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  getTitlesWidget: (value, meta) {
                                    const days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'Nd'];
                                    int index = value.toInt();

                                    if (index < 0 || index >= days.length) return const SizedBox();

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Column(
                                        spacing: 4,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            data.parentDurations[index],
                                            style: kTextStyle,
                                          ),
                                          Text(
                                              days[index],
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
                            barGroups: List.generate(data.durations.length, (index) {
                              final p = data.parentDurations[index].split('-').map(double.parse).toList();
                              final k = data.durations[index].split('-').map(double.parse).toList();

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    fromY: p[0],
                                    toY: p[1],
                                    color: kBlue,
                                    width: 12,
                                  ),
                                  BarChartRodData(
                                    fromY: k[0],
                                    toY: k[1],
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

