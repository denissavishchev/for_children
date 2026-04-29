import 'package:easy_localization/easy_localization.dart';
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
                          Text('daysDuration'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                          const SizedBox(width: 40,),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width,
                      // height: 220,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: kWhite.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        border: Border.all(color: kGrey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center, // Centrowanie kolumn w rzędzie
                        children: List.generate(data.durations.length, (i) {
                          // 1. Parsowanie zakresu TŁA (parent)
                          final parentParts = data.parentDurations[i].split('-');
                          final double pStart = double.parse(parentParts[0]);
                          final double pEnd = double.parse(parentParts[1]);
                          final double pHeight = (pEnd - pStart) * 10.0; // 10px za godzinę

                          // 2. Parsowanie zakresu GÓRNEGO (child/duration)
                          final childParts = data.durations[i].split('-');
                          final double cStart = double.parse(childParts[0]);
                          final double cEnd = double.parse(childParts[1]);
                          final double cHeight = (cEnd - cStart) * 10.0;

                          // 3. Obliczanie przesunięcia
                          final double topOffset = (cStart - pStart) * 10.0;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Napis NAD kontenerem (k ...)
                              Text(
                                'k ${data.durations[i]}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12), // Odstęp dla wystających elementów

                              // WYKRES
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  // DOLNY KONTENER (Parent)
                                  Container(
                                    width: 30,
                                    height: pHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  // GÓRNY KONTENER (Duration)
                                  Positioned(
                                    top: topOffset,
                                    child: Container(
                                      width: 24,
                                      height: cHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12), // Odstęp dla wystających elementów
                              // Napis POD kontenerem (p ...)
                              Text(
                                'p ${data.parentDurations[i]}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          );
                        }),
                      )
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

