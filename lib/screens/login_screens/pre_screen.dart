import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_children/providers/login_provider.dart';
import 'package:for_children/screens/login_screens/onboarding_screens.dart';
import 'package:for_children/screens/login_screens/register_screen.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class PreScreen extends StatelessWidget {
  const PreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: Consumer<LoginProvider>(
        builder: (context, data, _){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const OnboardButtonWidget(
                  onboard: Onboard.basic,
                  text: 'basicOnboarding',
                  description: 'basicOnboardingDescription',),
                const OnboardButtonWidget(
                  onboard: Onboard.advanced,
                  text: 'advancedOnboarding',
                  description: 'advancedOnboardingDescription',),
                const OnboardButtonWidget(
                  onboard: Onboard.none,
                  text: 'withoutOnboarding',
                  description: 'withoutOnboardingDescription',),
                ButtonWidget(
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                        selectedOnboard == Onboard.basic
                            ? const OnboardingScreens()
                            : selectedOnboard == Onboard.advanced
                            ? const OnboardingScreens()
                            : const RegisterScreen())),
                    text: 'continue'
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class OnboardButtonWidget extends StatelessWidget {
  const OnboardButtonWidget({
    super.key,
    required this.onboard,
    required this.text,
    required this.description,
  });

  final Onboard onboard;
  final String text;
  final String description;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<LoginProvider>(
        builder: (context, data, _){
          return GestureDetector(
            onTap: () => data.changeOnboard(onboard),
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.2,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      onboard == selectedOnboard ? kGrey.withOpacity(0.7) : kGrey,
                      kGrey,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                      width: 3,
                      color: kGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(
                            onboard == selectedOnboard
                            ? 0.3 : 0.2),
                        blurRadius: onboard == selectedOnboard ? 2 : 6,
                        spreadRadius: onboard == selectedOnboard ? 1 : 2,
                        offset: Offset(0, onboard == selectedOnboard ? 2 : 6)
                    ),
                    BoxShadow(
                      color: kGrey.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]
              ),
              child: Column(
                children: [
                  Text(
                    text.tr(),
                    style: kBigTextStyle.copyWith(color: onboard == selectedOnboard
                        ? kBlue
                        : kBlue.withOpacity(0.5)),),
                  Text(
                    description.tr(),
                    style: kTextStyle.copyWith(color: onboard == selectedOnboard
                        ? kBlue
                        : kBlue.withOpacity(0.5)),),
                ],
              ),
            ),
          );
        }
    );
  }
}
