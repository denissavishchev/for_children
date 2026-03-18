import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/parent_provider.dart';

class ParentOnboardingScreenThree extends StatelessWidget {
  const ParentOnboardingScreenThree({super.key,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Column(
                              children: [
                                _five(context),
                                _seven(context)
                              ],
                            ),
                            Expanded(child: _six(context))
                          ],
                        ),

                      ],
                    ),
                    Positioned(
                        right: -30,
                        top: 40,
                        child: Image.asset('assets/images/onboardingParent3.png', width: 160,)
                    ),
                    Positioned(
                        right: 0,
                        top: size.height * 0.5,
                        child: Image.asset('assets/images/onboardingParent1.png', width: 140,)
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
        child: Text('kidShowsWhatWant'.tr(),
          style: kTextStyle.copyWith(fontSize: 42.sp),),
      ),
    );
  }

  Container _two(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.6,
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
          Text('canCreateWishList'.tr(), style: kTextStyle),
          Text('canCreateWishListDescription'.tr(), style: kTextStyle),
        ],
      ),
    );
  }

  Stack _three(context) {
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width * 0.7,
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
          child: Consumer<ParentProvider>(
              builder: (context, data, _){
                return Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('whatChildCanAdd'.tr(), style: kTextStyle,),
                    Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          color: kDarkWhite,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
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
                        children: List.generate(data.wishes.length, ((i){
                          return Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    i % 2 == 0
                                        ? kWhite.withValues(alpha: 0.2)
                                        : kGrey.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(i == data.wishes.length ? 12 : 0),
                                  bottomRight: Radius.circular(i == data.wishes.length ? 12 : 0),
                                  topRight: Radius.circular(i == 0 ? 12 : 0),
                                  topLeft: Radius.circular(i == 0 ? 12 : 0),
                                )
                            ),
                            child: Row(
                              spacing: 8,
                              children: [
                                Image.asset('assets/images/${data.wishes.keys.elementAt(i)}.png', width: 22,),
                                Text(data.wishes.values.elementAt(i), style: kTextStyleNormal,),
                              ],
                            ),
                          );
                        })),
                      ),
                    ),
                    Text('wishesCanBeSmallAndBig'.tr(), style: kTextStyle,),
                  ],
                );
              }
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
            child: _four(context))
      ],
    );
  }

  Container _four(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.45,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: kDarkWhite, width: 1),
          boxShadow: [
            BoxShadow(
              color: kGrey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(-1, 1),
            ),
          ]
      ),
      child: Consumer<ParentProvider>(
          builder: (context, data, _){
            return Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('howItWorks'.tr(),style: kTextStyle,),
                Column(
                  spacing: 4,
                  children: List.generate(data.howItWorks.length, ((i){
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  data.howItWorks.values.elementAt(i).withValues(alpha: 0.4),
                                  data.howItWorks.values.elementAt(i).withValues(alpha: 0.7),
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
                            child: Text('${i + 1}', style: kTextStyle),
                          ),
                        ),
                        Expanded(child: Text(data.howItWorks.keys.elementAt(i).tr(), style: kTextStyleNormal,)),
                      ],
                    );
                  })),
                )
              ],
            );
          }
      ),
    );
  }

  Container _five(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: kDarkWhite, width: 1),
          boxShadow: [
            BoxShadow(
              color: kGrey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(-1, 1),
            ),
          ]
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('affectFamilyRelationships'.tr(),style: kTextStyle,),
          Column(
            spacing: 4,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.check, color: kGreen, size: 18,),
                  Expanded(child: Text('parentsUnderstandTheChildBetter'.tr(), style: kTextStyleNormal,)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.check, color: kGreen, size: 18,),
                  Expanded(child: Text('childTalksOpenly'.tr(), style: kTextStyleNormal,)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Icon(Icons.check, color: kGreen, size: 18,),
                  Expanded(child: Text('turnsObligationsIntoContracts'.tr(), style: kTextStyleNormal,)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Container _six(context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 62),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                kGreen.withValues(alpha: 0.2),
                kGreen.withValues(alpha: 0.1),
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
          Text('whatGiveToChild'.tr(),style: kTextStyle,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, color: kBlue, size: 6,)),
              Expanded(child: Text('learnSetGoals'.tr(),style: kTextStyleNormal,)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, color: kBlue, size: 6,),
              ),
              Expanded(child: Text('waitForReward'.tr(),style: kTextStyleNormal,)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, color: kBlue, size: 6,),
              ),
              Expanded(child: Text('understandRelationshipBetweenEffortAndResult'.tr(),style: kTextStyleNormal,)),
            ],
          ),
        ],
      ),
    );
  }

  Container _seven(context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.5,
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
      child: Text('whenChildHasGoal'.tr(),
        style: kTextStyle,
        textAlign: TextAlign.center,),
    );
  }
}
