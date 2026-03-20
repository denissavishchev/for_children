import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/constants.dart';

import '../../../widgets/button_widget.dart';
import '../register_screen.dart';


class ParentOnboardingScreenSix extends StatelessWidget {
  const ParentOnboardingScreenSix({super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            child: SizedBox(
              height: size.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                      child: Image.asset('assets/images/onboardingParent14.png', width: size.width,)),
                  Positioned(
                    top: size.height * 0.05,
                      child: Column(
                        children: [
                          Text('congratulations'.tr(), style: kBigTextStyleOrange.copyWith(fontSize: 52.sp),),
                          Text('onboardingComplete'.tr(), style: kBigTextKidStyle,),
                        ],
                      )
                  ),
                  Positioned(
                      top: size.height * 0.4,
                      child: Column(
                        spacing: 8,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              width: size.width,
                              child: Text('WishYouGoodLuck'.tr(),
                                style: kBigTextKidStyle.copyWith(fontSize: 36.sp),
                                textAlign: TextAlign.center,),
                            ),
                          ),
                          Text('hopeForGoodResults'.tr(), style: kBigTextKidStyle,),
                        ],
                      )
                  ),
                  Positioned(
                      top: size.height * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              SvgPicture.asset('assets/icons/check.svg', width: 16,),
                              Text('startWithFirstSimpleTask'.tr(), style: kTextStyle,),
                            ],
                          ),
                          Row(
                            spacing: 12,
                            children: [
                              SvgPicture.asset('assets/icons/check.svg', width: 16,),
                              Text('monitorProgressAndPraiseEfforts'.tr(), style: kTextStyle,),
                            ],
                          ),
                          Row(
                            spacing: 12,
                            children: [
                              SvgPicture.asset('assets/icons/check.svg', width: 16,),
                              Text('shareThoughtsAndIdeasWithYourChild'.tr(), style: kTextStyle,),
                            ],
                          ),
                        ],
                      )
                  ),
                  Positioned(
                    bottom: size.height * 0.15,
                      child: ButtonWidget(
                          onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                              const RegisterScreen())),
                          text: 'go'
                      ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}



