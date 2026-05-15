import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/widgets/parents_widget/parent_day_duration_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/parent_provider.dart';

class DurationsOfKidsWidget extends StatefulWidget {
  const DurationsOfKidsWidget({super.key});

  @override
  State<DurationsOfKidsWidget> createState() => _DurationsOfKidsWidgetState();
}

class _DurationsOfKidsWidgetState extends State<DurationsOfKidsWidget> {
  late Future<List<Map<String, dynamic>>> _durationsFuture;

  @override
  void initState() {
    super.initState();
    final parentProvider = Provider.of<ParentProvider>(context, listen: false);
    _durationsFuture = parentProvider.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
        builder: (context, parentData, _){
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _durationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitSpinningLines(color: kBlue, size: 40),
                );
              }
              final List<Map<String, dynamic>> todayDurations = snapshot.data!;
              return Column(
                children: List.generate(
                  todayDurations.length, (index) {
                    final data = todayDurations[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ParentDayDurationWidget(
                          userStartTime: DateFormat('HH:mm:ss').format(
                            DateTime.tryParse(data['start']?.toString() ?? '') ?? DateTime.now(),
                          ),
                          userEndTime: DateFormat('HH:mm:ss').format(
                            DateTime.tryParse(data['end']?.toString() ?? '') ?? DateTime.now(),
                          ),
                          docs: data,
                          kidsList: parentData.kidsList,
                          index: index,
                        ),
                        if (index < todayDurations.length - 1)
                          Divider(
                            color: kBlue,
                            thickness: 1,
                            indent: 4,
                            endIndent: 4,
                          ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        }
    );
  }
}