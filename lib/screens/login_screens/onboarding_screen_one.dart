import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kGrey,
      body: Column(
        children: [
          const SizedBox(height: 40,),
          Container(
            width: size.width,
            height: size.height * 0.5,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Text('onboardingParentOne'.tr(),
                style: kTextStyle,
                textAlign: TextAlign.justify),
          ),
          Container(
            width: size.width,
            height: size.height * 0.3,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Text('onboardingParentThree'.tr(),
                style: kTextStyle,
                textAlign: TextAlign.justify),
          ),
        ],
      ),
    );
  }
}