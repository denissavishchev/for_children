import 'package:flutter/material.dart';
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
            child: Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: kBlue.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.15,
                        decoration: BoxDecoration(
                          color: kGrey,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            color: kRed.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                            color: kDarkWhite,
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.15,
                        decoration: BoxDecoration(
                            color: kGreen.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                            color: kGrey.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                            color: kGreen.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                      child: Image.asset('assets/images/onboardingParent0.png', width: 150,)
                  ),
                  Positioned(
                      right: 0,
                      top: size.height * 0.2,
                      child: Image.asset('assets/images/onboardingParent1.png', width: 150,)
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
}
