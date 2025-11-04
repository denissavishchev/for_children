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
    required this.snapshot,
    required this.index
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshot;
  final int index;

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
                          child: Stack(
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  child: snapshot.elementAt(index).get('imageUrl') == 'false'
                                  ? Image.asset('assets/images/cat.png', fit: BoxFit.cover)
                                  : Image.network(snapshot.elementAt(index).get('imageUrl'), fit: BoxFit.cover)),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${snapshot.elementAt(index).get('whatIsIt')}', style: kBigTextKidStyle,),
                                      Text('${snapshot.elementAt(index).get('price')} ${snapshot.elementAt(index).get('currency')}', style: kBigTextKidStyle,),
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
                                    onTap: () => data.showToAddMoney(context, snapshot.elementAt(index).id),
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
                            itemCount: snapshot.elementAt(index).get('money').length,
                              itemBuilder: (context, i){
                                final item = List.from(snapshot.elementAt(index).get('money'))[i];
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
                                    Text(item.split('/')[0], style: kTextKidStyle,),
                                    Text(DateFormat('dd-MM-yyyy').format(
                                        DateTime.parse(item.split('/')[1])), style: kTextKidStyle,),
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
