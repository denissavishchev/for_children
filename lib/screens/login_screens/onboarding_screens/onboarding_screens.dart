import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/onboarding_screens/parent_onboarding_screen_six.dart';
import 'package:for_children/screens/login_screens/onboarding_screens/parent_onboarding_screen_one.dart';
import 'package:for_children/screens/login_screens/onboarding_screens/parent_onboarding_screen_three.dart';
import 'package:for_children/screens/login_screens/onboarding_screens/parent_onboarding_screen_two.dart';
import 'package:for_children/screens/login_screens/onboarding_screens/parrent_onboarding_screen_five.dart';
import 'package:for_children/screens/login_screens/onboarding_screens/parrent_onboarding_screen_four.dart';
import 'package:for_children/screens/login_screens/register_screen.dart';
import 'package:for_children/widgets/parents_widget/parent_round_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widgets/kids_widgets/kid_round_button.dart';
import 'kid_onboarding_screen_five.dart';
import 'kid_onboarding_screen_four.dart';
import 'kid_onboarding_screen_one.dart';
import 'kid_onboarding_screen_six.dart';
import 'kid_onboarding_screen_three.dart';
import 'kid_onboarding_screen_two.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {

  @override
  void initState() {
    super.initState();
    final data = Provider.of<LoginProvider>(context, listen: false);
    data.onboardingController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kWhite,
      body: Consumer<LoginProvider>(
        builder: (context, data, _){
          return SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 36,),
                    Expanded(
                      child: PageView(
                        controller: data.onboardingController,
                        children: data.role == 'child'
                            ? [
                          const KidOnboardingScreenOne(),
                          const KidOnboardingScreenTwo(),
                          const KidOnboardingScreenThree(),
                          const KidOnboardingScreenFour(),
                          const KidOnboardingScreenFive(),
                          const KidOnboardingScreenSix(),
                        ]
                            : [
                          const ParentOnboardingScreenOne(),
                          const ParentOnboardingScreenTwo(),
                          const ParentOnboardingScreenThree(),
                          const ParentOnboardingScreenFour(),
                          const ParentOnboardingScreenFive(),
                          const ParentOnboardingScreenSix(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () => data.onboardingController.jumpToPage(5),
                                child: Text('skip'.tr(), style: kTextStyle,)),
                            const Spacer(),
                            SmoothPageIndicator(
                              controller: data.onboardingController,
                              count: 6,
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
                                  if(data.onboardingController.page == 5){
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 4),
                  child: Row(
                    children: [
                      const Spacer(),
                      data.role == 'child'
                        ? KidRoundButton(
                          onTap: () => data.toLoginScreen(context),
                          icon: Icons.clear,)
                        : ParentRoundButton(
                            onTap: () => data.toLoginScreen(context),
                            icon: Icons.clear)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
