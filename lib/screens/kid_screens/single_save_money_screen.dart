import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/kid_screens/save_money_screen.dart';
import 'package:for_children/widgets/kids_widgets/kid_round_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/kid_provider.dart';

class SingleSaveMoneyScreen extends StatelessWidget {
  const SingleSaveMoneyScreen({
    super.key,
    required this.documentId
  });

  final String documentId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kWhite,
      body: Consumer<KidProvider>(
        builder: (context, data, _) {
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('saveMoney')
                .stream(primaryKey: ['id'])
                .eq('id', documentId)
                .order('time', ascending: false),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: SpinKitSpinningLines(
                  color: kBlue,
                  size: 40,
                ));
              }
              final doc = snapshot.data!.first;
              final moneyList = List.from(doc['money'] ?? []);
              int total = 0;
              total = moneyList.fold<int>(0, (s, m) => s + (int.tryParse(m.split('/')[0]) ?? 0));
              final percent = (total / (int.tryParse(doc['price'].toString()) ?? 0)) * 100;
              return SafeArea(
                child: Stack(
                  children: [
                    Image.asset('assets/images/moneyBg.png', width: size.width, fit: BoxFit.cover),
                    Container(
                      margin: const EdgeInsets.only(top: 80),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                      child: Column(
                        spacing: 12,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KidRoundButton(
                                  icon: Icons.close,
                                  onTap: () => Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => const SaveMoneyScreen())),
                                ),
                                KidRoundButton(
                                  icon: Icons.add,
                                  onTap: () => data.showToAddMoney(context, doc['id'].toString()),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.28,),
                          Text('${doc['whatIsIt']}', style: kBigTextStyle.copyWith(fontSize: 44.sp)),
                          LinearPercentIndicator(
                            percent: (percent > 100 )? 1 : percent / 100,
                            linearGradient: LinearGradient(
                                colors: [
                                  kBlue,
                                  kBlue.withValues(alpha: 0.6),
                                ]
                            ),
                          ),
                          Text('${percent.toStringAsFixed(0)}% saved', style: kBigTextStyle,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$total/', style: kTextKidStyle),
                              Text('${doc['price']} ${doc['currency']}', style: kTextKidStyle,),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('pennyTip'.tr(), style: kTextKidStyle,),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: moneyList.length,
                              itemBuilder: (context, i) {
                                final item = moneyList[i];
                                final parts = item.split('/');
                                return Container(
                                  width: size.width,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            kBlue.withValues(alpha: 0.3),
                                            kBlue.withValues(alpha: 0.1),
                                          ]
                                      ),
                                      border: Border.all(color: kWhite, width: 1),
                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: kBlue.withValues(alpha: 0.3),
                                            blurRadius: 3,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2)
                                        )
                                      ]
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset('assets/images/calendar.png', width: 18,),
                                      const SizedBox(width: 4,),
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(DateTime.parse(parts[1])),
                                        style: kTextKidStyle,
                                      ),
                                      const SizedBox(width: 4,),
                                      Text('youSaved'.tr(), style: kTextKidStyle,
                                      ),
                                      Spacer(),
                                      Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          margin: const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(parts[0], style: kTextKidStyle)),
                                      Image.asset('assets/images/financial.png', width: 18,),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 66,
                      right: 66,
                      child: Container(
                        height: size.height * 0.4,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                  color: kWhite.withValues(alpha: 0.7),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, -5)
                              ),
                              BoxShadow(
                                  color: kDarkGrey.withValues(alpha: 0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5)
                              ),
                            ]
                        ),
                        child: doc['imageUrl'] == 'false'
                            ? Image.asset('assets/images/cat.png', fit: BoxFit.cover)
                            : Image.network(doc['imageUrl'], fit: BoxFit.cover),
                      ),
                    ),
                  ],
                )
              );
            },
          );
        },
      ),
    );
  }
}

