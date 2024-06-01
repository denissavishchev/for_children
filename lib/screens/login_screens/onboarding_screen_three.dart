import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        backgroundColor: kGrey,
        body: Consumer<LoginProvider>(
          builder: (context, data, _){
            return Center(
              child: Container(
                width: size.width,
                height: size.height * 0.8,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kBlue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  children: [
                    Text(data.role == 'parent'
                        ? 'onboardingParentThree'.tr()
                        : 'onboardingKidThree'.tr(),
                        style: kTextStyle,
                        textAlign: TextAlign.justify),
                    const SizedBox(height: 12,),
                    Expanded(
                      child: Image.asset(data.role == 'parent'
                          ? 'assets/images/onboardingParentThree.png'
                          : 'assets/images/onboardingKidThree.png'),
                    )
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}
