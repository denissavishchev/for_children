import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/onboarding_screen.dart';
import 'package:for_children/screens/login_screens/register_screen.dart';
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
                children: List.generate(selectedOnboard == Onboard.basic ? 3 : 9, (i){
                  return OnboardingScreen(
                    parentText: 'onboardingParent$i',
                    kidText: 'onboardingKid$i',
                    parentImg: 'onboardingParent$i',
                    kidImg: 'onboardingKid$i',);
                }),
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
                            onPressed: () => data.onboardingController.jumpToPage(
                                selectedOnboard == Onboard.basic ? 2 : 8),
                            child: Text('skip'.tr(), style: kTextStyle,)),
                        const Spacer(),
                        SmoothPageIndicator(
                            controller: data.onboardingController,
                            count: selectedOnboard == Onboard.basic ? 3 : 9,
                            effect: ExpandingDotsEffect(
                              dotWidth: 12,
                              dotHeight: 12,
                              spacing: 6,
                              dotColor: kBlue.withValues(alpha: 0.5),
                              activeDotColor: kBlue.withValues(alpha: 0.8)
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
                            onPressed: () {
                              if(data.onboardingController.page == 2 && selectedOnboard == Onboard.basic
                              || data.onboardingController.page == 8 && selectedOnboard == Onboard.advanced){
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                    const RegisterScreen()));
                              }else{
                                data.onboardingController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut
                                );
                              }
                            },
                            child: Text('next'.tr(), style: kTextStyle,)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                child: SizedBox(
                  width: size.width,
                  height: 40,
                  child: Row(
                    children: [
                      const Spacer(),
                      IconButton(
                          onPressed: () => data.toLoginScreen(context),
                          icon: const Icon(Icons.clear, size: 34,))
                    ],
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
