import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class KidOnboardingScreenTwo extends StatelessWidget {
  const KidOnboardingScreenTwo({super.key,
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
                child: SizedBox(
                  height: size.height,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          _one(context),
                          _two(context),
                          _three(context),
                          _four(context),
                        ],
                      ),
                      Positioned(
                          right: 0,
                          top: 60,
                          child: Image.asset('assets/images/onboardingKid11.png', width: 210,)
                      ),
                      Positioned(
                          right: -20,
                          top: size.height * 0.55,
                          child: Image.asset('assets/images/onboardingKid1.png', width: 180,)
                      ),
                    ],
                  ),
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
      height: size.height * 0.08,
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
        child: Text('completeTasksAndEarn'.tr(),
          style: kTextStyle.copyWith(fontSize: 42.sp),),
      ),
    );
  }

  Container _two(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.5,
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
          Text('parentsCanAssignTasks'.tr(), style: kTextStyle),
          Text('whenYouCompleteThem'.tr(), style: kTextStyle),
        ],
      ),
    );
  }

  Stack _three(context) {
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  kGreen.withValues(alpha: 0.2),
                  kGreen.withValues(alpha: 0.1),
                ],
                stops: [0.6, 1]
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: kGrey.withValues(alpha: 0.2), width: 0.5),
          ),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('examplesOfTasks'.tr(), style: kTextStyle.copyWith(fontSize: 32.sp),),
              Text('youCanEarnRewardsFor'.tr(), style: kTextStyle,),
              Container(
                width: size.width * 0.8,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: kDarkWhite,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: kGrey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('cleaningTheRoom'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Container(
                width: size.width * 0.7,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: kDarkWhite,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: kGrey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('helpInTheKitchen'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Container(
                width: size.width * 0.6,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: kDarkWhite,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: kGrey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('completingHomework'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Container(
                width: size.width * 0.6,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: kDarkWhite,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: kGrey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('walkWithTheDog'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Container(
                width: size.width * 0.5,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: kDarkWhite,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: kGrey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('helpForParents'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Text('everyTaskReward'.tr(), style: kBigTextStyle,),
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: 20,
            child: Image.asset('assets/images/onboardingParent10.png', width: 140,)
        ),
        Positioned(
            right: 0,
            top: 120,
            child: Image.asset('assets/images/onboardingParent11.png', width: 160,)
        ),
      ],
    );
  }

  Container _four(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kOrange.withValues(alpha: 0.2),
              Colors.transparent,
              Colors.transparent
            ],
            stops: [0.0, 0.7, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text('moreTasksMoreRewards'.tr(), style: kTextStyle),
    );
  }
}
