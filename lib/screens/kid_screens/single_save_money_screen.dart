import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';

class SingleSaveMoneyScreen extends StatelessWidget {
  const SingleSaveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<KidProvider>(
        builder: (context, data, _){
          return Container(
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_money.png'),
                    fit: BoxFit.cover
                )
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: kWhite.withValues(alpha: 0.3)
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('New Phone', style: kBigTextKidStyle,),
                                  Text('200 \$', style: kBigTextKidStyle,),
                                ],
                              ),
                              const SizedBox(height: 50,),
                              CircularPercentIndicator(
                                radius: size.width * 0.3,
                                lineWidth: 25.0,
                                percent: data.saveProgress / 100,
                                progressColor: kBlue,
                                backgroundWidth: 30,
                                backgroundColor: kGrey.withValues(alpha: 0.3),
                                animation: true,
                                footer: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Text('${data.saveProgress.toInt()}% saved',
                                  style: kBigTextKidStyle,),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                              ),
                              ButtonWidget(
                                onTap: () {},
                                text: 'add',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 12, bottom: 72),
                            itemCount: 20,
                              itemBuilder: (context, index){
                              return Container(
                                width: size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: kWhite, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('50zł', style: kTextKidStyle,),
                                    Text('15.10.2025', style: kTextKidStyle,),
                                  ],
                                ),
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                  KidBottomNavigationBarWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
