import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class KidsOnboardingScreenOne extends StatelessWidget {
  const KidsOnboardingScreenOne({super.key,
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
                        right: -20,
                        top: 80,
                        child: Image.asset('assets/images/onboardingKid2.png', width: 160,)
                    ),
                    Positioned(
                        left: -10,
                        top: 30,
                        child: Image.asset('assets/images/onboardingParent11.png', width: 100,)
                    ),
                    Positioned(
                        right: -60,
                        top: size.height * 0.35,
                        child: Image.asset('assets/images/onboardingKid0.png', width: 180,)
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
      child: Column(
        children: [
          Text('whyDoYouDoTasks'.tr(),
            style: kTextStyle.copyWith(fontSize: 42.sp),),
          Text('willComeInHandyInLife'.tr(),
            style: kTextStyleOrange,),
        ],
      ),
    );
  }

  Container _two(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(12, 12, size.width * 0.3, 12),
        decoration: BoxDecoration(
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
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('whyIsItWorthIt'.tr(),style: kTextStyle,),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('willGetRewards'.tr(), style: kTextStyle,)),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('parentsWillBeProudOfYou'.tr(), style: kTextStyle,)),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('willHaveMorePocketMoney'.tr(), style: kTextStyle,)),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('willUnderstandHowAdultMatchmakingWorks'.tr(), style: kTextStyle,)),
            ],
          ),
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
              kOrange.withValues(alpha: 0.2),
              kDarkWhite.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: kDarkWhite, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: kWhite.withValues(alpha: 0.8),
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: kGrey.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(4, 4),
                  )
                ]
            ),
            child: Text('whatWillYouLearn'.tr(), style: kTextStyle),
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('howToEarnAndSave'.tr(), style: kTextStyle,)),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              SvgPicture.asset('assets/icons/check.svg', width: 16,),
              Expanded(child: Text('howToPlanAndDiscussRewards'.tr(), style: kTextStyle,)),
            ],
          ),
          Image.asset('assets/images/onboardingParent10.png', width: 80,)
        ],
      ),
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
              kGreen.withValues(alpha: 0.2),
              kGreen.withValues(alpha: 0.2),
              Colors.transparent,
            ],
            stops: [0.0, 0.6, 1]
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text('becomeMasterOfSkillsThatAdultsWillNeed'.tr(),style: kTextStyle,),
    );
  }
}
