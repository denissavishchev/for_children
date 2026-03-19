import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';


class ParentOnboardingScreenSix extends StatelessWidget {
  const ParentOnboardingScreenSix({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            child: Stack(
              children: [
                Image.asset('assets/images/onboardingParent14.png'),
              ],
            ),
          ),
        )
    );
  }
}

