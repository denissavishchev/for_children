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
          return Center(
            child: Container(
              width: size.width,
              height: size.height * 0.8,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kBlue.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text('parentText.tr()',
                          style: kTextStyle,
                          textAlign: TextAlign.justify),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Expanded(
                    child: Image.asset('assets/images/onboardingKid0.png'),
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
