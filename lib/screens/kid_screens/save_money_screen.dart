import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/kid_screens/single_save_money_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';
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
                    StreamBuilder<List<Map<String, dynamic>>>(
                        stream: Supabase.instance.client
                            .from('saveMoney')
                            .stream(primaryKey: ['id'])
                            .order('time', ascending: false),
                        builder: (context, snapshot){
                          if (!snapshot.hasData) return CircularProgressIndicator();
                          final money = snapshot.data!;
                          return SizedBox(
                            height: size.height * 0.6,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 124),
                                itemCount: money.length,
                                itemBuilder: (context, index){
                                  final total = List.from(money[index]['money'] ?? [])
                                      .fold<int>(0, (s, m) => s + (int.tryParse(m.split('/')[0]) ?? 0));
                                  final percent = (total / (int.tryParse(money[index]['price'].toString()) ?? 0)) * 100;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) =>
                                            SingleSaveMoneyScreen(documentId: money[index]['id'].toString(),)));
                                      },
                                      child: Container(
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(money[index]['whatIsIt'],
                                                  style: kBigTextStyle,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.4,
                                                  height: size.width * 0.4,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: kBlue.withValues(alpha: 0.3),
                                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                          border: Border.all(color: kDarkWhite),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: kWhite,
                                                              spreadRadius: -4,
                                                              blurRadius: 4
                                                            ),
                                                            BoxShadow(
                                                                color: kWhite.withValues(alpha: 0.2),
                                                                spreadRadius: 4,
                                                                blurRadius: 4,
                                                                offset: Offset(-2, 2)
                                                            )
                                                          ]
                                                        ),
                                                      ),
                                                      RotatedBox(
                                                        quarterTurns: 3,
                                                        child: LinearPercentIndicator(
                                                          padding: EdgeInsets.zero,
                                                          animation: true,
                                                          lineHeight: size.width * 0.4,
                                                          percent: percent / 100,
                                                          backgroundColor: Colors.transparent,
                                                          barRadius: Radius.circular(12),
                                                          linearGradient: LinearGradient(
                                                              colors: [
                                                                kGrey,
                                                                kWhite
                                                              ]
                                                          ),
                                                          center: Align(
                                                            alignment: Alignment.centerLeft,
                                                              child: RotatedBox(
                                                                  quarterTurns: -3,
                                                                  child: Text('${percent.toStringAsFixed(0)}%',
                                                                    style: kBigTextStyle.copyWith(fontSize: 40,)))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                }),
                          );
                        }
                    ),
                    const Spacer(),
                    ButtonWidget(
                      onTap: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>
                          const AddSaveMoneyScreen())),
                      text: 'add',
                    ),
                    const SizedBox(height: 80,),
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

