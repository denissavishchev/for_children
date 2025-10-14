import 'package:flutter/material.dart';
import 'dart:math';

import 'package:for_children/constants.dart';

class TimeProgressContainer extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay userStartTime;
  final TimeOfDay userEndTime;
  final double containerWidth;
  final double containerHeight = 20;

  const TimeProgressContainer({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.userStartTime,
    required this.userEndTime,
    this.containerWidth = 300,
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
      return Container(width: containerWidth, height: containerHeight, color: kGrey.withValues(alpha: 0.2));
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

    // Szerokość zielonego paska (w pikselach) W RAMACH OKNA UŻYTKOWNIKA
    final double userWindowWidth = containerWidth * (userDurationM / overallDurationM);
    final double filledWidth = userWindowWidth * userProgressRatio;

    // Offset (lewa pozycja) dla zielonego paska
    final double startOffsetWidth = containerWidth * ((userStartM - overallStartM) / overallDurationM);

    // --- 3. Budowanie Segmentów Tła (naprawia Overflow) ---

    final List<Widget> backgroundSegments = [];

    final int beforeUserStartM = userStartM - overallStartM;
    final int afterUserEndM = overallEndM - userEndM;

    // Segment 1: Przed startem użytkownika (Transparent)
    if (beforeUserStartM > 0) {
      backgroundSegments.add(
        Flexible(
          flex: beforeUserStartM,
          child: Container(color: Colors.transparent),
        ),
      );
    }

    // Segment 2: Okno czasowe użytkownika (Aktywne tło)
    if (userDurationM > 0) {
      backgroundSegments.add(
        Flexible(
          flex: userDurationM,
          child: Container(color: kLightBlue.withValues(alpha: 0.8)),
        ),
      );
    }

    // Segment 3: Po końcu użytkownika (Transparent)
    if (afterUserEndM > 0) {
      backgroundSegments.add(
        Flexible(
          flex: afterUserEndM,
          child: Container(color: Colors.transparent),
        ),
      );
    }

    return Container(
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
            left: startOffsetWidth, // Start zielonego paska od userStartTime
            child: Container(
              width: filledWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
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
    );
  }
}