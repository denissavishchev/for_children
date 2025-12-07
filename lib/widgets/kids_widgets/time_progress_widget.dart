import 'package:flutter/material.dart';
import 'dart:math';

import 'package:for_children/constants.dart';
import 'package:for_children/providers/kid_provider.dart';
import 'package:provider/provider.dart';

class TimeProgressContainer extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay userStartTime;
  final TimeOfDay userEndTime;
  final double containerWidth;
  final double containerHeight = 24;

  const TimeProgressContainer({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.userStartTime,
    required this.userEndTime,
    required this.containerWidth,
  });

  int _toMinutesOfDay(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  @override
  Widget build(BuildContext context) {
    // --- 1. Konwersja i definicja okresów ---
    final int nowM = _toMinutesOfDay(TimeOfDay.now());
    final int startM = _toMinutesOfDay(startTime);
    final int endM = _toMinutesOfDay(endTime);
    final int userStartM = _toMinutesOfDay(userStartTime);
    final int userEndM = _toMinutesOfDay(userEndTime);

    // Całkowity okres rysowania (od najwcześniejszego do najpóźniejszego)
    final int overallStartM = min(startM, userStartM);
    final int overallEndM = max(endM, userEndM);
    final int overallDurationM = overallEndM - overallStartM;

    if (overallDurationM <= 0) {
      return Container(
          width: containerWidth,
          height: containerHeight,
          color: kGrey.withValues(alpha: 0.8));
    }

    // --- 2. Obliczenia dla zielonego paska postępu (Wymagane do umiejscowienia) ---

    // Oblicz postęp tylko w RAMACH OKNA UŻYTKOWNIKA (od userStartM do userEndM)
    final int userElapsedM = nowM - userStartM;
    final int userDurationM = userEndM - userStartM;

    // Proporcja postępu użytkownika (0.0 do 1.0)
    double userProgressRatio = 0.0;
    if (nowM > userStartM) {
      userProgressRatio = userElapsedM / userDurationM;
    }
    // Ogranicz do zakresu 0.0 - 1.0
    userProgressRatio = max(0.0, min(1.0, userProgressRatio));

    // Upewniamy się, że zielony pasek NIE przykrywa czerwonego segmentu
    final int visibleUserStartM = max(userStartM, startM);
    final int visibleUserEndM = userEndM;

// Offset (lewa pozycja) dla zielonego paska
    final double startOffsetWidth =
        containerWidth * ((visibleUserStartM - overallStartM) / overallDurationM);

    // --- 3. Budowanie Segmentów Tła ---
    final List<Widget> backgroundSegments = [];

// 🔴 1. Jeśli użytkownik zaczyna wcześniej niż oficjalny start — czerwony segment
    if (userStartM < startM) {
      backgroundSegments.add(
        Flexible(
          flex: startM - userStartM,
          child: Container(
              decoration: BoxDecoration(
                color: kRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ),
          ),
        ),
      );
    }

// 🔹 2. Okno oficjalnego dnia (np. jasnoszare tło)
    final int officialDurationM = endM - startM;
    if (officialDurationM > 0) {
      backgroundSegments.add(
        Flexible(
          flex: officialDurationM,
          child: Container(
            decoration: BoxDecoration(
              color: kLightBlue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4)),
            ),
          ),
        ),
      );
    }

// ⚪️ 3. Jeśli użytkownik kończy po końcu dnia — przezroczysty fragment
    if (userEndM > endM) {
      backgroundSegments.add(
        Flexible(
          flex: userEndM - endM,
          child: Container(color: Colors.transparent),
        ),
      );
    }

    return Consumer<KidProvider>(
        builder: (context, kidsData, _){
          return SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedAlign(
                  duration: Duration(milliseconds: 500),
                  alignment: kidsData.isDay ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: kGrey, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        // 1. BACKGROUND LAYER (Używa Flexible, aby idealnie wypełnić containerWidth)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch, // Wypełnij wysokość Stack
                          children: backgroundSegments,
                        ),

                        // 2. PROGRESS LAYER (Green Fill)
                        Positioned(
                          left: startOffsetWidth,
                          child: Container(
                            width: containerWidth *
                                ((visibleUserEndM - visibleUserStartM) / overallDurationM) *
                                userProgressRatio,
                            height: containerHeight,
                            decoration: BoxDecoration(
                              color: kGreen,
                            ),
                          ),
                        ),

                        // 3. RED DOT MARKER (Jeśli czas użytkownika przekracza Standard End)
                        if (userEndM > endM)
                          Positioned(
                            // Pozycja Czerwonej Kropki (Standard End Time)
                            left: containerWidth * ((endM - overallStartM) / overallDurationM) - 5,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              margin: EdgeInsets.symmetric(vertical: (containerHeight - 10) / 2),
                              decoration: const BoxDecoration(
                                color: kRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
    }
    );
  }
}