import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

class ParentOnboardingScreenOne extends StatelessWidget {
  const ParentOnboardingScreenOne({super.key,
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
                      _five(context),
                      _six(context),
                    ],
                  ),
                  Positioned(
                    right: -20,
                      top: 30,
                      child: Image.asset('assets/images/onboardingParent6.png', width: 160,)
                  ),
                  Positioned(
                      right: -30,
                      top: size.height * 0.3,
                      child: Image.asset('assets/images/onboardingParent5.png', width: 140,)
                  ),
                  Positioned(
                      right: 0,
                      top: size.height * 0.5,
                      child: Image.asset('assets/images/onboardingParent2.png', width: 150,)
                  )
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
        child: Text('childrenDontLike'.tr(),
          style: kTextStyle.copyWith(fontSize: 42.sp),),
      ),
    );
  }

  Container _two(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                kOrange.withValues(alpha: 0.2),
                Colors.transparent
              ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: kDarkWhite, width: 1),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('familiarSituation'.tr(),style: kTextStyle,),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('childrenPutOffTasks'.tr(),style: kTextStyleNormal,),
            ],
          ),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('needToRemind'.tr(),style: kTextStyleNormal,),
            ],
          ),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('quarrelsAndBargainingBegin'.tr(),style: kTextStyleNormal,),
            ],
          ),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('willDoItNow'.tr(),style: kTextStyleNormal,),
            ],
          ),
        ],
      ),
    );
  }

  Container _three(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.65,
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
      child: Text('householdChores'.tr(),style: kTextStyle,),
    );
  }

  Container _four(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.65,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text('maybeTurnIntoGame'.tr(),style: kTextStyle,),
          Text('maybeTurnIntoGameDescription'.tr(),style: kTextStyleNormal,),
        ],
      ),
    );
  }

  Container _five(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: EdgeInsets.fromLTRB(12, 12, size.width * 0.4, 12),
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
          Text('withApplication'.tr(),style: kTextStyle,),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('understandWork'.tr(),style: kTextStyleNormal,),
            ],
          ),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('learnToEarn'.tr(),style: kTextStyleNormal,),
            ],
          ),
          Row(
            spacing: 4,
            children: [
              Icon(Icons.circle, color: kBlue, size: 6,),
              Text('quarrelsAndBargainingBegin'.tr(),style: kTextStyleNormal,),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, color: kBlue, size: 6,)),
              Expanded(child: Text('selfTask'.tr(),style: kTextStyleNormal,)),
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
      child: Text('thousandOfParents'.tr(),style: kTextStyle,),
    );
  }
}
