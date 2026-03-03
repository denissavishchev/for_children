import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:for_children/constants.dart';
import 'package:for_children/screens/kid_screens/save_money_screen.dart';
import 'package:for_children/widgets/kids_widgets/square_button_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
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
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('saveMoney')
                .doc(documentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final doc = snapshot.data!;
              final moneyList = List.from(doc['money'] ?? []);
              int total = 0;
              total = moneyList.fold<int>(0, (s, m) => s + (int.tryParse(m.split('/')[0]) ?? 0));
              final percent = (total / (int.tryParse(doc['price'].toString()) ?? 0)) * 100;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    spacing: 12,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SquareButtonWidget(
                                icon: Icons.close,
                                onTap: () => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => const SaveMoneyScreen())),
                              ),
                              Container(
                                width: size.width * 0.65,
                                height: size.height * 0.45,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(120)),
                                  color: kWhite.withValues(alpha: 0.3),
                                  border: Border.all(color: kWhite),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kDarkGrey.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 10)
                                    ),
                                  ]
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(120)),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Positioned.fill(
                                        child: doc['imageUrl'] == 'false'
                                            ? Image.asset('assets/images/cat.png', fit: BoxFit.cover)
                                            : Image.network(doc['imageUrl'], fit: BoxFit.cover),
                                      ),
                                      Container(
                                        width: size.width * 0.65,
                                        margin: const EdgeInsets.only(bottom: 24),
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: kWhite.withValues(alpha: 0.7),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                            )
                                          ]
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('${doc['whatIsIt']}', style: kBigTextKidStyle.copyWith(fontSize: 44.sp)),
                                            Text('${percent.toStringAsFixed(0)}% saved', style: kBigTextKidStyle,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('$total/', style: kTextKidStyle),
                                                Text('${doc['price']} ${doc['currency']}', style: kTextKidStyle,),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AddButtonWidget(doc: doc, data: data),
                            ],
                          ),
                          RotatedBox(
                            quarterTurns: 2,
                            child: CircularPercentIndicator(
                              radius: size.width * 0.38,
                              lineWidth: 15.0,
                              arcType: ArcType.HALF,
                              percent: percent > 100 ? 1 : percent / 100,
                              linearGradient: LinearGradient(
                                  colors: [
                                    kBlue,
                                    kBlue.withValues(alpha: 0.6),
                                  ]
                              ),
                              backgroundWidth: 30,
                              arcBackgroundColor: kGrey.withValues(alpha: 0.2),
                              animation: true,
                              reverse: true,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: moneyList.length,
                          itemBuilder: (context, i) {
                            final item = moneyList[i];
                            final parts = item.split('/');
                            return Container(
                              width: size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: kLightBlue,
                                border: Border.all(color: kWhite, width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(parts[0], style: kTextKidStyle),
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(DateTime.parse(parts[1])),
                                    style: kTextKidStyle,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({
    super.key,
    required this.doc,
    required this.data,
  });

  final DocumentSnapshot<Map<String, dynamic>> doc;
  final KidProvider data;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => data.showToAddMoney(context, doc.id),
      child: Container(
        width: 38,
        height: size.height * 0.2,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  kWhite,
                  kWhite.withValues(alpha: 0.01),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.1, 1]
            ),
            border: Border.all(color: kWhite, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(size.width * 0.45,)),
            boxShadow: [
              BoxShadow(
                  color: kGrey.withValues(alpha: 0.3),
                  blurRadius: 3,
                  spreadRadius: 1.5,
                  offset: Offset(0, 2)
              ),
            ]
        ),
        child: Center(
          child: Text('add'.tr(),
            style: kBigTextStyle.copyWith(
              color: kBlue,
            ),),
        ),
      ),
    );
  }
}
