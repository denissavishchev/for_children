import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/kid_screens/single_save_money_screen.dart';
import 'package:for_children/widgets/button_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';
import '../../widgets/round_button.dart';
import 'add_save_money_screen.dart';

class SaveMoneyScreen extends StatelessWidget {
  const SaveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      body: Consumer<KidProvider>(
        builder: (context, data, _){
          return SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  spacing: 8,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/piggy.png', width: 24,),
                          Text('yourSavings'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                          const Spacer(),
                          RoundButton(
                            icon: Icons.add_circle_outline,
                            onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const AddSaveMoneyScreen())),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('whyYouNeedEarn'.tr(), style: kTextStyle,)),
                    StreamBuilder<List<Map<String, dynamic>>>(
                        stream: Supabase.instance.client
                            .from('saveMoney')
                            .stream(primaryKey: ['id'])
                            .order('time', ascending: false),
                        builder: (context, snapshot){
                          if (!snapshot.hasData) {
                            return Expanded(
                              child: Center(
                                  child: SpinKitSpinningLines(
                                    color: kBlue,
                                    size: 150,
                                  )));
                          }
                          final money = snapshot.data!;
                          return Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80, top: 4),
                                itemCount: money.length,
                                itemBuilder: (context, index){
                                  final total = List.from(money[index]['money'] ?? [])
                                      .fold<int>(0, (s, m) => s + (int.tryParse(m.split('/')[0]) ?? 0));
                                  final percent = (total / (int.tryParse(money[index]['price'].toString()) ?? 0)) * 100;
                                    return Container(
                                      margin: const EdgeInsets.fromLTRB(12, 3, 12, 12),
                                      decoration: BoxDecoration(
                                          color: kWhite,
                                          gradient: RadialGradient(
                                            colors: [
                                              kWhite,
                                              kPurple.withValues(alpha: 0.3),
                                              kLightBlue.withValues(alpha: 0.3),
                                            ],
                                            center: Alignment.bottomLeft,
                                            radius: 1.7,
                                          ),
                                          border: Border.all(width: 1, color: kPurple),
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: kDarkBlue.withValues(alpha: 0.25),
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                                offset: Offset(4, 4)
                                            )
                                          ]
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              top: -30,
                                              right: -30,
                                              child: Icon(
                                                  Icons.euro,
                                                  color: kPurple.withValues(alpha: 0.1),
                                                  size: 300.sp)),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                      color: kBlue.withValues(alpha: 0.3),
                                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: kGrey.withValues(alpha: 0.3),
                                                            blurRadius: 4,
                                                            spreadRadius: 2,
                                                            offset: Offset(2, 0)
                                                        )
                                                      ]
                                                  ),
                                                  child: money[index]['imageUrl'] == 'false'
                                                      ? Image.asset('assets/images/cat.png', fit: BoxFit.contain, height: 200,)
                                                      : Image.network(money[index]['imageUrl'],
                                                      fit: BoxFit.contain,
                                                      height: 200,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Center(
                                                          child: Icon(Icons.warning, color: kOrange,),
                                                        );
                                                      }),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 12),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(money[index]['whatIsIt'],
                                                        style: kBigTextStyle.copyWith(fontSize: 44.sp),
                                                      ),
                                                      Row(
                                                        spacing: 12,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('$total'
                                                              '/ ${money[index]['price']} '
                                                              '${money[index]['currency']}',
                                                            style: kBigTextStyle,),
                                                        ],
                                                      ),
                                                      Row(
                                                        spacing: 8,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                            width: size.width * 0.35,
                                                            child: LinearPercentIndicator(
                                                              padding: EdgeInsets.zero,
                                                              animation: true,
                                                              percent: percent / 100,
                                                              lineHeight: 8,
                                                              backgroundColor: kBlue.withValues(alpha: 0.3),
                                                              barRadius: Radius.circular(12),
                                                              progressColor: kBlue,
                                                            ),
                                                          ),
                                                          Text('${percent.toStringAsFixed(0)}%',
                                                              style: kTextStyleNormal)
                                                        ],
                                                      ),
                                                      ButtonWidget(
                                                          onTap: () => Navigator.pushReplacement(context,
                                                              MaterialPageRoute(builder: (context) =>
                                                                  SingleSaveMoneyScreen(documentId: money[index]['id'].toString(),))),
                                                          width: 0.4,
                                                          text: 'addSomeMoney'
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                }),
                          );
                        }
                    ),
                  ],
                ),
                KidBottomNavigationBarWidget()
              ],
            ),
          );
        },
      ),
    );
  }
}



