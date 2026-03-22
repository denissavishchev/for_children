import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class KidOnboardingScreenThree extends StatelessWidget {
  const KidOnboardingScreenThree({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: Consumer<LoginProvider>(
          builder: (context, data, _){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                        _five(context),
                        _six(context)
                      ],
                    ),
                    Positioned(
                        right: 0,
                        top: 60,
                        child: Image.asset('assets/images/onboardingKid10.png', width: 210,)
                    ),
                    Positioned(
                        right: 0,
                        bottom: -5,
                        child: Image.asset('assets/images/onboardingParent11.png', width: 80,)
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
        child: Text('priceCanBeNegotiated'.tr(),
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
          Text('sometimesTheTaskSeemsDifficult'.tr(), style: kTextStyle),
          Text('youCanOfferYourPriceForTask'.tr(), style: kTextStyle),
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
              Text('example'.tr(), style: kTextStyle.copyWith(fontSize: 32.sp),),
              Container(
                width: size.width * 0.8,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.8),
                          kDarkWhite.withValues(alpha: 0.1),
                        ],
                        stops: [0.2, 1]
                    ),
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
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('cleanTheRoom'.tr(), style: kBigTextStyle,),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  kOrange.withValues(alpha: 0.5),
                                  kOrange.withValues(alpha: 0.4),
                                ],
                                stops: [0.6, 1]
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            border: Border.all(color: kGrey.withValues(alpha: 0.2), width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: kGrey.withValues(alpha: 0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              )
                            ]
                        ),
                        child: Text('rewardIceCream'.tr(), style: kTextStyle,)),
                    const SizedBox(height: 4,),
                    Text('youCanSay'.tr(), style: kTextStyle,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              kGreen.withValues(alpha: 0.5),
                              kGreen.withValues(alpha: 0.4),
                            ],
                            stops: [0.6, 1]
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        border: Border.all(color: kGrey.withValues(alpha: 0.2), width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: kGrey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(2, 2),
                            )
                          ]
                      ),
                      child: Text('doItFor2IceCreams'.tr(), style: kTextStyle,)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: 70,
            child: Image.asset('assets/images/onboardingKid6.png', width: 120,)
        ),
      ],
    );
  }

  Stack _four(context) {
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width,
          padding: const EdgeInsets.all(12),
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
              Text('whatIsNext'.tr(), style: kTextStyle.copyWith(fontSize: 32.sp),),
              Text('parentCan'.tr(), style: kTextStyle,),
              Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/check.svg', width: 16,),
                  Text('agree'.tr(), style: kTextStyle,)
                ],
              ),
              Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/cancel.svg', width: 16,),
                  Text('offerDifferentPrice'.tr(), style: kTextStyle,)
                ],
              ),
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: -20,
            child: Image.asset('assets/images/onboardingKid9.png', width: 200,)
        ),
      ],
    );
  }

  Container _five(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kOrange.withValues(alpha: 0.2),
              Colors.transparent,
            ],
            stops: [0.7, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('thisIsCalledNegotiation'.tr(), style: kBigTextStyle),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('learningToNegotiateBuildsSelf'.tr(), style: kTextStyle,)),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('developsArgumentationAndCriticalThinkingSkills'.tr(), style: kTextStyle,)),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('teachesRespectForWorkAndValueOfMoney'.tr(), style: kTextStyle,)),
            ],
          ),
        ],
      ),
    );
  }

  Container _six(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              kGreen.withValues(alpha: 0.2),
              kGreen.withValues(alpha: 0.2),
              Colors.transparent,
            ],
            stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text('tryToNegotiateBetterReward'.tr(),style: kTextStyle,),
    );
  }

}
