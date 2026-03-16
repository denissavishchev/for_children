import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class ParentOnboardingScreenTwo extends StatelessWidget {
  const ParentOnboardingScreenTwo({super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        backgroundColor: kWhite,
        body: Consumer<LoginProvider>(
          builder: (context, data, _){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        top: size.height * 0.52,
                        child: Image.asset('assets/images/onboardingParent0.png', width: 170,)
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        _one(context),
                        _two(context),
                        _three(context),
                        _four(context),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _five(context)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _six(context)),
                        _seven(context)
                      ],
                    ),
                    Positioned(
                        right: 0,
                        top: 70,
                        child: Image.asset('assets/images/onboardingParent8.png', width: 120,)
                    ),
                    Positioned(
                        right: -10,
                        top: size.height * 0.28,
                        child: Image.asset('assets/images/onboardingParent1.png', width: 180,)
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }

  Container _one(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.1,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/line.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              kOrange.withValues(alpha: 0.15),
              BlendMode.srcIn,
            ),
          ),
          gradient: LinearGradient(
              colors: [
                kDarkWhite,
                kDarkWhite.withValues(alpha: 0.1),
              ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: kGrey.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: kGrey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
            BoxShadow(
              color: kWhite,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(-2, -2),
            )
          ]
      ),
      child: Center(
        child: Text('agreementInsteadOrders'.tr(),
          style: kTextStyle.copyWith(fontSize: 42.sp),),
      ),
    );
  }

  Container _two(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.7,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.transparent,
              kWhite.withValues(alpha: 0.2),
              kWhite.withValues(alpha: 0.2),
            ],
          stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: kDarkWhite, width: 1),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('applicationHelps'.tr(),style: kTextStyle,),
          Text('parentsMakeTasks'.tr(),style: kTextStyle,),
        ],
      ),
    );
  }

  Container _three(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kGreen.withValues(alpha: 0.2),
              Colors.transparent,
              Colors.transparent,
            ],
            stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text('howItWorks'.tr(),style: kTextStyle.copyWith(fontSize: 42.sp),),
    );
  }

  Stack _four(context) {
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width * 0.6,
          padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
          margin: const EdgeInsets.only(top: 4, left: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  kWhite.withValues(alpha: 0.2),
                  kWhite.withValues(alpha: 0.2),
                ],
                stops: [0.0, 0.6, 1]
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: kDarkWhite, width: 1),
              boxShadow: [
                BoxShadow(
                  color: kGrey.withValues(alpha: 0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ]
          ),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('parentCreateTask'.tr(),style: kTextStyle,),
              Text('forExample'.tr(),style: kTextStyleNormal,),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('cleanRoom'.tr(),style: kTextStyleNormal,),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('doLessons'.tr(),style: kTextStyleNormal,),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('kitchenHelp'.tr(),style: kTextStyleNormal,),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('dogWalk'.tr(),style: kTextStyleNormal,),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    kGreen.withValues(alpha: 0.4),
                    kGreen.withValues(alpha: 0.7),
                  ],
              ),
            shape: BoxShape.circle,
            border: Border.all(color: kDarkWhite, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: kDarkWhite.withValues(alpha: 0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1),
              )
            ]
          ),
          child: Center(
            child: Text('1', style: kTextStyle),
          ),
        )
      ],
    );
  }

  Stack _five(context) {
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width * 0.58,
          padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
          margin: const EdgeInsets.only(top: 4, left: 4),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    kWhite,
                    kWhite.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.6, 1]
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: kDarkWhite, width: 1),
              boxShadow: [
                BoxShadow(
                  color: kGrey.withValues(alpha: 0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ]
          ),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('childSeeTask'.tr(),style: kTextStyle,),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('canAcceptOr'.tr(),style: kTextStyleNormal,),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('proposeYourself'.tr(),style: kTextStyleNormal,),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kBlue.withValues(alpha: 0.4),
                  kBlue.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: kDarkWhite, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: kDarkWhite.withValues(alpha: 0.4),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1),
                )
              ]
          ),
          child: Center(
            child: Text('2', style: kTextStyle),
          ),
        )
      ],
    );
  }

  Stack _six(context) {
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width * 0.58,
          padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
          margin: const EdgeInsets.only(top: 4, left: 4),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    kWhite,
                    kWhite.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.6, 1]
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: kDarkWhite, width: 1),
              boxShadow: [
                BoxShadow(
                  color: kGrey.withValues(alpha: 0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ]
          ),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('childSeeTask'.tr(),style: kTextStyle,),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('canAcceptOr'.tr(),style: kTextStyleNormal,),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.circle, color: kBlue, size: 6,),
                  Text('proposeYourself'.tr(),style: kTextStyleNormal,),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kOrange.withValues(alpha: 0.4),
                  kOrange.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: kDarkWhite, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: kDarkWhite.withValues(alpha: 0.4),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1),
                )
              ]
          ),
          child: Center(
            child: Text('3', style: kTextStyle),
          ),
        )
      ],
    );
  }

  Container _seven(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kWhite.withValues(alpha: 0.1),
              Colors.transparent
            ]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text('itChangeToLife'.tr(),
        style: kTextStyle,
        textAlign: TextAlign.center,),
    );
  }
}
