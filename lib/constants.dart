import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kGrey = Color(0xffe6dfd5);
const kBlue = Color(0xff4b75b1);
const kDarkGrey = Color(0xff92949a);
const kRed = Color(0xffb23c38);
const kGreen = Color(0xff2f8d5c);
const kOrange = Color(0xfff56707);
const kLightBlue = Color(0xff32b1e1);
const kDarkBlue = Color(0xff5c75b8);
const kPurple = Color(0xff7951a4);
const kWhite = Color(0xfff7f8f8);

final kTextStyle = TextStyle(
    color: kBlue,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final kTextKidStyle = TextStyle(
    color: kWhite,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final kTextStyleWhite = TextStyle(
    color: kWhite.withValues(alpha: 0.8),
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final kTextStyleOrange = TextStyle(
    color: kOrange,
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

final kBigTextKidStyle = TextStyle(
    color: kWhite,
    fontWeight: FontWeight.bold,
    fontSize: 32.sp,
    // fontFamily: 'Roboto'
);

final kBigTextStyleWhite = TextStyle(
    color: kWhite.withValues(alpha: 0.8),
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

final kSmallTextStyleWhite = TextStyle(
    color: kWhite,
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

final kRedTextStyle = TextStyle(
    color: kRed,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    // fontFamily: 'Roboto'
);

final kOrangeTextStyle = TextStyle(
    color: kOrange,
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

final textFieldKidDecoration = InputDecoration(
    hintStyle: kTextStyleWhite,
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kOrange)
    ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kOrange)
    ),
    focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kRed)
    ),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kRed)
    ),
);
