import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class KidOnboardingScreenFour extends StatelessWidget {
  const KidOnboardingScreenFour({super.key,});

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
                          _five(context)
                        ],
                      ),
                      Positioned(
                          right: 0,
                          top: 30,
                          child: Image.asset('assets/images/onboardingParent9.png', width: 190,)
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
      height: size.height * 0.1,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
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
        child: Text('makeYourOwnSavings'.tr(),
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
      child: Text('everyTimeYouAddToYourPiggyBank'.tr(), style: kTextStyle),
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
                  kGreen.withValues(alpha: 0.1),
                  kGreen.withValues(alpha: 0.05),
                ],
                stops: [0.6, 1]
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: kGrey.withValues(alpha: 0.2), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('whatCanYouDoWithPiggyBank'.tr(), style: kTextStyle.copyWith(fontSize: 32.sp),),
              const SizedBox(height: 12,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.3),
                          kDarkWhite.withValues(alpha: 0.7),
                          kDarkWhite.withValues(alpha: 0.2),
                        ]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('watchSavingsGrow'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Divider(height: 0, color: kGrey.withValues(alpha: 0.1),),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kDarkWhite.withValues(alpha: 0.3),
                        kDarkWhite.withValues(alpha: 0.7),
                        kDarkWhite.withValues(alpha: 0.2),
                      ]
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('planYourSpending'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Divider(height: 0, color: kGrey.withValues(alpha: 0.1),),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kDarkWhite.withValues(alpha: 0.3),
                        kDarkWhite.withValues(alpha: 0.7),
                        kDarkWhite.withValues(alpha: 0.2),
                      ]
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('viewRewardHistory'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Divider(height: 0, color: kGrey.withValues(alpha: 0.1),),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kDarkWhite.withValues(alpha: 0.3),
                        kDarkWhite.withValues(alpha: 0.7),
                        kDarkWhite.withValues(alpha: 0.2),
                      ]
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('saveForYourDream'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
              Divider(height: 0, color: kGrey.withValues(alpha: 0.1),),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kDarkWhite.withValues(alpha: 0.3),
                        kDarkWhite.withValues(alpha: 0.7),
                        kDarkWhite.withValues(alpha: 0.2),
                      ]
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/check.svg', width: 16,),
                    Text('splitCoinsByGoals'.tr(), style: kTextStyle,)
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: 20,
            child: Image.asset('assets/images/onboardingParent10.png', width: 160,)
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text('moneySuperPower'.tr(), style: kBigTextStyle),
              Container(
                width: size.width * 0.9,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.9),
                          kDarkWhite.withValues(alpha: 0.5),
                          kDarkWhite.withValues(alpha: 0.4),
                        ],
                        stops: [0.0, 0.7, 1]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: kDarkWhite, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: kOrange.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/star.svg', width: 16,),
                    Expanded(child: Text('saveToLearnPatience'.tr(), style: kTextStyle,))
                  ],
                ),
              ),
              Container(
                width: size.width * 0.6,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.9),
                          kDarkWhite.withValues(alpha: 0.5),
                          kDarkWhite.withValues(alpha: 0.4),
                        ],
                        stops: [0.0, 0.7, 1]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: kDarkWhite, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: kOrange.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/star.svg', width: 16,),
                    Expanded(child: Text('saveToMakeDreamsComeTrue'.tr(), style: kTextStyle,))
                  ],
                ),
              ),
              Container(
                width: size.width * 0.6,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.9),
                          kDarkWhite.withValues(alpha: 0.5),
                          kDarkWhite.withValues(alpha: 0.4),
                        ],
                        stops: [0.0, 0.7, 1]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: kDarkWhite, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: kOrange.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/star.svg', width: 16,),
                    Expanded(child: Text('saveToFeelIndependent'.tr(), style: kTextStyle,))
                  ],
                ),
              ),
              Container(
                width: size.width * 0.8,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.9),
                          kDarkWhite.withValues(alpha: 0.5),
                          kDarkWhite.withValues(alpha: 0.4),
                        ],
                        stops: [0.0, 0.7, 1]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: kDarkWhite, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: kOrange.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/star.svg', width: 16,),
                    Expanded(child: Text('saveToUnderstandValue'.tr(), style: kTextStyle,))
                  ],
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          kDarkWhite.withValues(alpha: 0.9),
                          kDarkWhite.withValues(alpha: 0.5),
                          kDarkWhite.withValues(alpha: 0.4),
                        ],
                        stops: [0.0, 0.7, 1]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: kDarkWhite, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: kOrange.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                ),
                child: Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/star.svg', width: 16,),
                    Expanded(child: Text('saveToHelpOthers'.tr(), style: kTextStyle,))
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              right: 0,
              top: 80,
              child: Image.asset('assets/images/onboardingParent12.png', width: 120,)
          ),
        ],
      ),
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
            kGreen.withValues(alpha: 0.4),
            kGreen.withValues(alpha: 0.5),
            kGreen.withValues(alpha: 0.1),
          ],
          stops: [0.0, 0.7, 1]
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: Text('tryToCollectAsMuchMoney'.tr(), style: kTextStyle),
  );
}

}


