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
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/star.png', width: 24,),
                          Text('yourWishes'.tr(), style: kBigTextStyle.copyWith(fontSize: 44.sp),),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>
                                const AddSaveMoneyScreen())),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        kWhite,
                                        kWhite.withValues(alpha: 0.01),
                                        kWhite,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topLeft,
                                      stops: [0.1, 0.8, 1]
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kWhite, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kGrey.withValues(alpha: 0.5),
                                        blurRadius: 3,
                                        spreadRadius: 1.5,
                                        offset: Offset(-0.5, 2)
                                    ),
                                  ]
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  size: 30,
                                  color: kBlue.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                      height: 200,
                                      margin: const EdgeInsets.fromLTRB(12, 3, 12, 12),
                                      padding: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                kGrey,
                                                kWhite,
                                              ]
                                          ),
                                          border: Border.all(width: 1, color: kDarkWhite),
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: kDarkGrey.withValues(alpha: 0.3),
                                              blurRadius: 4,
                                              spreadRadius: 2,
                                              offset: Offset(4, 4)
                                            )
                                          ]
                                      ),
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
                                                ? Image.asset('assets/images/cat.png', fit: BoxFit.contain)
                                                : Image.network(money[index]['imageUrl'],
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(Icons.warning, color: kOrange,),
                                                  );
                                                }),
                                          ),
                                          Column(
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



