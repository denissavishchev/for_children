import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/onboarding_screen_one.dart';
import 'package:for_children/screens/login_screens/onboarding_screen_three.dart';
import 'package:for_children/screens/login_screens/onboarding_screen_two.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreens extends StatelessWidget {
  const OnboardingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, data, _){
          return Stack(
            children: [
              PageView(
                controller: data.onboardingController,
                children: const [
                  OnboardingScreenOne(),
                  OnboardingScreenTwo(),
                  OnboardingScreenThree()
                ],
              ),
              Positioned(
                bottom: 20,
                child: SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () => data.onboardingController.jumpToPage(2),
                            child: Text('skip'.tr(), style: kTextStyle,)),
                        const Spacer(),
                        SmoothPageIndicator(
                            controller: data.onboardingController,
                            count: 3,
                            effect: ExpandingDotsEffect(
                              dotWidth: 20,
                              dotHeight: 20,
                              spacing: 16,
                              dotColor: kBlue.withOpacity(0.5),
                              activeDotColor: kBlue.withOpacity(0.8)
                            ),
                          onDotClicked: (index){
                              data.onboardingController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                          },
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () => data.onboardingController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut
                            ),
                            child: Text('next'.tr(), style: kTextStyle,)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
