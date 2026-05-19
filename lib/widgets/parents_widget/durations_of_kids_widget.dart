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

              final List<Map<String, dynamic>> todayDurations = snapshot.data ?? [];

              return parentData.kidsList.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text('noAddedKids'.tr(), style: kTextStyle, textAlign: TextAlign.center,),
                  )
                  : Column(
                    children: List.generate(
                      parentData.kidsList.length, (index) {
                      final kid = parentData.kidsList[index];
                      final Map<String, dynamic>? data = todayDurations.cast<Map<String, dynamic>?>().firstWhere(
                            (element) => element?['email'] == kid.email,
                        orElse: () => null,
                      );
                      final String userStartTime = (data != null && data['start'] != null)
                          ? DateFormat('HH:mm:ss').format(DateTime.tryParse(data['start'].toString()) ?? DateTime.now())
                          : DateFormat('HH:mm:ss').format(DateTime.now());

                      final String userEndTime = (data != null && data['end'] != null)
                          ? DateFormat('HH:mm:ss').format(DateTime.tryParse(data['end'].toString()) ?? DateTime.now())
                          : DateFormat('HH:mm:ss').format(DateTime.now());

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ParentDayDurationWidget(
                            userStartTime: userStartTime,
                            userEndTime: userEndTime,
                            docs: data,
                            kidsList: parentData.kidsList,
                            index: index,
                          ),
                          if (index < parentData.kidsList.length - 1)
                            const Divider(
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