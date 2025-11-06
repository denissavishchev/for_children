import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_children/constants.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../providers/kid_provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/kids_widgets/kid_bottom_navigation_bar_widget.dart';

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
              return Container(
                height: size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_money.png'),
                    fit: BoxFit.cover,
                  ),
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
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                color: kWhite.withValues(alpha: 0.3),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                    child: doc['imageUrl'] == 'false'
                                        ? Image.asset('assets/images/cat.png', fit: BoxFit.cover)
                                        : Image.network(doc['imageUrl'], fit: BoxFit.cover),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${doc['whatIsIt']}', style: kBigTextKidStyle),
                                          Text('${doc['price']} ${doc['currency']}', style: kBigTextKidStyle),
                                        ],
                                      ),
                                      const SizedBox(height: 50),
                                      CircularPercentIndicator(
                                        radius: size.width * 0.3,
                                        lineWidth: 25.0,
                                        percent: percent > 100 ? 1 : percent / 100,
                                        progressColor: kBlue,
                                        backgroundWidth: 30,
                                        backgroundColor: kGrey.withValues(alpha: 0.3),
                                        animation: true,
                                        footer: Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                '$total ${doc['currency']}',
                                                style: kBigTextKidStyle,
                                              ),
                                              Text(
                                                '${percent.toStringAsFixed(0)}% saved',
                                                style: kBigTextKidStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        circularStrokeCap: CircularStrokeCap.round,
                                      ),
                                      ButtonWidget(
                                        onTap: () => data.showToAddMoney(context, doc.id),
                                        text: 'add',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 12, bottom: 72),
                                itemCount: moneyList.length,
                                itemBuilder: (context, i) {
                                  final item = moneyList[i];
                                  final parts = item.split('/');
                                  return Container(
                                    width: size.width,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
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
                      const KidBottomNavigationBarWidget(),
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
