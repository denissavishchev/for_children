import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kGrey = Color(0xffe6dfd5);
const kBlue = Color(0xff4b75b1);
const kDarkGrey = Color(0xff92949a);
const kRed = Color(0xffee6561);
const kGreen = Color(0xff2f8d5c);

final kTextStyle = TextStyle(
    color: kBlue,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final kBigTextStyleGrey = TextStyle(
    color: kGrey,
    fontWeight: FontWeight.bold,
    fontSize: 36.sp,
    // fontFamily: 'Roboto'
);

final kTextStyleGrey = TextStyle(
    color: kGrey,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final kBigTextStyle = TextStyle(
    color: kBlue,
    fontWeight: FontWeight.bold,
    fontSize: 32.sp,
    // fontFamily: 'Roboto'
);

final kSmallTextStyle = TextStyle(
    color: kBlue,
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    // fontFamily: 'Roboto'
);

final kGreenTextStyle = TextStyle(
    color: kGreen,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final textFieldDecoration = InputDecoration(
    hintStyle: kTextStyle,
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kDarkGrey)
    ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kDarkGrey)
    ),
    focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kRed)
    ),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kRed)
    ),
);
